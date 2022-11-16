import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tu_attend/db_connect/connector.dart';
import '../fontstyles/font_util.dart';
import 'package:tu_attend/models/networking.dart';

import 'navigation.dart';

var currentPage = Pages.settings;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Connector connector = Connector();
  String tableName = "attendance";
  bool _inProgress = false;

  void genDatabase() async {
    await connector.createDB(tableName);
    await connector.createAttendTable(tableName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          )
        ],
        leading: const CircleAvatar(
          child: Icon(Icons.camera),
        ),
        title: const Text('QrCode to Excel Clone'),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NavRow(currentPage: currentPage),
          Expanded(
            flex: 11,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(containerBorderRadius),
                  topRight: Radius.circular(containerBorderRadius),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Sync IP',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: syncURL,
                            onChanged: (value) {
                              syncURL = value;
                            },
                          ),
                        ),
                        _inProgress
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue.shade900),
                              )
                            : Icon(
                                Icons.refresh,
                                color: Colors.blue.shade900,
                              ),
                        // IconButton(
                        //   onPressed: () {
                        //     print('Sync Ongoing!');
                        //   },
                        //   icon: Icon(
                        //     Icons.refresh,
                        //     color: Colors.blue.shade900,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _inProgress = !_inProgress;
                        });
                        String url = syncURL + '/sync/';
                        Uri uri = Uri.parse(url);
                        print('Sync in progress');
                        var unsyncedData =
                            await connector.getUnsyncedData(tableName);
                        var networker = Networker(uri);
                        for (var entry in unsyncedData) {
                          Map<String, dynamic> newInfo = {};
                          entry.forEach((key, value) => newInfo[key] = value);
                          newInfo['id'] = newInfo['id'].toString();
                          var data = await networker.syncData(newInfo);
                          print(data);
                          await connector.changeSyncStatus(
                              tableName, newInfo['id']);
                        }
                        setState(() {
                          _inProgress = !_inProgress;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 0,
                        ),
                        child: const Text(
                          'Sync All Lists',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     Connector connector = Connector();
                    //     await connector.deleteAllData();
                    //   },
                    //   child: Text('Delete All Lists'),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
