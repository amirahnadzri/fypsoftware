class UserPref {
  UserPref(
      this.username,
      this.preference,
      this.profile_pic
      );

  String username;
  String preference;
  String profile_pic;

  UserPref.fromJson(Map<String, dynamic> json) :
        username = json['username'],
        preference = json['preference'],
        profile_pic = json['profile_pic'];


  Map<String, dynamic> toJson(){
    return {
      'username': username,
      'preference': preference,
      'profile_pic': profile_pic
    };
  }
}