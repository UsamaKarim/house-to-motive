import 'package:flutter/cupertino.dart';

import 'color.dart';

class ButtonNotch extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var dotPoint = Offset(size.width / 2, 2);

    var paint_1 =
        Paint()
          ..color = bgColor
          ..style = PaintingStyle.fill;
    var paint_2 =
        Paint()
          ..color = dotColor
          ..style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(
      5,
      0,
      10,
      7,
    ); // Adjust control points for the first curve
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 2,
      size.width - 10,
      7,
    ); // Adjust control points for the second curve
    path.quadraticBezierTo(size.width - 5, 0, size.width, 0);
    path.close();
    canvas.drawPath(path, paint_1);
    canvas.drawCircle(dotPoint, 6, paint_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
