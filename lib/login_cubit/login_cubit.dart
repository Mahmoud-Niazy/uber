import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/cashe_helper/cashe_helper.dart';

import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  changePasswordVisibility() {
    isPassword = !isPassword;
    emit(ChangePasswordVisibilityState());
  }

  bool isDriver = false;

  changeTypeOfUser()async {
    isDriver = !isDriver;
    await CasheHelper.SaveData(key: 'isDriver', value: isDriver);
    emit(ChangeTypeOfUserState());
  }

  userLogin({
    required String email ,
    required String password,
}) {
    emit(UserLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) async {
     await CasheHelper.SaveData(key: 'uId', value: value.user!.uid);
      emit(UserLoginSuccessfullyState(value.user!.uid));
    })
    .catchError((error){
      emit(UserLoginErrorState());
    });
  }
}
