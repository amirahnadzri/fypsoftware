// @dart=2.9
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:appmaindesign/model.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_ocr_plugin/simple_ocr_plugin.dart';

import 'package:appmaindesign/listwidget.dart';

var parsedingr;
ListModel test;
List _ingrlist = [];
List<ToDoElement> _toDoItems = [];
PickedFile _pickedFile;
File _croppedImage;
File _imageFile;
bool _isEditingText = false;
TextEditingController _resultCtrl = TextEditingController();
TextEditingController _arrayCtrl = TextEditingController();
TextEditingController _editText = TextEditingController();
TextEditingController _controller = TextEditingController();
TextEditingController _controller1 = TextEditingController();


class HomePage extends StatefulWidget{
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() =>_HomePageState();
}

////////////////////////////////////////////////////////////////////////////////TODO BOTTOM NAVIGATION BAR
class _HomePageState extends State<HomePage>{

  int _currentIndex =0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const ScanNav(),
    //ProfileNav(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
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

/*
class ScanNav extends StatelessWidget{
  const ScanNav({Key key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: _scanNav(),
              )
            )
          ],
        ),
      ),
    );
  }
}
*/


////////////////////////////////////////////////////////////////////////////////TODO SCAN IMAGE FEATURE
class _ScanNavState extends State<ScanNav> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
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
              Container(
                height: 800,
                child: pickImg(),
              ),
            ],
          ),

        /*
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_indexnav == 0) ...[
              pickImg(),
            ] else if(_indexnav == 1)...[
              showRes(),
            ],
          ],
        ),
        */

        ),
      ),
    );
  }
}


/*
  //TODO OPEN CAMERA AND TAKE PHOTO FUNCTION
  Future<void> _TakePhoto(BuildContext c) async {
    _pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera
    );
    _cropImage(_pickedFile.path);
  }

  //TODO CHOOSE FROM GALLERY FUNCTION
  Future<void> _ChooseGallery(BuildContext c) async {
    _pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery
    );
    _cropImage(_pickedFile.path);
  }

  //TODO CROP IMAGE FUNCTION
  Future<void> _cropImage(filepath) async {
    _croppedImage = await ImageCropper().cropImage(
        sourcePath: filepath,
        maxHeight: 1080,
        maxWidth: 1080
    );
    setState(() {
      _imageFile = File(_croppedImage.path);
    });
  }
}
*/

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
          constraints: BoxConstraints.expand(),
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
                        color: Color(0xfff1e3c9),
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
                        color: Color(0xfff1e3c9),
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
  showRes({Key key, this.ingredient}) : super(key: key);

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

  @override
  void initState() {
    super.initState();

    /*
    _editText = TextEditingController();
    for (String ingr in _ingrlist){
      print(ingr);
    }
     */
  }

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
              padding: EdgeInsets.all(20),
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
                      color: Color.fromRGBO(81,85,126, 1),
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
        });
  }

  Widget _buildToDoItem(String toDoText, int index) {
    return SizedBox(

      ////////////////////////////////////////////////////////////////////////TODO EACH INGR LIST ITEM

      child: Container(
        height: 60,
        margin: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: Border.all(width: 1.5, color: Color.fromRGBO(81,85,126, 1)),
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

  int compareElement(ToDoElement a, ToDoElement b) =>
      a.timeOfCreation.isAfter(b.timeOfCreation) ? -1 : 1;

  Widget _buildToDoList() {
    _toDoItems.sort(compareElement);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _toDoItems.length,
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
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
                          color: Color.fromRGBO(214,213,168, 1), borderRadius: BorderRadius.circular(20)),
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
                    /*
                    Container(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(214,213,168, 1), borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () {
                          checkIngr();
                          //print(_toDoItems.toString());
                        },
                        child: const Text('CHECK',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                     */
                  ],
                ),

                //////////////////////////////////////////////////////////////////TODO TEXT INSTRUCTION

                const SizedBox(
                  height: 20,
                )

        ,
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
                  child: Container(
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
                        color: Color.fromRGBO(214,213,168, 1), borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {
                        //CircularProgressIndicator();
                        checkIngr();
                        //print(_toDoItems.toString());
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

    //_toDoItems = finalized list of ingredients after edit

    String ing = _toDoItems.toString();
    print(ing);
    String _2space = ing.replaceAll('  ', '');
    //String _1space = _2space.replaceAll(' ', '');
    String _brackl = _2space.replaceAll('{', '');
    String _brackr = _brackl.replaceAll('}', '');
    String _sqbrackl = _brackr.replaceAll('[', '');
    String _sqbrackr = _sqbrackl.replaceAll(']', '');
    String _ingredienttxt = _sqbrackr.replaceAll('ingredient', '');
    String _2dots = _ingredienttxt.replaceAll(':', '');
    String _finalized = _2dots.replaceAll('"', '');
    print(_finalized);
    String Url = "https://amirahnadzri.pythonanywhere.com/check/" + _finalized;
    //String Url = "https://amirahnadzri.pythonanywhere.com/check/" + 'ham';
    var checked = await http.get(Uri.parse(Url));

    if (checked.statusCode == 200) {
      print('dapat connect');
      print(checked.body);
    } else {
      print('tak dapat status code 200');
      print(checked.body);
    }
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
    //_ingrlist = parsedingr.toList();
    //String test = jsonEncode(_ingrlist);
    //_ingrlist = test;

    for (var ing in parsedingr){
      _addToDoItem(ing);
      _controller1.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }

    setState(() {
      //list = List<dynamic>.from(ingr);
      //_arrayCtrl.text = _result;

      _resultCtrl.text = _result;
      _arrayCtrl.text = _finaltxt;
      
    });
  }
}
/*
// TODO PROFILE
class ProfileNav extends StatelessWidget{
  const ProfileNav({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
            'Profile'
        ),
      ),
    );
  }
}
 */


