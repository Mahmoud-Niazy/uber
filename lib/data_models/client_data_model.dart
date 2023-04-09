class ClientDataModel{
  late String name ;
  late String email ;
  late String phone;
  late String image ;

  ClientDataModel({
    required this.phone,
    required this.email,
    required this.name,
    required this.image,
});

  ClientDataModel.fromJson(Map<String,dynamic>json){
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

