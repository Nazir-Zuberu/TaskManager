// For converting and parsing object
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task.dart';

class HomeScreen extends StatefulWidget {
  static const routename = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskcontroller;

  void savedata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task newtask = Task.fromString(_taskcontroller.text);
    // prefs.setString(
    //   'task',
    //   json.encode(taskcontent.getMap()),
    // );
    // _taskcontroller.text = '';
    // prefs.remove('task');
    // Retrieving all data 
    String tasks = prefs.getString('task');
    // Decoding and converting of tasks into a list.
    //If task is empty assign an empty list otherwise decode
    //the content and convert to list
    List list = (tasks == null)? []:json.decode(tasks);
    // print(list);
    // Adding a new task to the list of tasks
    list.add(json.encode(newtask.getMap()));
    print(list);
    // Storing all task in the list to shared_preference 
    prefs.setString('task', json.encode(list));
    // Clearing the textfield 
    _taskcontroller.text = '';
    // Removing the BottomSheet from the Screen 
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _taskcontroller = TextEditingController();
  }

  @override
  void dispose() {
    _taskcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          // style: GoogleFonts.montserrat(),
        ),
      ),
      body: Center(
        child: Text('No Task added yet'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 250.0,
                color: Colors.blue[200],
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Add Task'),
                        GestureDetector(
                          child: Icon(Icons.cancel),
                          onTap: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.black,
                      indent: 10.0,
                      endIndent: 10.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: _taskcontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          fillColor: Colors.white,
                          filled: true),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      width: MediaQuery.of(context).size.width,
                      // height: 200.0,
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 10,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              onPressed: () => _taskcontroller.text = '',
                              child: Text('Reset'),
                            ),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 10,
                            child: ElevatedButton(
                              onPressed: () => savedata(),
                              child: Text('Add'),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
