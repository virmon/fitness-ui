import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader(
    this.text, {
    super.key,
  });
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
  const TextHeader(this.text, {super.key, this.overflow});
  final String text;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
