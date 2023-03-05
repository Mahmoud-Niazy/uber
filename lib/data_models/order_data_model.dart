class OrderDataModel{
  String? from ;
  String? to ;
  String? time ;
  String? date ;

  OrderDataModel({
    required this.date,
    required this.time,
    required this.from,
    required this.to,
});

  OrderDataModel.fromJson(Map<String,dynamic>json){
    date = json['date'];
    time = json['time'];
    from = json['from'];
    to = json['to'];
  }
  toMap(){
    return {
      'date' : date,
      'time' : time ,
      'from' : from ,
      'to' : to ,
    };
  }
}