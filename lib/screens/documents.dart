import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tu_attend/db_connect/connector.dart';
import 'package:tu_attend/fontstyles/font_util.dart';
import 'package:tu_attend/screens/navigation.dart';

import 'add_to_document.dart';
import 'add_to_document2.dart';

Pages currentPage = Pages.documents;

class DocumentPage extends StatefulWidget {
  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  List events = [];
  List<Widget> eventWidgets = [];
  Connector connector = Connector();

  Future<void> getDbData() async {
    List<Widget> superList = [];
    List itemList = [];
    var dbData = await connector.getData('attendance');
    for (var item in dbData) {
      itemList.add(item['eventname']);
    }
    // print(itemList.toSet());

    for (var lName in itemList.toSet()) {
      superList.add(ListTile(
        title: ListItemWidget(lName: lName),
      ));
    }
    setState(() {
      eventWidgets = superList;
    });

    // for (var newlist in itemList.toSet()) {
    //   List temp = [];
    //   for (var items in dbData) {
    //     if (items['eventname'] == newlist) {
    //       temp.add(items);
    //     }
    //   }
    //   superList.add(temp);
    // }
    // setState(() {
    //   events = superList;
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDbData();
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return DocumentMaker();
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
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
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(containerBorderRadius),
                    topRight: Radius.circular(containerBorderRadius),
                  )),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: eventWidgets,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListItemWidget extends StatefulWidget {
  const ListItemWidget({
    Key? key,
    required this.lName,
  }) : super(key: key);

  final lName;

  @override
  State<ListItemWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Event'),
            content: Container(
              height: 50,
              child: const Center(
                child: Text('Are you sure?'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Connector inner_connector = Connector();
                  inner_connector.deleteEvent(widget.lName);
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return DocumentMaker2(
            listName: widget.lName,
          );
        }));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.lName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    // color: Colors.blue,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _showMyDialog();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade900,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return DocumentMaker2(
                          listName: widget.lName,
                        );
                      }));
                    },
                    icon: Icon(
                      Icons.arrow_right,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final IconData icon;
  final String title;

  NavButton({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
