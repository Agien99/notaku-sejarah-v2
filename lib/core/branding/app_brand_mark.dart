import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBrandMark extends StatelessWidget {
  const AppBrandMark({
    this.size = 120,
    this.withBackground = true,
    super.key,
  });

  final double size;
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _BrandMarkPainter(withBackground: withBackground),
      ),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  const _BrandMarkPainter({required this.withBackground});

  final bool withBackground;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);
    final scale = shortest / 1024;
    final center = Offset(size.width / 2, size.height / 2);

    if (withBackground) {
      canvas.drawCircle(center, 512 * scale, Paint()..color = AppColors.navy);
      canvas.drawCircle(
        center,
        362 * scale,
        Paint()..color = AppColors.royalBlue,
      );
      canvas.drawCircle(
        center,
        322 * scale,
        Paint()
          ..color = AppColors.goldSoft
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10 * scale,
      );
    }

    final heritage = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18 * scale
      ..strokeCap = StrokeCap.round;

    final arch = Path()
      ..moveTo(349 * scale, 393 * scale)
      ..quadraticBezierTo(
        512 * scale,
        205 * scale,
        675 * scale,
        393 * scale,
      );
    canvas.drawPath(arch, heritage);
    canvas.drawLine(
      Offset(365 * scale, 435 * scale),
      Offset(365 * scale, 550 * scale),
      heritage,
    );
    canvas.drawLine(
      Offset(659 * scale, 435 * scale),
      Offset(659 * scale, 550 * scale),
      heritage,
    );

    final star = Path();
    for (var i = 0; i < 16; i++) {
      final angle = -math.pi / 2 + i * math.pi / 8;
      final radius = (i.isEven ? 42 : 18) * scale;
      final point = Offset(
        512 * scale + math.cos(angle) * radius,
        320 * scale + math.sin(angle) * radius,
      );
      if (i == 0) {
        star.moveTo(point.dx, point.dy);
      } else {
        star.lineTo(point.dx, point.dy);
      }
    }
    star.close();
    canvas.drawPath(star, Paint()..color = AppColors.gold);

    final leftPage = Path()
      ..moveTo(250 * scale, 540 * scale)
      ..lineTo(465 * scale, 475 * scale)
      ..lineTo(505 * scale, 515 * scale)
      ..lineTo(505 * scale, 735 * scale)
      ..lineTo(285 * scale, 790 * scale)
      ..lineTo(250 * scale, 745 * scale)
      ..close();
    final rightPage = Path()
      ..moveTo(774 * scale, 540 * scale)
      ..lineTo(559 * scale, 475 * scale)
      ..lineTo(519 * scale, 515 * scale)
      ..lineTo(519 * scale, 735 * scale)
      ..lineTo(739 * scale, 790 * scale)
      ..lineTo(774 * scale, 745 * scale)
      ..close();

    canvas.drawPath(leftPage, Paint()..color = AppColors.cream);
    canvas.drawPath(rightPage, Paint()..color = AppColors.cream);

    final pageAccent = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(270 * scale, 555 * scale),
      Offset(465 * scale, 500 * scale),
      pageAccent,
    );
    canvas.drawLine(
      Offset(754 * scale, 555 * scale),
      Offset(559 * scale, 500 * scale),
      pageAccent,
    );
    pageAccent.strokeWidth = 10 * scale;
    canvas.drawLine(
      Offset(505 * scale, 515 * scale),
      Offset(505 * scale, 735 * scale),
      pageAccent,
    );
    canvas.drawLine(
      Offset(519 * scale, 515 * scale),
      Offset(519 * scale, 735 * scale),
      pageAccent,
    );
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (size) => [
      CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: const SemanticsProperties(
          label: 'Logo Notaku Sejarah',
          image: true,
        ),
      ),
    ];
  }

  @override
  bool shouldRepaint(covariant _BrandMarkPainter oldDelegate) {
    return oldDelegate.withBackground != withBackground;
  }

  @override
  bool shouldRebuildSemantics(covariant _BrandMarkPainter oldDelegate) {
    return shouldRepaint(oldDelegate);
  }
}
