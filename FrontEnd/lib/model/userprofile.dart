class Users {
  //String id;
  //String firstname;
  //String lastname;
  String email;
  String password;
  String username;

  Users({
    //required this.id,
    //required this.firstname,
    //required this.lastname,
    required this.email,
    required this.password,
    required this.username,
  });

  factory Users.fromJson(Map<String, dynamic> json){
    return Users(
      //id: json['id'],
      //firstname: json['firstname'],
      //lastname: json['lastname'],
      email: json["email"] as String,
      password: json["password"] as String,
      username: json["username"] as String,
    );
  }
}


/*
class UserRequest {
  String myEmail;
  String myPassword;

  UserRequest({
    required this.myEmail,
    required this.myPassword,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'myEmail': myEmail.trim(),
      'myPassword':myPassword.trim(),
    };

    return map;
  }
}

 */