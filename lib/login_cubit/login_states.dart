abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class ChangePasswordVisibilityState extends LoginStates {}

class ChangeTypeOfUserState extends LoginStates{}

class UserLoginLoadingState extends LoginStates {}
class UserLoginSuccessfullyState extends LoginStates{
  String? userId ;
  UserLoginSuccessfullyState(this.userId);
}
class UserLoginErrorState extends LoginStates{}
