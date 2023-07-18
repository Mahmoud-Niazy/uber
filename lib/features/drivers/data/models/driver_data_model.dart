class DriverDataModel{
  late String name ;
  late String email ;
  late String phone;
  late String image;
  late String userId;
  String? fcmToken ;


  DriverDataModel({
    required this.phone,
    required this.email,
    required this.name,
    required this.image,
    required this.userId,
    this.fcmToken,

  });

  DriverDataModel.fromJson(Map<String,dynamic>json){
    phone=json['phone'];
    email=json['email'];
    name=json['name'];
    image=json['image'];
    userId=json['userId'];
    fcmToken=json['fcmToken'];



  }

  toMap(){
    return {
      'email': email,
      'name': name,
      'phone' : phone,
      'image' : image,
      'userId' : userId,
      'fcmToken' : fcmToken,

    };


  }
}

