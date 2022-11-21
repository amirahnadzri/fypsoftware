// @dart=2.9
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:appmaindesign/model.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_ocr_plugin/simple_ocr_plugin.dart';


var parsedingr;
List<ToDoElement> _toDoItems = [];
PickedFile _pickedFile;
File _croppedImage;
File _imageFile;
String _cleaningrlist;
String resultjson;
String fullprofjson;
int switchimg = 0;
String _textres = "";
String infoprof_username;
String infoprof_preference;
String infoprof_pfp;
TextEditingController _resultCtrl = TextEditingController();
TextEditingController _arrayCtrl = TextEditingController();
TextEditingController _editText = TextEditingController();
TextEditingController _controller = TextEditingController();
TextEditingController _controller1 = TextEditingController();
enum DietGroup { vegan, lacto, none, ovo, pesco, pollo, lactoovo }
String univ_username_prof = "";

class HomePage extends StatefulWidget{

  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() =>_HomePageState();
}

////////////////////////////////////////////////////////////////////////////////TODO BOTTOM NAVIGATION BAR

class _HomePageState extends State<HomePage>{

  int _currentIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ScanNav(),
    const ProfileNav(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/homepagebg.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black87, BlendMode.darken)
            )
        ),
        child: _widgetOptions.elementAt(_currentIndex),

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Scan'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Color(0xff816797),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
      ),
    );
  }
}

class ScanNav extends StatefulWidget{
  const ScanNav({Key key}) : super(key: key);

  @override
  State<ScanNav> createState() => _ScanNavState();
}


////////////////////////////////////////////////////////////////////////////////TODO SCAN IMAGE FEATURE

class _ScanNavState extends State<ScanNav> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/homepagebg.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black87, BlendMode.darken)
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 800,
                child: pickImg(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class pickImg extends StatefulWidget {
  @override
  _pickImgState createState() => _pickImgState();
}

////////////////////////////////////////////////////////////////////TODO CHOOSE IMAGE PROCESS

class _pickImgState extends State<pickImg>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/homepagebg.png'),
                  fit: BoxFit.cover,
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //////////////////////////////////////////////////////////////TODO TAKE PHOTO BUTTON

                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        color: const Color(0xfff1e3c9),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.black, width: 5)),
                    child: TextButton(
                      onPressed: () {
                        _TakePhoto(context);
                      },
                      child: const Text('Take photo', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 100,
                  ),

                  //////////////////////////////////////////////////////////////TODO CHOOSE FROM GALLERY BUTTON

                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        color: const Color(0xfff1e3c9),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.black, width: 5)),
                    child: TextButton(
                      onPressed: () {
                        _ChooseGallery(context);
                      },
                      child: const Text('Choose from Gallery', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
               height: 50,
              ),
            ],
          )
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////TODO OPEN CAMERA AND TAKE PHOTO FUNCTION

  Future<void> _TakePhoto(BuildContext c) async {
    _pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera
    );
    _cropImage(_pickedFile.path);
  }

////////////////////////////////////////////////////////////////////////////////TODO CHOOSE FROM GALLERY FUNCTION

  Future<void> _ChooseGallery(BuildContext c) async {
    _pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery
    );
    _cropImage(_pickedFile.path);
  }

////////////////////////////////////////////////////////////////////////////////TODO CROP IMAGE FUNCTION

  Future<void> _cropImage(filepath) async {
    _croppedImage = await ImageCropper().cropImage(
        sourcePath: filepath,
        maxHeight: 1080,
        maxWidth: 1080
    );
     _imageFile = File(_croppedImage.path);
    Navigator.push(
      context,MaterialPageRoute(builder: (context) => showRes()),
    );
  }
}

class showRes extends StatefulWidget {
  const showRes({Key key, this.ingredient}) : super(key: key);

  final String ingredient;
  @override
  _showResState createState() => _showResState();
}

class ToDoElement {
  String task;
  final DateTime timeOfCreation;

  ToDoElement(this.task, this.timeOfCreation);

  @override
  String toString() {
    return '{ingredient: ${task}}';
  }
}

class _showResState extends State<showRes>{

  //////////////////////////////////////////////////////////////////////////////TODO LIST OF INGR FUNCTIONS
  @override
  void dispose() {
    _editText.dispose();
    super.dispose();
  }

  void _addToDoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _toDoItems.add(ToDoElement(task, DateTime.now()));
      });
    }
  }

  void _editToDoItem(String newText, int index) {
    setState(() {
      _toDoItems[index].task = newText;
    });
  }

  void _removeTodoItem(int index) {
    setState(() => _toDoItems.removeAt(index));
  }

  _editDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              padding: const EdgeInsets.all(20),
              height: 180,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //////////////////////////////////////////////////////////////TODO INGR EDIT TEXT FIELD

                  SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        onSubmitted: (val) {
                        _addToDoItem(val);
                        _controller.clear();
                        },
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Insert ingredient',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Color.fromRGBO(81,85,126, 1), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Color.fromRGBO(81,85,126, 1), width: 2),
                          ),
                        ),
                      )),

                  //////////////////////////////////////////////////////////////TODO EDIT INGR DONE BUTTON

                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      top: 5,
                    ),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: const Color.fromRGBO(81,85,126, 1),
                      child: const Text('Done', style: TextStyle(fontSize: 18)),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      onPressed: () {
                        _editToDoItem(_controller.text, index);
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.pop(context, index);
                        _controller.clear();
                      },
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }

  Widget _buildToDoItem(String toDoText, int index) {

    ////////////////////////////////////////////////////////////////////////////TODO EACH INGR LIST ITEM

    return SizedBox(
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: Border.all(width: 1.5, color: const Color.fromRGBO(81,85,126, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  toDoText,
                  style: const TextStyle(fontSize: 15),
                ),
                onTap: () => null,
              ),
            ),

            FlatButton(
              minWidth: 10,
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.deepPurple, fontSize: 14),
              ),
              onPressed: () => _editDialog(context, index),
            ),

            FlatButton(
              minWidth: 10,
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.deepOrange, fontSize: 14),
              ),
              onPressed: () => _removeTodoItem(index),
            ),
          ],
        ),
      ),
    );
  }

  int compareElement(ToDoElement a, ToDoElement b) => a.timeOfCreation.isAfter(b.timeOfCreation) ? -1 : 1;

  Widget _buildToDoList() {
    _toDoItems.sort(compareElement);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _toDoItems.length,
            // ignore: missing_return
            itemBuilder: (context, index) {
              if (index < _toDoItems.length) {
                return _buildToDoItem(_toDoItems[index].task, index);
              }
            },
          ),
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////TODO EXTRACTING LIST OF INGR PAGE

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/ingrbg.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken)
            )
        ),
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                //////////////////////////////////////////////////////////////////TODO CROPPED IMAGE CONTAINER

                Padding(
                  padding: const EdgeInsets.only(
                      top: 40.0,
                      bottom: 20.0
                  ),
                  child: Center(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            border: Border.all(
                              color: Colors.black26,
                            )
                        ),
                        width: 350,
                        height: 200,
                        child: Image.file(_imageFile),
                    ),
                  ),
                ),

                //////////////////////////////////////////////////////////////////TODO EXTRACT INGREDIENT BUTTON

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(214,213,168, 1), borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () {
                          _onRecogniseTap();
                        },
                        child: const Text('EXTRACT',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),

                //////////////////////////////////////////////////////////////////TODO TEXT INSTRUCTION

                const SizedBox(
                  height: 20,
                ),

                const Text('1. Extract the list of ingredients.',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const Text('2. Edit or delete any mistakes on the',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const Text('list of ingredients extracted.',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const Text('3. Check the ingredients.',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),

                //////////////////////////////////////////////////////////////////TODO BUILD LIST

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                      height: 400,
                      child: _buildToDoList()),
                ),

                //////////////////////////////////////////////////////////////////TODO CHECK INGREDIENT BUTTON

                Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 30.0
                  ),
                  child: Container(
                    height: 45,
                    width: 150,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(214,213,168, 1), borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {
                        checkIngr();
                      },
                      child: const Text('CHECK',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////TODO CHECK INGR FUNCTION -> SERVER

  Future<void> checkIngr() async {

    String ing = _toDoItems.toString();
    print(ing);
    String _2space = ing.replaceAll('  ', '');
    String _brackl = _2space.replaceAll('{', '');
    String _brackr = _brackl.replaceAll('}', '');
    String _sqbrackl = _brackr.replaceAll('[', '');
    String _sqbrackr = _sqbrackl.replaceAll(']', '');
    String _ingredienttxt = _sqbrackr.replaceAll('ingredient', '');
    String _2dots = _ingredienttxt.replaceAll(':', '');
    String _finalized = _2dots.replaceAll('"', '');
    print(_finalized);

    _cleaningrlist = _finalized;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ResPage()));
    Future.delayed(Duration.zero, () => showLoadingScreen(context));

  }

////////////////////////////////////////////////////////////////////////////////TODO EXTRACT INGR FROM PRODUCT
  //TODO CREATE EDITABLE LIST OF INGR -> FINALIZED

  Future<void> _onRecogniseTap() async {

    String _result = await SimpleOcrPlugin.performOCR(_croppedImage.path);
    // TODO _result = { "code": 200, "text": "Ingredients: Enriched Corn Meal (Corn Meal   Ferrous Sulfate, Niacin, Thiamin Mononitrate,   Riboflavin, Folic Acid), Sunflower Oil, Cheddar   Cheese (Milk, Cheese Cultures, Salt, Enzymes),Whey, Maltodextrin (Made from Corn), Sea Salt   Natural Flavors, Sour Cream (Cultured Cream, Skim   Milk), Torula Yeast, Lactic Acid, and Citric Acid.   CONTAINS MILK INGREDIENTS.", "blocks": 2 }

    final json = jsonDecode(_result); // decode text from image
    String ingrjson = json["text"]; // extract "text" (Ingredients) as String
    // TODO ingrjson = Ingredients: Enriched Corn Meal (Corn Meal   Ferrous Sulfate, Niacin, Thiamin Mononitrate,   Riboflavin, Folic Acid), Sunflower Oil, Cheddar   Cheese (Milk, Cheese Cultures, Salt, Enzymes),Whey, Maltodextrin (Made from Corn), Sea Salt   Natural Flavors, Sour Cream (Cultured Cream, Skim   Milk), Torula Yeast, Lactic Acid, and Citric Acid.   CONTAINS MILK INGREDIENTS.

    String _onespacedtxt = ingrjson.replaceAll('  ', '');
    String _nodottxt = _onespacedtxt.replaceAll('.', '\n');
    String _nopartxt = _nodottxt.replaceAll(')', '');
    String _nosymboltxt = _nopartxt.replaceAll('(', '\n');
    String _parsedtxt = _nosymboltxt.replaceAll(',', '\n');
    String _finaltxt = _parsedtxt.replaceAll(': ', '\n');

    parsedingr = _finaltxt.split('\n');

    for (var ing in parsedingr){
      _addToDoItem(ing);
      _controller1.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }

    setState(() {
      _resultCtrl.text = _result;
      _arrayCtrl.text = _finaltxt;
    });
  }
}

////////////////////////////////////////////////////////////////////////////////TODO PROFILE PAGE FEATURE

class ProfileNav extends StatefulWidget{
  const ProfileNav({Key key}) : super(key: key);

  @override
  State<ProfileNav> createState() => _ProfileNavState();
}

class _ProfileNavState extends State<ProfileNav> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/profile_bg.png'),
                fit: BoxFit.cover,
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 800,
                child: myProfile(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class myProfile extends StatefulWidget {
  @override
  _myProfileState createState() => _myProfileState();
}

class _myProfileState extends State<myProfile>{

  @override
  void initState() {
    super.initState();
  }
/*
  Future _profileload (BuildContext context) async {

    Map<String, dynamic> map = jsonDecode(_myprofile.myfull_profile_default);
    var username_label = UserPref.fromJson(map);
    String myusername_profile = username_label.username;
    print(myusername_profile);

    await Future.delayed(Duration(seconds: 0));
    print("Trying to receive user information.");
    String specific_url = "https://amirah.nadzri.pythonanywhere.com/api/info_specific/" + myusername_profile;
    var myinfo_profile = await http.get(Uri.parse(specific_url));

    if (myinfo_profile.statusCode == 200) {
      print('Connected to database(non default)');
      print(myinfo_profile.body);
      fullprofjson = myinfo_profile.body;
      SeparateInfo();
    } else {
      print('Not connected to database(non default)');
      print(myinfo_profile.body);
    }
  }

 */

  DietGroup _site = DietGroup.none;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/profile_bg.png'),
                  fit: BoxFit.cover,
              )
          ),
          child: Column(
            children: [

              //////////////////////////////////////////////////////////////////TODO PROFILE PICTURE

              const Padding(
                padding: EdgeInsets.only(
                    top: 50.0,
                  bottom: 20.0
                ),
                child: Text("My Profile",
                  style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                ),
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('assets/images/user_aizat.jpeg'),
                        fit: BoxFit.cover,
                    ),
                    color: const Color.fromRGBO(81,85,126, 1),
                    borderRadius: BorderRadius.circular(100)

                ),
              ),

              const Padding(
                padding: EdgeInsets.only(
                    top: 20.0,
                ),
                child: Text("@aizart",
                  style: TextStyle(color: Colors.white, fontSize: 18,),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(
                    top: 1.0,
                ),
                child: Text("Aizat Hamizuddin",
                  style: TextStyle(color: Colors.white, fontSize: 18,),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //////////////////////////////////////////////////////////////////TODO CHOOSE DIET PREF TEXT

              const Text("Choose your diet preference.",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(
                height: 15,
              ),

              //////////////////////////////////////////////////////////////////TODO PREFERENCE RADIO BUTTONS

              Container(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                ),
                width: 250,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(81,85,126, 1),
                  borderRadius: BorderRadius.circular(40)
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('No Preference',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: Radio(
                        value: DietGroup.none,
                        groupValue: _site,
                        onChanged: (DietGroup value) {
                          setState(() {
                            _site = value;
                          });
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text('Vegan',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: Radio(
                        value: DietGroup.vegan,
                        groupValue: _site,
                        onChanged: (DietGroup value) {
                          setState(() {
                            _site = value;
                          });
                        },
                      ),
                    ),

                    ListTile(

                      title: const Text('Lactose Intolerant',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: Radio(
                        value: DietGroup.lacto,
                        groupValue: _site,
                        onChanged: (DietGroup value) {
                          setState(() {
                            _site = value;
                          });
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text('Egg Intolerant',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: Radio(
                        value: DietGroup.ovo,
                        groupValue: _site,
                        onChanged: (DietGroup value) {
                          setState(() {
                            _site = value;
                          });
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text('Pescatarian',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: Radio(
                        value: DietGroup.pesco,
                        groupValue: _site,
                        onChanged: (DietGroup value) {
                          setState(() {
                            _site = value;
                          });
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text('Pollotarian',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: Radio(
                        value: DietGroup.pollo,
                        groupValue: _site,
                        onChanged: (DietGroup value) {
                          setState(() {
                            _site = value;
                          });
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text('Lacto-ovo Vegetarian',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: Radio(
                        value: DietGroup.lactoovo,
                        groupValue: _site,
                        onChanged: (DietGroup value) {
                          setState(() {
                            _site = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////TODO SHOW RESULTS

class ResPage extends StatefulWidget{
  const ResPage({Key key}) : super(key: key);

  @override
  State<ResPage> createState() => _ResPageState();
}

class _ResPageState extends State<ResPage> {

  @override
  void initState() {
    _loadingend(context);
    super.initState();
  }

  //////////////////////////////////////////////////////////////////////////////TODO GET API CHECK THE CATEGORY

  Future _loadingend (BuildContext context) async {

    await Future.delayed(const Duration(seconds: 0));
    print("Trying to receive results.");
    String Url = "https://amirahnadzri.pythonanywhere.com/check/" + _cleaningrlist;
    var checked = await http.get(Uri.parse(Url));

    if (checked.statusCode == 200) {
      print('Connection Succesful');
      print(checked.body);
      resultjson = checked.body;
      ExtractRes();
      Navigator.pop(context);
    } else {
      print('Connection Unsuccesful');
      print(checked.body);
      Navigator.pop(context);
      showLoadFailed(context);
    }
  }

  ExtractRes(){
    Map<String, dynamic> map = jsonDecode(resultjson);
    var labelres = ListModel.fromJson(map);

    print("The label is ${labelres.label}");
    String whatlabel = labelres.label;

    if(whatlabel == "vegan"){
      setState(() {
        _textres = "This product is suitable for vegans.";
        switchimg = 1;
      });

    }
    else if(whatlabel == "lacto"){
      setState(() {
        _textres = "This product is not suitable for lactose intolerant people.";
        switchimg = 2;
      });
    }
    else if(whatlabel == "none"){
      setState(() {
        _textres = "This product is suitable for anyone without dietary restrictions.";
        switchimg = 1;
      });
    }
    else if(whatlabel == "ovo"){
      setState(() {
        _textres = "This product is not suitable for egg intolerant people.";
        switchimg = 2;
      });
    }
    else if(whatlabel == "pollo"){
      setState(() {
        _textres = "This product is suitable for pollotarians.";
        switchimg = 1;
      });
    }
    else if(whatlabel == "pesco"){
      setState(() {
        _textres = "This product is suitable for pescotarians.";
        switchimg = 1;
      });
    }
    else if(whatlabel == "lactoovo"){
      setState(() {
        _textres = "This product is suitable for lacto-ovo vegetarians.";
        switchimg = 1;
      });
    }
    else{
      print("Please scan again.");
    }
  }

  switchImg(){
    var _resultImage;

    if(switchimg==0){
      setState(() {
        _resultImage = Image(image: AssetImage('assets/images/empty.png'));
      });

    }
    else if(switchimg==1){
      setState(() {
        _resultImage = Image(image: AssetImage('assets/images/thumbsup.png'));
      });
      switchimg = 0;
    }
    else if(switchimg==2){
      setState(() {
        _resultImage = Image(image: AssetImage('assets/images/thumbsdown.png'));
      });
      switchimg = 0;
    }

    return _resultImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/resbg.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken)
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //////////////////////////////////////////////////////////////////TODO CROPPED IMAGE CONTAINER

              Padding(
                padding: const EdgeInsets.only(
                    top: 100.0,
                    bottom: 20.0
                ),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: switchImg(),
                  ),
                ),
              ),

              const Text("Results",
                style: TextStyle(color:Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 20.0
                ),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black26,

                        )
                    ),
                    width: 300,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_textres,
                          style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 20.0
                ),
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(81,85,126, 1),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.black26,
                          )
                      ),
                      width: 200,
                      height: 50,
                      child: FlatButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
                          _textres = "";
                          _toDoItems.clear();
                        },
                        child: const Text("Return to Home",
                          style: TextStyle(color: Colors.white, fontSize: 20),)),
                      )
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

}

////////////////////////////////////////////////////////////////////////////////TODO LOADING INDICATOR

void showLoadingScreen(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20,
        vertical: 300),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(10.0)
          )
        ),
        content: Column(
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Hold on!"),
            Text("We're checking the ingredients for you."),
          ],
        ),
      )
  );
}

////////////////////////////////////////////////////////////////////////////////TODO FAILED CONNECTION

void showLoadFailed(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 300),
        content: Column(
          children: const [
            Text("Failed to connect to the server."),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => showRes())),
              child: const Text('TRY AGAIN')),
        ],
      )
  );
}
