class DriverDataModel{
  late String name ;
  late String email ;
  late String phone;

  DriverDataModel({
    required this.phone,
    required this.email,
    required this.name,
  });

  DriverDataModel.fromJson(Map<String,dynamic>json){
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

