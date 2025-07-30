import 'package:flutter/material.dart';

class CoverImageWidget extends StatelessWidget {
  final String coverImage;

  const CoverImageWidget({
    super.key,
    required this.coverImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Image.asset(
          coverImage,
          fit: BoxFit.fitHeight,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
