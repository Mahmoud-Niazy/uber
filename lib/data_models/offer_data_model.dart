class OfferDataModel {
  dynamic price ;
  String? driverName ;
  String? driverFcmToken ;
  String? driverPhone ;
  String? driverEmail ;
  String? driverImage;
  String? driverId;

  OfferDataModel({
    required this.driverEmail,
    required this.driverFcmToken,
    required this.driverName,
    required this.driverPhone,
    required this.price,
    required this.driverImage,
    required this.driverId,

});

  OfferDataModel.fromJson(Map<String,dynamic>json){
    price = json['price'];
    driverEmail = json['driverEmail'];
    driverFcmToken = json['driverFcmToken'];
    driverName = json['driverName'];
    driverPhone = json['driverPhone'];
    driverImage = json['driverImage'];
    driverId = json['driverId'];



  }

  toMap(){
    return {
      'price' : price,
      'driverEmail' : driverEmail,
      'driverFcmToken' : driverFcmToken,
      'driverName' : driverName,
      'driverPhone' : driverPhone,
      'driverImage' : driverImage,
      'driverId' : driverId,


    };
  }
}