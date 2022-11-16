import 'package:flutter/material.dart';
import 'package:tu_attend/fontstyles/font_util.dart';

class AttendModel {
  final Map attendData;

  AttendModel({required this.attendData});
}

class AttendWidget extends StatefulWidget {
  // const AttendWidget({Key? key}) : super(key: key);

  AttendModel attendModel;
  AttendWidget({required this.attendModel});

  @override
  State<AttendWidget> createState() => _AttendWidgetState();
}

class _AttendWidgetState extends State<AttendWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.attendModel.attendData['studentNo'],
              style: TextStyle(
                color: kTemplateColor,
                fontSize: 30,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Divider(),
            // Text(widget.attendModel.attendData['time']),
            Text(widget.attendModel.attendData['hash']),
          ],
        ),
      ),
    );
  }
}
