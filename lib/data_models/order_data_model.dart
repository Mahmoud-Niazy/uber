class OrderDataModel{
  String? from ;
  String? to ;
  String? time ;
  String? date ;
  String? clientName;
  String? clientImage ;
  String? clientPhone ;
  double? latFrom ;
  double? latTo ;
  double? lngFrom ;
  double? lngTo ;
  String? fcmToken;
  String? orderId;
  bool? agreement ;
  dynamic price ;
  String? driverName ;
  String? driverFcmToken ;
  String? driverPhone ;
  String? driverEmail ;
  String? driverImage;
  String? driverId ;
  String? clientId ;
  dynamic dateToDeleteTheAgreement;
  String? acceptedOrderId ;
  late String dateToOrder ;


  OrderDataModel({
    required this.date,
    required this.time,
    required this.from,
    required this.to,
    required this.clientName,
    required this.clientImage,
    required this.latFrom,
    required this.latTo,
    required this.lngFrom,
    required this.lngTo,
    required this.fcmToken,
    this.orderId,
    this.agreement,
    this.price,
    this.driverImage,
    this.driverName,
    this.driverPhone,
    this.driverFcmToken,
    this.driverEmail,
    this.driverId,
    this.clientId,
    required this.dateToDeleteTheAgreement,
    this.acceptedOrderId,
    this.clientPhone,
    required this.dateToOrder,

  });

  OrderDataModel.fromJson(Map<String,dynamic>json){
    date = json['date'];
    dateToOrder = json['dateToOrder'];
    time = json['time'];
    from = json['from'];
    to = json['to'];
    clientName = json['clientName'];
    clientImage = json['clientImage'];
    latFrom = json['latFrom'];
    latTo = json['latTo'];
    lngFrom = json['lngFrom'];
    lngTo = json['lngTo'];
    fcmToken = json['fcmToken'];
    orderId = json['orderId'];
    agreement = json['agreement'];
    price = json['price'];
    driverImage = json['driverImage'];
    driverName = json['driverName'];
    driverPhone = json['driverPhone'];
    driverFcmToken = json['driverFcmToken'];
    driverEmail = json['driverEmail'];
    driverId = json['driverId'];
    clientId = json['clientId'];
    dateToDeleteTheAgreement = json['dateToDeleteTheAgreement'];
    acceptedOrderId = json['acceptedOrderId'];
    clientPhone = json['clientPhone'];



  }


  toMap(){
    return {
      'date' : date,
      'dateToOrder' : dateToOrder,
      'time' : time ,
      'from' : from ,
      'to' : to ,
      'clientName' : clientName ,
      'clientImage' : clientImage ,
      'latFrom' : latFrom ,
      'latTo' : latTo ,
      'lngFrom' : lngFrom ,
      'lngTo' : lngTo ,
      'fcmToken' : fcmToken ,
      'orderId' : orderId ,
      'agreement' : agreement ,
      'price' : price ,
      'driverImage' : driverImage ,
      'driverName' : driverName ,
      'driverPhone' : driverPhone ,
      'driverFcmToken' : driverFcmToken ,
      'driverEmail' : driverEmail ,
      'driverId' : driverId ,
      'clientId' : clientId ,
      'dateToDeleteTheAgreement' : dateToDeleteTheAgreement ,
      'acceptedOrderId' : acceptedOrderId ,
      'clientPhone' : clientPhone ,



    };
  }
}