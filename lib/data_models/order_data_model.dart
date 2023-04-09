class OrderDataModel{
  String? from ;
  String? to ;
  String? time ;
  String? date ;
  String? clientName;
  String? clientImage ;
  double? latFrom ;
  double? latTo ;
  double? lngFrom ;
  double? lngTo ;


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

  });

  OrderDataModel.fromJson(Map<String,dynamic>json){
    date = json['date'];
    time = json['time'];
    from = json['from'];
    to = json['to'];
    clientName = json['clientName'];
    clientImage = json['clientImage'];
    latFrom = json['latFrom'];
    latTo = json['latTo'];
    lngFrom = json['lngFrom'];
    lngTo = json['lngTo'];


  }
  toMap(){
    return {
      'date' : date,
      'time' : time ,
      'from' : from ,
      'to' : to ,
      'clientName' : clientName ,
      'clientImage' : clientImage ,
      'latFrom' : latFrom ,
      'latTo' : latTo ,
      'lngFrom' : lngFrom ,
      'lngTo' : lngTo ,


    };
  }
}