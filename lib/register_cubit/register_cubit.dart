
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uber_final/data_models/client_data_model.dart';
import 'package:uber_final/register_cubit/register_states.dart';
import '../data_models/driver_data_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  changePasswordVisibility() {
    isPassword = !isPassword;
    emit(ChangePasswordVisibilityState());
  }

  phoneAuth({
    required String phoneNumber,
  }) async {
    emit(PhoneAuthLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  verificationCompleted(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
    emit(PhoneAuthSuccessfullyState());
  }

  verificationFailed(FirebaseAuthException e) {
    emit(PhoneAuthErrorState());
  }

  String? verificationId;

  codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    emit(PhoneCorrectState());
  }

  codeAutoRetrievalTimeout(String verificationId) {
    emit(PhoneAuthErrorState());
  }

  checkCode({required String smsCode}) {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: smsCode,
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      emit(PhoneAuthSuccessfullyState());
    });
  }

  bool isDriver = false;

  changeTypeOfUser() {
    isDriver = !isDriver;
    emit(ChangeTypeOfUserState());
  }

  final ImagePicker picker = ImagePicker();

  File? profileImage;

  getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(GetProfileImageSuccessfullyState());
    } else {
      emit(GetProfileImageErrorState());
    }
  }


  createUser({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) {
    emit(CreateUserLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value1) {
      if (isDriver) {
        FirebaseStorage.instance
            .ref()
            .child('images/${Uri
            .file(profileImage!.path)
            .pathSegments
            .last}')
            .putFile(profileImage!)
            .then((value) {
          emit(UploadProfileImageSuccessfullyState());
          value.ref.getDownloadURL().then((value) {
            DriverDataModel driver = DriverDataModel(
              phone: phone,
              email: email,
              name: name,
              image: value,
              userId: value1.user!.uid,
            );
            FirebaseFirestore.instance.collection('drivers')
                .doc(value1.user!.uid).set(driver.toMap())
                .then((value) {
              // FirebaseMessaging.instance.subscribeToTopic('drivers');
              emit(CreateUserSuccessfullyState());
            })
                .catchError((error) {
              emit(CreateUserErrorState());
            });
          }).catchError((error) {
            emit(UploadProfileImageErrorState());
          });
        }).catchError((error) {
          emit(UploadProfileImageErrorState());
        });
      }
      else {
        FirebaseStorage.instance
            .ref()
            .child('images/${Uri
            .file(profileImage!.path)
            .pathSegments
            .last}')
            .putFile(profileImage!)
            .then((value) {
          emit(UploadProfileImageSuccessfullyState());
          value.ref.getDownloadURL().then((value) {
            ClientDataModel client = ClientDataModel(
              phone: phone,
              email: email,
              name: name,
              image: value,
              userId: value1.user!.uid,
            );
            FirebaseFirestore.instance.collection('clients')
                .doc(value1.user!.uid).set(client.toMap())
                .then((value) {
              // FirebaseMessaging.instance.subscribeToTopic('clients');
              emit(CreateUserSuccessfullyState());
            })
                .catchError((error) {
              emit(CreateUserErrorState());
            });
          }).catchError((error) {
            emit(UploadProfileImageErrorState());
          });
        }).catchError((error) {
          emit(UploadProfileImageErrorState());
        });
      }
    });
  }
}
