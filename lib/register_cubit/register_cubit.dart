
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  PhoneAuth({
    required String phoneNumber,
  }) async {
    emit(PhoneAuthLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2${phoneNumber}',
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
    print(e);
  }

  String? verificationId;

  codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    emit(PhoneCorrectState());
  }

  codeAutoRetrievalTimeout(String verificationId) {
    emit(PhoneAuthErrorState());
  }

  CheckCode({required String smsCode}) {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: this.verificationId!,
      smsCode: smsCode,
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      emit(PhoneAuthSuccessfullyState());
    });
  }

  createUser({
    required String email,
    required String password,
    required String phone,
    required String name ,
  }) {
    emit(CreateUserLoadingState());
     FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value){
       if (isDriver) {
         DriverDataModel driver = DriverDataModel(
           phone: phone,
           email: email,
           name: name,
         );
         FirebaseFirestore.instance.collection('drivers')
             .doc(value.user!.uid).set(driver.toMap())
             .then((value) {
               emit(CreateUserSuccessfullyState());
         })
             .catchError((error){
               emit(CreateUserErrorState());
         });
       }
       else {
         ClientDataModel client = ClientDataModel(
           phone: phone,
           email: email,
           name: name,
         );
         FirebaseFirestore.instance.collection('clients')
             .doc(value.user!.uid).set(client.toMap())
         .then((value) {
           emit(CreateUserSuccessfullyState());
         })
         .catchError((error){
           emit(CreateUserErrorState());
         });
       }
     });
  }

  bool isDriver = false;
  changeTypeOfUser() {
    isDriver = !isDriver;
    emit(ChangeTypeOfUserState());
  }

}
