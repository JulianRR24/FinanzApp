// Stub file para imports condicionales
// Este archivo se usa cuando no estamos en web
// Stub file for conditional imports
// This file is used when we're not on web

class Blob {
  final List<dynamic> data;
  Blob(this.data);
}

class Url {
  static String createObjectUrlFromBlob(Blob blob) => '';
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  String? href;
  AnchorElement({this.href});
  void setAttribute(String name, String value) {}
  void click() {}
}

