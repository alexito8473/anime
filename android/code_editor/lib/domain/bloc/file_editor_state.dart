part of 'file_editor_bloc.dart';

class FileEditorState {
  final List<FileEditor> fileEditor;

  FileEditorState({required this.fileEditor});

  factory FileEditorState.init() {
    final List<FileEditor> fileEditor = List.empty(growable: true);
    fileEditor.add(
      FileEditor(
        name: "main.js",
        language: "javascript",
        code: "console.log(\"Prueba\")",
      ),
    );
    return FileEditorState(fileEditor: fileEditor);
  }

  FileEditorState copy({List<FileEditor>? fileEditor}) {
    return FileEditorState(fileEditor: fileEditor ?? this.fileEditor);
  }

  /// Serialización a JSON
  Map<String, dynamic> toJson() => {
    'fileEditor': fileEditor.map((f) => f.toJson()).toList(),
  };

  /// Deserialización desde JSON
  factory FileEditorState.fromJson(Map<String, dynamic> json) {
    return FileEditorState(
      fileEditor: (json['fileEditor'] as List<dynamic>)
          .map((item) => FileEditor.fromJson(item))
          .toList(),
    );
  }
}
