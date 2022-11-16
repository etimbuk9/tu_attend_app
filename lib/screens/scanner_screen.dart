import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tu_attend/screens/add_to_document.dart';
import 'package:tu_attend/models/attend_model.dart';
import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String? title = "TU Attendance";
  MobileScannerController cameraController = MobileScannerController();
  late AttendModel attendModel;
  List capturedAttend = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                cameraController.switchCamera();
              },
              icon: const Icon(Icons.camera_rear_outlined))
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context, capturedAttend);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) {
              //   return DocumentMaker();
              // }));
            },
          ),
        ),
        title: Text(
          title!,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: MobileScanner(
        controller: cameraController,
        allowDuplicates: false,
        onDetect: (barcode, args) {
          print(barcode.rawValue);
          setState(() async {
            title = barcode.rawValue;
            String dt = DateTime.now().toString();
            var info = utf8.encode("[${barcode.rawValue},$dt]");
            print(info);
            var hash = sha1.convert(info);
            attendModel = AttendModel(attendData: {
              'studentNo': barcode.rawValue,
              'time': dt,
              'sync': false,
              'hash': hash.toString(),
            });
            capturedAttend.add(attendModel);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(milliseconds: 5),
              content: Text("${barcode.rawValue} has been recorded"),
            ));
          });
        },
      ),
    );
  }
}
