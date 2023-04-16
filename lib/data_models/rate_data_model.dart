class RateDataModel{
  double? rate ;
  String? clientImage ;
  String? clientName ;

  RateDataModel({
    required this.rate,
    required this.clientName,
    required this.clientImage,
});

  RateDataModel.fromJson(Map<String,dynamic> json){
    rate = json['rate'];
    clientImage = json['clientImage'];
    clientName = json['clientName'];
  }

  toMap(){
    return {
      'rate' : rate ,
      'clientImage' : clientImage,
      'clientName' : clientName ,
    };
  }
}