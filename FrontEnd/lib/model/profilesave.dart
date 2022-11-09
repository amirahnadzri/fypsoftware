// @dart=2.9
class myprofile_default{

  static final myprofile_default _instance = myprofile_default._internal();

  factory myprofile_default() => _instance;

  myprofile_default._internal(){
    full_profile_default = "";
  }

  String full_profile_default;

  String get myfull_profile_default => full_profile_default;

  set myfull_profile_default(String value) => myfull_profile_default = value;

}