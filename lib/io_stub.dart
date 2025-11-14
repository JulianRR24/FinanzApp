// Stub file para dart:io cuando se compila para web
// Stub file for dart:io when compiling for web

class File {
  final String path;
  File(this.path);
  
  Future<String> readAsString() async => '';
  Future<void> writeAsString(String contents) async {}
  void createSync({bool recursive = false}) {}
  Future<void> writeAsBytes(List<int> bytes) async {}
  void writeAsBytesSync(List<int> bytes) {}
  void writeAsStringSync(String contents) {}
}

class Directory {
  final String path;
  Directory(this.path);
  
  Future<bool> exists() async => false;
}

class Platform {
  static bool get isIOS => false;
  static bool get isAndroid => false;
}

