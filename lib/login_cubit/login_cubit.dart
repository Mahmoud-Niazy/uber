import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/cashe_helper/cashe_helper.dart';
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

  changeTypeOfUser() async {
    isDriver = !isDriver;
    await CasheHelper.saveData(key: 'isDriver', value: isDriver);
    emit(ChangeTypeOfUserState());
  }

  userLogin({
    required String email,
    required String password,
  }) {
    emit(UserLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.toString().trim(),
      password: password,
    ).then((user) async {
      await CasheHelper.saveData(key: 'uId', value: user.user!.uid);
      emit(UserLoginSuccessfullyState(user.user!.uid));
    })
        .catchError((error) {
      emit(UserLoginErrorState());
    });
  }
}
