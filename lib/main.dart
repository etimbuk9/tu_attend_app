import 'package:flutter/material.dart';
import 'package:tu_attend/db_connect/connector.dart';
import 'screens/homepage.dart';
import 'screens/new_homepage.dart';
import 'screens/sign_up.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserData = false;

  Future<void> getUserdata() async {
    Connector connector = Connector();
    bool output = false;
    List data = [];
    try {
      data = await connector.getData('signup');
      // print(data);
    } catch (err) {
      await connector.createSignupTable('signup');
    }
    if (data.isNotEmpty) {
      output = true;
    }
    setState(() {
      isUserData = output;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getUserdata();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: isUserData ? NewHomePage() : SignUpPage(),
      // home: const NewHomePage(),
    );
  }
}
