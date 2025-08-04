import 'package:code_editor/code_editor.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'file_editor_event.dart';
part 'file_editor_state.dart';

class FileEditorBloc extends HydratedBloc<FileEditorEvent, FileEditorState> {
  FileEditorBloc() : super(FileEditorState.init()) {
    on<UpdateFileEvent>((event, emit) {
      emit(state.copy());
    });
  }

  @override
  FileEditorState? fromJson(Map<String, dynamic> json) {
    return FileEditorState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(FileEditorState state) {
    return state.toJson();
  }
}
