abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates{}

class ChangePasswordVisibilityState extends RegisterStates{}

class PhoneAuthLoadingState extends RegisterStates{}
class PhoneAuthAutoState extends RegisterStates {}
class PhoneCorrectState extends RegisterStates{}
class PhoneAuthErrorState extends RegisterStates{}
class PhoneAuthSuccessfullyState extends RegisterStates{}

class ChangeTypeOfUserState extends RegisterStates{}

class CreateUserLoadingState extends RegisterStates{}
class CreateUserSuccessfullyState extends RegisterStates{}
class CreateUserErrorState extends RegisterStates{}


class GetProfileImageSuccessfullyState extends RegisterStates{}
class GetProfileImageErrorState extends RegisterStates{}

class UploadProfileImageSuccessfullyState extends RegisterStates{}
class UploadProfileImageErrorState extends RegisterStates{}


