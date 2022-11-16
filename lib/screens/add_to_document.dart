import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tu_attend/db_connect/connector.dart';
import 'package:tu_attend/fontstyles/font_util.dart';
import 'package:tu_attend/models/attend_model.dart';
import 'package:tu_attend/screens/scanner_screen.dart';

import 'documents.dart';

var testHash =
    utf8.encode('[${202100001},${"2022-08-19 11:50:00:000000"},${false}]');

List<AttendModel> attendStack = [
  // AttendModel(attendData: {
  //   'code': '202100001',
  //   'date': "2022-08-19 11:50:00:000000",
  //   'sync': false,
  //   'hash': sha1.convert(testHash).toString(),
  // })
];

List<Widget> getAttendList() {
  List<Widget> output = [];
  for (var item in attendStack) {
    output.add(AttendWidget(
      attendModel: item,
    ));
  }
  return output;
}

class DocumentMaker extends StatefulWidget {
  const DocumentMaker({Key? key}) : super(key: key);

  @override
  State<DocumentMaker> createState() => _DocumentMakerState();
}

class _DocumentMakerState extends State<DocumentMaker> {
  String eventTitle = 'Create New Document';
  String tableName = "attendance";
  bool eventNameEditable = true;
  bool eventNameShowing = false;
  Connector connector = Connector();

  void genDatabase() async {
    await connector.createDB(tableName);
    await connector.createAttendTable(tableName);
  }

  Future<void> addItem(newItems) async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    attendStack = [];
    genDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: !eventNameEditable,
        child: FloatingActionButton(
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            size: 30,
          ),
          onPressed: () async {
            var newatts = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
              return const ScannerPage();
            }));
            print(newatts);
            for (var item in newatts) {
              var dbItem = [
                eventTitle,
                item.attendData['studentNo'],
                item.attendData['time'],
                item.attendData['sync'],
                item.attendData['hash'],
              ];
              await connector.insertData('attendance', dbItem);
              setState(() {
                print(item.attendData['hash']);
                attendStack.add(item);
              });
            }
          },
        ),
      ),
      appBar: AppBar(
          leading: attendStack.isEmpty
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return DocumentPage();
                      }),
                    );
                  },
                )
              : IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    if (!eventTitle.contains('Create New Document')) {
                      print('pressed');
                      // for (var attend in attendStack) {
                      // var dbItem = [
                      //   eventTitle,
                      //   attend.attendData['studentNo'],
                      //   attend.attendData['time'],
                      //   attend.attendData['sync'],
                      //   attend.attendData['hash'],
                      // ];
                      // await connector.insertData('attendance', dbItem);
                      // }
                      Navigator.pop(context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text('Error'),
                              content: Text('Enter Event Title'),
                            );
                          });
                    }
                    // await connector.createDB();
                  },
                ),
          backgroundColor: Colors.blue.shade900,
          title: Text(eventTitle),
          actions: [
            Visibility(
              visible: eventTitle != 'Create New Document',
              child: IconButton(
                onPressed: () {
                  setState(() {
                    eventNameEditable = true;
                    eventNameShowing = false;
                  });
                },
                icon: Icon(
                  eventTitle == 'Create New Document'
                      ? Icons.check
                      : Icons.edit,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          ]),
      body: Column(
        children: [
          Visibility(
            visible: eventNameEditable,
            child: Expanded(
              flex: 2,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Visibility(
                        visible: eventNameEditable,
                        child: ListTile(
                          title: TextField(
                            onChanged: (value) {
                              eventTitle = value;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(70)))),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              if (eventTitle != "") {
                                setState(() {
                                  eventTitle =
                                      '$eventTitle -> ${DateTime.now()}';
                                  eventNameEditable = false;
                                  eventNameShowing = true;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.check,
                              color: kTemplateColor,
                              size: 40,
                            ),
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    // child: Visibility(
                    //   visible: eventNameShowing,
                    //   child: Column(
                    //     children: [
                    //       ElevatedButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             eventNameEditable = true;
                    //             eventNameShowing = false;
                    //           });
                    //         },
                    //         child: const Text('Edit Event Name'),
                    //       ),
                    //       Container(
                    //         child: Center(
                    //           child: Text(
                    //             'Event Name: $eventTitle',
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //               color: kTemplateColor,
                    //               fontSize: 24,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return AttendWidget(attendModel: attendStack[index]);
                },
                itemCount: attendStack.length,
              ),
            ),
          ),
          // Column(
          //   children: getAttendList(),
          // ),
        ],
      ),
    );
  }
}
