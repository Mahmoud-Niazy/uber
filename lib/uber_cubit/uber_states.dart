abstract class UberStates {}
class UberInitialState extends UberStates{}

class BottomNavigationState extends UberStates{}

class GetUserDataLoadingState extends UberStates{}
class GetClientDataSuccessfullyState extends UberStates{}
class GetClientDataErrorState extends UberStates{}
class GetDriverDataSuccessfullyState extends UberStates{}
class GetDriverDataErrorState extends UberStates{}

class GetClientLocationLoadingState extends UberStates{}
class GetClientLocationSuccessfullyState extends UberStates{}
class GetClientLocationErrorState extends UberStates{}

class AddMarkState extends UberStates{}

class ConfirmState extends UberStates{}

class MakeOrderLoadingState extends UberStates{}
class MakeOrderSuccessfullyState extends UberStates{}
class MakeOrderErrorState extends UberStates{}