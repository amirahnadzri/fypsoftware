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

// TODO BOTTOM NAVIGATION BAR
class _HomePageState extends State<HomePage>{

  int _currentIndex =0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const ScanNav(),
    //HistoryNav(),
    //ProfileNav(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Scan'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'History'
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
        selectedItemColor: Colors.amber,
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


// TODO SCAN IMAGE FEATURE
class _ScanNavState extends State<ScanNav> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
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

class _pickImgState extends State<pickImg>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //TODO IMAGE CONTAINER
              Padding(
                padding: const EdgeInsets.only(
                    top:0.0,
                    bottom: 10.0
                ),
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black26,
                          )
                      ),
                      width: 150,
                      height: 200,
                      child: Image.asset('assets/images/yoshi.png')
                  ),
                ),
              ),

              //TODO TAKE PHOTO BUTTON
              Container(
                height: 50,
                width: 320,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    _TakePhoto(context);
                  },
                  child: const Text('Take photo',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),

              const SizedBox(
                height: 5,
              ),
              const Text('or'),
              const SizedBox(
                height: 5,
              ),

              //TODO CHOOSE FROM GALLERY BUTTON
              Container(
                height: 50,
                width: 320,
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    _ChooseGallery(context);
                  },
                  child: const Text('Choose from Gallery',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

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
                  SizedBox(
                      height: 60,
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        onSubmitted: (val) {
                      _addToDoItem(val);
                      _controller.clear();
                    },
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Insert ingredient',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                      )),
                  Container(
                    height: 65,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      top: 5,
                    ),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.red,
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
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Colors.red),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  toDoText,
                  style: const TextStyle(fontSize: 18),
                ),
                onTap: () => null,
              ),
            ),
            FlatButton(
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
              onPressed: () => _editDialog(context, index),
            ),
            FlatButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red, fontSize: 14),
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
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //TODO IMAGE CONTAINER
              Padding(
                padding: const EdgeInsets.only(
                    top:40.0,
                    bottom: 30.0
                ),
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black26,
                          )
                      ),
                      width: 350,
                      height: 300,
                      child: Image.file(_imageFile),
                  ),
                ),
              ),

              //TODO EXTRACT/CHECK INGREDIENT BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        _onRecogniseTap();
                      },
                      child: const Text('Extract Ingredient',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  Container(
                    height: 45,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        checkIngr();
                        //print(_toDoItems.toString());
                      },
                      child: const Text('Check Ingredient',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),

                ],
              ),

              //TODO LIST OF INGREDIENT TEXT/EDIT BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                        top:1.0,
                        left: 20.0
                    ),
                    child: Text('List of Ingredients',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ],
              ),

              /*
              //TODO TEXT FIELD
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0
                ),
                child: Center(
                  child:
                  TextField(
                    controller: _arrayCtrl,
                    decoration: const InputDecoration(
                        hintText: "Recognised results would be displayed here..."
                    ),
                    minLines: 10,
                    maxLines: 1000,
                    enabled: false,
                  ),
                ),
              ),

               */

              //TODO BUILD LIST
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: 500,
                    child: _buildToDoList()),
              ),
            ],
          ),
      ),
    );
  }
/*
  Widget _editTextField() {
    if (_isEditingText) {
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            setState(() {
              initialText = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _editText,
        ),
      );
    }
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
    child: Text(initialText,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
      ),
    ));
  }

 */

  Future<void> checkIngr() async {

    String ing = _toDoItems.toString();
    print(ing);
    String _2space = ing.replaceAll('  ', '');
    String _1space = _2space.replaceAll(' ', '');
    String _brackl = _1space.replaceAll('{', '');
    String _brackr = _brackl.replaceAll('}', '');
    String _sqbrackl = _brackr.replaceAll('[', '');
    String _sqbrackr = _sqbrackl.replaceAll(']', '');
    String _ingredienttxt = _sqbrackr.replaceAll('ingredient', '');
    String _2dots = _ingredienttxt.replaceAll(':', '');
    String _finalized = _2dots.replaceAll('"', '');
    print(_finalized);
    String Url = "https://amirahnadzri.pythonanywhere.com/check/" + _finalized;
    var checked = await http.get(Uri.parse(Url));

    if (checked.statusCode == 200) {
      print('dapat connect');
      print(checked.body);
    } else {
      print('tak dapat status code 200');
      print(checked.body);
    }
  }


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
    //String test = ingr.split("\n");

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
class MyListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Scrollbar(
      child: ListView.builder(
        itemBuilder:(context, index) {
          return Material(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    title: Text(ingr[index]),
                  ),
                  Divider(
                    height: 1,
                  )
                ],
              )
          );
        },
        itemCount: ingr.length,
      ),
      isAlwaysShown: true,
    );
  }
}
*/

/*
class MyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _ingrlist.length,
        itemBuilder: (context, index) => EditableListTile(
          model: _ingrlist[index],
          onChanged: (ListModel updatedModel) {
            _ingrlist[index] = updatedModel;
            },
        ));
  }
}

 */

/*
class AfterScanNav extends StatelessWidget{
  const AfterScanNav({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
            'Scan History'
        ),
      ),
    );
  }
}

// TODO HISTORY LIST
class HistoryNav extends StatelessWidget{
  const HistoryNav({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
            'Scan History'
        ),
      ),
    );
  }
}

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