import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tu_attend/fontstyles/font_util.dart';
import 'package:tu_attend/screens/scanner_screen.dart';
import 'package:tu_attend/models/attend_model.dart';
import 'package:tu_attend/db_connect/connector.dart';
import 'package:tu_attend/models/networking.dart';
import 'package:crypto/crypto.dart';
import 'package:tu_attend/custom_widgets/expandable_fab.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;

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

class DocumentMaker2 extends StatefulWidget {
  // const DocumentMaker2({Key? key}) : super(key: key);

  final listName;

  DocumentMaker2({this.listName});

  @override
  State<DocumentMaker2> createState() => _DocumentMaker2State();
}

class _DocumentMaker2State extends State<DocumentMaker2> {
  String eventTitle = "";
  String tableName = "attendance";
  bool isSynced = false;
  bool _inProgress = false;
  bool eventNameShowing = false;
  List attendStack = [];
  Connector connector = Connector();

  void genDatabase() async {
    await connector.createDB(tableName);
    await connector.createAttendTable(tableName);
  }

  void getEventData() async {
    List<AttendModel> temp = [];
    List syncStatus = [];
    eventTitle = widget.listName;
    var data = await connector.getData(tableName);
    for (var item in data) {
      // print(item);
      if (item['eventname'] == widget.listName) {
        syncStatus.add(item['sync']);
        temp.add(AttendModel(attendData: item));
        setState(() {
          attendStack = temp;
          isSynced = syncStatus.every((element) => element == '1');
        });
      }
    }
    // print(isSynced);
  }

  void downloadExcel() async {
    List<List<String>> listoflists = [];
    List<String> headers = [
      'eventname',
      'student_number',
      'scan_time',
      'sync',
      'hash'
    ];
    eventTitle = widget.listName;
    var data = await connector.getEventData(tableName, eventTitle);
    for (var item in data) {
      var data_list = item.values.toList();
      List<String> data_out = [];
      for (var x in data_list) {
        data_out.add(x.toString());
      }
      listoflists.add(data_out.sublist(1, data_out.length));
      await connector.changeSyncStatus(tableName, data_list[0]);
    }
    exportCSV.myCSV(headers, listoflists);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // attendStack = [];
    genDatabase();
  }

  @override
  Widget build(BuildContext context) {
    getEventData();
    return Scaffold(
      floatingActionButton: ExpandedFab(
        distance: 100,
        children: [
          ActionButton(
            icon: Icon(Icons.download),
            onPressed: downloadExcel,
          ),
          Visibility(
            visible: !isSynced,
            child: ActionButton(
              icon: _inProgress
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Icon(Icons.refresh),
              onPressed: () async {
                setState(() {
                  _inProgress = !_inProgress;
                });
                String url = syncURL + '/sync/';
                Uri uri = Uri.parse(url);
                print('Sync in progress');
                var unsyncedData =
                    await connector.getUnsyncedEventData(tableName, eventTitle);
                var networker = Networker(uri);
                for (var entry in unsyncedData) {
                  Map<String, dynamic> newInfo = {};
                  entry.forEach((key, value) => newInfo[key] = value);
                  newInfo['id'] = newInfo['id'].toString();
                  var data = await networker.syncData(newInfo);
                  print(data);
                  if (data['status'] == 'Success') {
                    await connector.changeSyncStatus(tableName, newInfo['id']);
                  }
                }
                setState(() {
                  _inProgress = !_inProgress;
                });
              },
            ),
          ),
          ActionButton(
            icon: const Icon(Icons.qr_code_2_rounded),
            onPressed: () async {
              print('AttendStack is ${attendStack.length}');
              var newatts = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const ScannerPage();
              }));
              print(newatts);
              setState(() async {
                for (var item in newatts) {
                  var dbItem = [
                    eventTitle,
                    item.attendData['studentNo'],
                    item.attendData['time'],
                    item.attendData['sync'],
                    item.attendData['hash'],
                  ];
                  await connector.insertData('attendance', dbItem);
                  // setState(() {
                  //   print(item.attendData['hash']);
                  //   attendStack.add(item);
                  // });
                }
              });
              //
              // print('AttendStack is ${attendStack.length}');
            },
          ),
        ],
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return DocumentPage();
              }),
            );
          },
        ),
        backgroundColor: Colors.blue.shade900,
        title: Text(eventTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 8,
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
          // Visibility(
          //   visible: !isSynced,
          //   child: Expanded(
          //       child: ElevatedButton(
          //     child: _inProgress
          //         ? CircularProgressIndicator(
          //             valueColor:
          //                 new AlwaysStoppedAnimation<Color>(Colors.white),
          //           )
          //         : Text(
          //             'Sync',
          //             style: TextStyle(fontSize: 18),
          //           ),
          //     onPressed: () async {
          //       setState(() {
          //         _inProgress = !_inProgress;
          //       });
          //       String url = syncURL + '/sync/';
          //       Uri uri = Uri.parse(url);
          //       print('Sync in progress');
          //       var unsyncedData =
          //           await connector.getUnsyncedEventData(tableName, eventTitle);
          //       var networker = Networker(uri);
          //       for (var entry in unsyncedData) {
          //         Map<String, dynamic> newInfo = {};
          //         entry.forEach((key, value) => newInfo[key] = value);
          //         newInfo['id'] = newInfo['id'].toString();
          //         var data = await networker.syncData(newInfo);
          //         print(data);
          //         if (data['status'] == 'Success') {
          //           await connector.changeSyncStatus(tableName, newInfo['id']);
          //         }
          //       }
          //       setState(() {
          //         _inProgress = !_inProgress;
          //       });
          //     },
          //   )),
          // )
        ],
      ),
    );
  }
}
