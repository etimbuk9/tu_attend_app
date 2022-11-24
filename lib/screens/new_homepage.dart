import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tu_attend/fontstyles/font_util.dart';
import 'package:tu_attend/screens/add_to_document.dart';
import 'package:tu_attend/screens/navigation.dart';
import 'package:tu_attend/db_connect/connector.dart';

import 'documents.dart';

Pages currentPage = Pages.home;

class NewHomePage extends StatefulWidget {
  const NewHomePage({Key? key}) : super(key: key);

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  Connector connector = Connector();

  Future<List<Widget>> getDbData() async {
    List<Widget> itemList = [];
    var dbData = await connector.getData('attendance');
    for (var item in dbData) {
      var widg = ListTile(
        title: item['eventname'],
      );
      itemList.add(widg);
    }
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.menu),
          //   onPressed: () {},
          // )
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
          NavRow(
            currentPage: currentPage,
          ),
          Expanded(
            flex: 11,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(containerBorderRadius),
                    topRight: Radius.circular(containerBorderRadius),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 100,
                      ),
                      radius: 100,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return DocumentMaker();
                          }),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          'Create New Event',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
