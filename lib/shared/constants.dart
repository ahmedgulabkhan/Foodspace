import 'package:flutter/material.dart';

const String YOUR_ZOMATO_API_KEY = ''; // Sign up for zomato api key


class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    Paint bgPaint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    bgPaint.color = Colors.black87;
    canvas.drawPath(mainBackground, bgPaint);

    Paint circlePaint1 = Paint()..color = Color(0xFF307EFF);
    canvas.drawCircle(Offset(40.0, 40.0), 150.0, circlePaint1);

    Paint circlePaint2 = Paint()..color = Color(0xFF307EFF);
    canvas.drawCircle(Offset(50.0, height-40.0), 300.0, circlePaint2);

    Paint circlePaint3 = Paint()..color = Color(0xFF307EFF);
    canvas.drawCircle(Offset(width - 20.0, height/2 - 50.0), 80.0, circlePaint3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFF0889B6), width: 2.0)
  ),
);