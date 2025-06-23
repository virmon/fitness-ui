import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 22,
      ),
    );
  }
}

class TextHeader extends StatelessWidget {
  const TextHeader({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
