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
  List<Task> _tasks;
  List<bool> _tasksdone;

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
    List list = (tasks == null) ? [] : json.decode(tasks);
    // print(list);
    // Adding a new task to the list of tasks
    list.add(
      json.encode(
        newtask.getMap(),
      ),
    );
    // print(list);
    // Storing all task in the list to shared_preference
    prefs.setString(
      'task',
      json.encode(list),
    );
    // Clearing the textfield
    _taskcontroller.text = '';
    // Removing the BottomSheet from the Screen
    Navigator.of(context).pop();

    _getTasks();
  }

  void _getTasks() async {
    _tasks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    for (dynamic d in list) {
      _tasks.add(
        Task.fromMap(json.decode(d)),
      );
    }
    // print(_tasks);
    // setting all values of checkbox to false
    _tasksdone = List.generate(_tasks.length, (index) => false);
    setState(() {});
  }

  void updatePendingTasksList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pendingList = [];
    for (var i = 0; i < _tasks.length; i++)
      if (!_tasksdone[i]) pendingList.add(_tasks[i]);

    var pendingListEncoded = List.generate(
      pendingList.length,
      (i) => json.encode(
        pendingList[i].getMap(),
      ),
    );
    prefs.setString('task', json.encode(pendingListEncoded));

    _getTasks();
  }

  @override
  void initState() {
    super.initState();
    _taskcontroller = TextEditingController();

    _getTasks();
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
        actions: [
          IconButton(
            onPressed: updatePendingTasksList,
            icon: Icon(Icons.save),
          ),
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('task', json.encode([]),);

              _getTasks();
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: (_tasks == null)
          ? Center(
              child: Text('No Task added yet'),
            )
          : ListView(
              controller: ScrollController(),
              children: _tasks
                  .map((e) => Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        padding: const EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.black, width: 0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.task),
                            Checkbox(
                              value: _tasksdone[_tasks.indexOf(e)],
                              key: GlobalKey(),
                              onChanged: (val) {
                                setState(() {
                                  _tasksdone[_tasks.indexOf(e)] = val;
                                });
                              },
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
      // : Column(
      //     children: ListView()  _tasks
      //         .map((e) => Container(
      //               height: 70.0,
      //               width: MediaQuery.of(context).size.width,
      //               margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5.0),
      //               padding: const EdgeInsets.only(left: 10.0),
      //               alignment: Alignment.centerLeft,
      //               child: Text(e.task),
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(5.0),
      //                 border: Border.all(
      //                   color: Colors.black,
      //                   width: 0.5,
      //                 )
      //               ),
      //             )    )
      //         .toList(),
      //     ),
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
