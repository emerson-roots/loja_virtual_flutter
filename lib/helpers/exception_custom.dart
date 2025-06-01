class ExceptionCustom implements Exception {
  final String message;

  ExceptionCustom(this.message);

  @override
  String toString() => message;
}
