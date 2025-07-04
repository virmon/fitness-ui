Future<void> delay(bool hasDelay, [int milliseconds = 2000]) {
  if (hasDelay) {
    return Future.delayed(Duration(milliseconds: milliseconds));
  } else {
    return Future.value();
  }
}
