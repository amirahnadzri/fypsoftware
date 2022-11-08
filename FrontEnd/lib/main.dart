// @dart=2.9

import 'dart:ui';

import 'package:appmaindesign/model/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:appmaindesign/HomePage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

////////////////////////////////////////////////////////////////////////////////TODO LOGIN PAGE

class _LoginPageState extends State<LoginPage> {

  var emailcontroller = TextEditingController();
  var pwcontroller = TextEditingController();
  var value;

  bool isApiCallProcess = false;
  Users loginRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    //String uri = 'https://reqres.in/api/login';
    String urilg = 'https://amirahnadzri.pythonanywhere.com/api/login/';
    if (emailcontroller.text.isNotEmpty && pwcontroller.text.isNotEmpty){
      var responseget = await http.post(Uri.parse(urilg),
          body:(
              {
                'username':emailcontroller.text,
                'password':pwcontroller.text
              }
              ));

      if(responseget.statusCode==200){
        print('dapat login');
        print(responseget.body);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
        Future.delayed(Duration.zero, () => showAlert(context));
      } else {
        print('wrong credentials');
        print(responseget.body);
      }
    } else {
      print('awat kosong');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black87, BlendMode.darken)
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //////////////////////////////////////////////////////////////////TODO APP LOGO OR IMAGE

              Padding(
                padding: const EdgeInsets.only(
                    top:40.0,
                    bottom: 10.0
                ),
                child: Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    child: Image.asset('assets/images/title.png')
                  ),
                ),
              ),

              //////////////////////////////////////////////////////////////////TODO USERNAME INPUT BOX

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                    height: 60,
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  child: Center(
                    child: TextFormField(
                      controller: emailcontroller,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                          labelText: 'Username',
                          labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                          hintText: 'Enter username',
                          hintStyle: TextStyle(fontSize: 20, color: Colors.black)
                      ),
                    ),
                  ),
                ),
              ),

              //////////////////////////////////////////////////////////////////TODO PASSWORD INPUT BOX

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: 60,
                    width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: TextFormField(
                      controller: pwcontroller,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(Icons.lock, color: Colors.black),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),

              //////////////////////////////////////////////////////////////////TODO FORGOT PASSWORD

              const Padding(
                padding: EdgeInsets.only(
                    right: 30.0,
                    bottom: 10.0
                ),
                child: Center(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: null,
                      child: Text('Forgot Password?',
                        style: TextStyle(color: Color.fromRGBO(214,213,168, 1), fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),

              //////////////////////////////////////////////////////////////////TODO LOGIN BUTTON

              Container(
                height: 50,
                width: 270,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(81,85,126, 1), borderRadius: BorderRadius.circular(40)),
                child: FlatButton(
                  onPressed: (){
                    login();
                  },
                  child: const Text('Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),

              const SizedBox(
                height: 5,
              ),
              const Text('or', style: TextStyle(color: Colors.white)),
              const SizedBox(
                height: 5,
              ),

              //////////////////////////////////////////////////////////////////TODO CONTINUE AS GUEST

              Container(
                height: 50,
                width: 270,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(214,213,168, 1), borderRadius: BorderRadius.circular(40)),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
                    Future.delayed(Duration.zero, () => showAlert(context));
                  },
                  child: const Text('Continue as Guest',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //////////////////////////////////////////////////////////////////TODO NEW USER? SIGN UP

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('New User?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegPage()),
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////TODO DEMO GIF/VIDEO POP-UP

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("This will be the gif instruction how to use the app"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('GOT IT!')
          ),
        ],
      )
    );
  }
}

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

/////////////////////////////////////////////////////////////////////////////////TODO REGISTER SIGN UP PAGE

class _RegPageState extends State<RegPage> {

  var su_emailctrl = TextEditingController();
  var su_usernamectrl = TextEditingController();
  var su_fnctrl = TextEditingController();
  var su_lnctrl = TextEditingController();
  var su_pwctrl = TextEditingController();
  var su_repwctrl = TextEditingController();

  Future<void> signup() async {

    String urireg = 'https://amirahnadzri.pythonanywhere.com/api/register/';

    if (su_emailctrl.text.isNotEmpty && su_usernamectrl.text.isNotEmpty &&
        su_fnctrl.text.isNotEmpty && su_lnctrl.text.isNotEmpty &&
        su_pwctrl.text.isNotEmpty && su_repwctrl.text.isNotEmpty) {
      if (su_pwctrl.text == su_repwctrl.text) {
        var resp_get = await http.post(Uri.parse(urireg),
            body: (
                {
                  "username": su_usernamectrl.text,
                  "password": su_pwctrl.text,
                  "email": su_emailctrl.text,
                  "first_name": su_fnctrl.text,
                  "last_name": su_lnctrl.text,
                }
            ));
        if (resp_get.statusCode == 200) {
          print('dapat register');
          print(resp_get.body);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
          Future.delayed(Duration.zero, () => showAlert(context));
        } else {
          print('tak dapat status code 200');
          print(resp_get.body);
        }
      }
      else {
        print('password re-enter different');
      }
    }
    else {
      print('awat kosong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/signupbg.png'),
              fit: BoxFit.cover
          )
        ),
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ////////////////////////////////////////////////////////////////////TODO SIGNUP TEXT IMAGE

            Padding(
              padding: const EdgeInsets.only(
                  top:40.0,
                  bottom: 10.0
              ),
              child: Center(
                child: Container(
                    width: 300,
                    height: 100,
                    child: Image.asset('assets/images/signuptext.png')
                ),
              ),
            ),

            ////////////////////////////////////////////////////////////////////TODO INPUT TEXT DETAILS

            Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 40.0,
                    bottom: 40.0
                ),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: su_emailctrl,
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.8),
                        filled: true,
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        icon: Icon(Icons.email, color: Colors.white),
                        hintText: 'Enter a valid email address',
                        hintStyle: TextStyle(fontSize: 17, color: Colors.black)
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      controller: su_usernamectrl,
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.8),
                        filled: true,
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        icon: Icon(Icons.person, color: Colors.white),
                        hintText: 'Enter username',
                        hintStyle: TextStyle(fontSize: 17, color: Colors.black)
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      controller: su_fnctrl,
                      decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.8),
                          filled: true,
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          icon: Icon(Icons.person, color: Colors.white),
                          hintText: 'Enter your first name',
                          hintStyle: TextStyle(fontSize: 17, color: Colors.black)
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      controller: su_lnctrl,
                      decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.8),
                          filled: true,
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          icon: Icon(Icons.person, color: Colors.white),
                          hintText: 'Enter your last name',
                          hintStyle: TextStyle(fontSize: 17, color: Colors.black)
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      controller: su_pwctrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.8),
                          filled: true,
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          icon: Icon(Icons.lock, color: Colors.white),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(fontSize: 17, color: Colors.black)
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      controller: su_repwctrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.8),
                          filled: true,
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          icon: Icon(Icons.lock, color: Colors.white),
                          hintText: 'Re-enter your password',
                          hintStyle: TextStyle(fontSize: 17, color: Colors.black)
                      ),
                    ),
                  ],
                )
            ),

            ////////////////////////////////////////////////////////////////////TODO SIGN UP BUTTON
            Container(
              height: 50,
              width: 270,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(81,85,126, 1),
                  borderRadius: BorderRadius.circular(40)),
              child: FlatButton(
                onPressed: (){
                  signup();
                },
                child: const Text('Create Account',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),

            const SizedBox(
              height: 5,
            ),
            const Text('or', style: TextStyle(color: Colors.white)),
            const SizedBox(
              height: 5,
            ),

            ////////////////////////////////////////////////////////////////////TODO CONTINUE AS GUEST
            Container(
              height: 50,
              width: 270,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(214,213,168, 1), borderRadius: BorderRadius.circular(40)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
                  Future.delayed(Duration.zero, () => showAlert(context));
                },
                child: const Text('Continue as Guest',
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),

            const SizedBox(
              height: 0,
            ),

            ////////////////////////////////////////////////////////////////////TODO NEW USER? SIGN UP

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?',
                      style: TextStyle(color: Colors.white),),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: const Text('Login')),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
      ),
    );
  }
  //////////////////////////////////////////////////////////////////////////////TODO DEMO GIF/VIDEO POP-UP
  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text("This will be the gif instruction how to use the app"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('GOT IT!')),
          ],
        ));
  }
}

