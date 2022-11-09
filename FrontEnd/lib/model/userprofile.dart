class Users {
  //String id;
  //String firstname;
  //String lastname;
  String email;
  String password;
  String username;
  String imagePath;

  Users({
    //required this.id,
    //required this.firstname,
    //required this.lastname,
    required this.email,
    required this.password,
    required this.username,
    required this.imagePath,
  });

  factory Users.fromJson(Map<String, dynamic> json){
    return Users(
      //id: json['id'],
      //firstname: json['firstname'],
      //lastname: json['lastname'],
      email: json["email"] as String,
      password: json["password"] as String,
      username: json["username"] as String,
      imagePath: json["imageprofile"] as String,
    );
  }
}
