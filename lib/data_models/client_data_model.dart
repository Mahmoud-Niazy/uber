class ClientDataModel{
  late String name ;
  late String email ;
  late String phone;

  ClientDataModel({
    required this.phone,
    required this.email,
    required this.name,
});

  ClientDataModel.fromJson(Map<String,dynamic>json){
    phone=json['phone'];
    email=json['email'];
    name=json['name'];
  }

  toMap(){
    return {
      'email': email,
      'name': name,
      'phone' : phone,
    };

    
  }
}

