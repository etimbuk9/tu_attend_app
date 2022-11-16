import 'package:flutter/material.dart';
import 'package:tu_attend/fontstyles/font_util.dart';
import 'scanner_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int localRecords = 0;
  String barcode = "";
  bool cameraOn = false;
  late Widget scanner;

  Future _cameraScanning() async {
    print('Camera On!');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScannerPage();
    }));
    // await Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          _cameraScanning();
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('See Records'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu_book_rounded),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.camera_alt,
                size: 30,
              )),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        // leading: const Icon(
        //   Icons.menu,
        //   size: 24,
        // ),
        title: const Text(
          'TU Attendance',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RecordCard(
                records: localRecords,
                cardTitle: 'Local Records',
              ),
              RecordCard(
                records: 25,
                cardTitle: 'Uploaded Records',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordCard extends StatelessWidget {
  final records;
  final cardTitle;

  RecordCard({this.records, this.cardTitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${cardTitle}',
              style: kCardHeaderFont,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${records}',
              style: kRecordCounterFont,
            ),
            // Text('Local Records'),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
