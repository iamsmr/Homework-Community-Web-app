import 'package:flutter/material.dart';

final primarySwaches = Colors.teal;
final logoText = Row(
  children: [
    SizedBox(width: 17),
    Text('Homework '),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      color: Colors.white,
      child: Text(
        'Communities',
        style: TextStyle(color: primarySwaches),
      ),
    ),
  ],
);
final side = Expanded(
  flex: 1,
  child: Container(
    height: double.infinity,
    color: primarySwaches,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 200),
          Container(
            height: 200,
            width: 400,
            child: Image.asset(
              'images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
          Text(
            'Homework ',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 7),
            color: Colors.white,
            child: Text(
              'Communities',
              style: TextStyle(
                color: primarySwaches,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
