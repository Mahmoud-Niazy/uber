class MessegeDataModel {
  String? text;
  String? recieverId;
  String? date;
  String? time;
  String? senderId ;
  var dateTime;


  MessegeDataModel({
    required this.time,
    required this.recieverId,
    required this.text,
    required this.date,
    required this.senderId,
    required this.dateTime,
  });

  MessegeDataModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    recieverId = json['recieverId'];
    text = json['text'];
    date = json['date'];
    dateTime = json['dateTime'];
    senderId = json['senderId'];


  }

  toMap(){
    return {
      'time' : time ,
      'driverId' : recieverId ,
      'text' : text ,
      'date' : date ,
      'dateTime' : dateTime ,
      'senderId' : senderId ,


    };
  }
}
