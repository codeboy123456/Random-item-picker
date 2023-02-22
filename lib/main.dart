import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.yellow,
      ),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //This is the variable that holes the result of the random picked name.
  String result = '';
  //This is the variable that holds the string of the input field.
  String itemText = '';
  //This is the variable that holds the list of items for the spinner.
  List<String> stringList = ['Zoe','Max','Alexander','Ryan','Mealody','Urge'];
  //This is the stream controller for the spinning wheel.
  StreamController<int> controller = StreamController<int>.broadcast();
  // This is the item to control text in textfield
  TextEditingController txtEditController = TextEditingController();

  //Method to create the list for the spinner
  List<FortuneItem> getWheelItems() {
    List<FortuneItem> _list = [
      FortuneItem(child: Text('Enter Data')),
      FortuneItem(child: Text('Enter Data')),
    ];
    if (stringList.isNotEmpty && stringList.length > 1) {
      _list = [];
      for (var i = 0; i < stringList.length; i++) {
        _list.add(FortuneItem(
            child: Text(
              stringList[i],
              style: TextStyle(),
            )));
      }
    }

    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //This is the top bar that has the title of the app in it.
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Random Item Picker'),
            GestureDetector(
                onTap: (){
                  result = '';
                  itemText = '';
                  stringList = [];
                  txtEditController.clear();
                  getWheelItems();
                  setState(() {

                  });


                },
                child: Icon(Icons.refresh)),
          ],
        ),
      ),
      //This is the body of the app, so everything below the app bar.
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // This widget shows the text at the top of the body.
              const Text('Items List:'),
              // This widget shows the user input field.
              Container(
                color: Colors.blue.withOpacity(0.2),
                child: TextFormField(
                  controller: txtEditController,
                  maxLines: 1,
                ),
              ),
              TextButton.icon(
                  onPressed: () {
                    stringList.add(txtEditController.text);
                    txtEditController.clear();
                    setState(() {});
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Item')),
              SizedBox(
                height: 100,
              ),
              Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: FortuneWheel(
                  selected: controller.stream,
                  items: getWheelItems(),
                  duration: Duration(seconds: 2),
                ),
              ),
              // This widget shows the button to run randomly spin the wheel.
              TextButton(
                onPressed: () async {
                  int _itemInt = Random().nextInt(stringList.length);
                  controller.add(_itemInt);
                  await Future.delayed(Duration(seconds: 2));
                  result = stringList[_itemInt];
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Congratulations'),
                      content: Text('$result is the winner!!!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(Icons.refresh_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}