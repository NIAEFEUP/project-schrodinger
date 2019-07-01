import 'package:flutter/material.dart';

class DateRectangle extends StatelessWidget {

  final String date;

  DateRectangle({
    Key key,
    @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.only(bottom: 14),
      child: Text( date ,
          style: Theme.of(context).textTheme.subtitle),
      alignment: Alignment.center,
      width: double.infinity,
    );
  }
}