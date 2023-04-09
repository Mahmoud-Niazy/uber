class DriverDataModel{
  late String name ;
  late String email ;
  late String phone;
  late String image;


  DriverDataModel({
    required this.phone,
    required this.email,
    required this.name,
    required this.image,

  });

  DriverDataModel.fromJson(Map<String,dynamic>json){
    phone=json['phone'];
    email=json['email'];
    name=json['name'];
    image=json['image'];

  }

  toMap(){
    return {
      'email': email,
      'name': name,
      'phone' : phone,
      'image' : image,

    };


  }
}

