import 'package:flutter/material.dart';
import 'package:tu_attend/db_connect/connector.dart';
import 'package:tu_attend/screens/new_homepage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String fName = '';
  String sName = '';
  String sNumber = '';
  Connector connector = Connector();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: const Icon(
                  Icons.qr_code_2,
                  size: 200,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    fName = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'First Name',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    sName = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Surname',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    sNumber = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Student Number',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  List data = [];
                  try {
                    data = await connector.getData('signup');
                  } catch (err) {
                    await connector.createSignupTable('signup');
                    print('E no work');
                  }
                  if (data.isNotEmpty) {
                    print('info Dey');
                  } else {
                    if (fName != "" && sName != "" && sNumber != "") {
                      await connector.insertSignupData(
                        'signup',
                        [fName, sName, sNumber],
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return NewHomePage();
                        }),
                      );
                    } else {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Container(
                                child: Text('Complete All Data'),
                              ),
                            );
                          });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
