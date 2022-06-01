import 'package:flutter/material.dart';

class MyShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = const Color(0xffaaffcc);
    path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, 0, size.height * 0.29, 0, size.height * 0.29);
    path.cubicTo(0, size.height * 0.29, size.width * 0.05, size.height * 0.09,
        size.width * 0.42, size.height * 0.1);
    path.cubicTo(size.width * 0.79, size.height * 0.1, size.width,
        size.height * 0.07, size.width, 0);
    path.cubicTo(size.width, 0, 0, 0, 0, 0);
    canvas.drawPath(path, paint);

    // Path number 2

    paint.color = const Color(0xffaaffcc);
    path = Path();
    path.lineTo(size.width, size.height);
    path.cubicTo(size.width, size.height, size.width, size.height * 0.71,
        size.width, size.height * 0.71);
    path.cubicTo(size.width, size.height * 0.71, size.width * 0.95,
        size.height * 0.91, size.width * 0.58, size.height * 0.91);
    path.cubicTo(size.width / 5, size.height * 0.9, 0, size.height * 0.93, 0,
        size.height);
    path.cubicTo(
        0, size.height, size.width, size.height, size.width, size.height);
    canvas.drawPath(path, paint);

    // Path number 3

    paint.color = const Color(0xff2aff80);
    path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, 0, size.height * 0.23, 0, size.height * 0.23);
    path.cubicTo(0, size.height * 0.23, size.width * 0.05, size.height * 0.07,
        size.width * 0.42, size.height * 0.07);
    path.cubicTo(size.width * 0.79, size.height * 0.08, size.width,
        size.height * 0.04, size.width, 0);
    path.cubicTo(size.width, 0, 0, 0, 0, 0);
    canvas.drawPath(path, paint);

    // Path number 4

    paint.color = const Color(0xff2aff80);
    path = Path();
    path.lineTo(size.width, size.height);
    path.cubicTo(size.width, size.height, size.width, size.height * 0.78,
        size.width, size.height * 0.78);
    path.cubicTo(size.width, size.height * 0.78, size.width * 0.95,
        size.height * 0.93, size.width * 0.58, size.height * 0.93);
    path.cubicTo(size.width / 5, size.height * 0.93, size.width * 0.01,
        size.height * 0.96, 0, size.height);
    path.cubicTo(
        0, size.height, size.width, size.height, size.width, size.height);
    canvas.drawPath(path, paint);

    // Path number 5

    paint.color = const Color(0xffffffff).withOpacity(0);
    path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(
        size.width, 0, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, 0, 0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
