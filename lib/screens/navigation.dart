import 'package:flutter/material.dart';
import 'package:tu_attend/screens/settings.dart';
import 'documents.dart';
import 'new_homepage.dart';
import 'package:tu_attend/db_connect/connector.dart';

enum Pages {
  home,
  documents,
  settings,
}

class NavRow extends StatelessWidget {
  // const NavRow({
  //   Key? key,
  // }) : super(key: key);

  final currentPage;
  NavRow({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        color: Colors.blue.shade900,
        // height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavButton(
                icon: Icons.home,
                title: 'Home',
                buttonFunction: () {
                  if (currentPage != Pages.home) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return NewHomePage();
                    }), (route) => false);
                  }
                },
              ),
              NavButton(
                icon: Icons.document_scanner_outlined,
                title: 'Activities',
                buttonFunction: () async {
                  if (currentPage != Pages.documents) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return DocumentPage();
                      }),
                    );
                  }
                },
              ),
              NavButton(
                icon: Icons.refresh,
                title: 'Sync',
                buttonFunction: () {
                  if (currentPage != Pages.settings) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return SettingsPage();
                    }));
                  }
                },
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
  final buttonFunction;

  NavButton(
      {required this.icon, required this.title, required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: buttonFunction,
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
