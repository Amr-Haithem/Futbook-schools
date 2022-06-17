import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataOfUserAndFieldIndexOnly.dart';

class SingleFieldBlock extends StatefulWidget {
  final int indexOfFieldBlock;
  final User user;

  const SingleFieldBlock({required this.indexOfFieldBlock, required this.user});

  @override
  _SingleFieldBlockState createState() => _SingleFieldBlockState();
}

class _SingleFieldBlockState extends State<SingleFieldBlock> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        textStyle: TextStyle(
          //color: Colors.yellow,
          fontSize: 50,
        ),
        primary: Colors.lightGreenAccent,
        minimumSize: Size(250.0, 210.0),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/Slots',
            arguments: DataOfUserAndFieldIndexOnly(
                user: widget.user, indexOfThisField: widget.indexOfFieldBlock));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("ملعب ",
              style: TextStyle(
                fontFamily: "Cairo",
                color: Colors.black,
                fontSize: 50,
              )),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(.8),
              ),
              alignment: Alignment.center,
              width: 120,
              child: Text((widget.indexOfFieldBlock).toString(),
                  style: TextStyle(
                    fontFamily: "Cairo",
                    color: Colors.black,
                    fontSize: 50,
                  ))),
        ],
      ),
    );
  }
}
