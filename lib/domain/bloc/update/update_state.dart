part of 'update_bloc.dart';

class UpdateState {
  final bool canUpdate;
  final String urlApk;
  final bool isUpdating;
  final String advance;
  final bool isError;

  const UpdateState(
      {required this.canUpdate,
      required this.urlApk,
      required this.isUpdating,
      required this.advance,
      required this.isError});

  factory UpdateState.init() {
    return const UpdateState(
        canUpdate: false,
        urlApk: '',
        isUpdating: false,
        advance: '',
        isError: false);
  }

  UpdateState copyWith(
      {bool? canUpdate,
      String? urlApk,
      bool? isUpdating,
      String? advance,
      bool? isError}) {
    return UpdateState(
        urlApk: urlApk ?? this.urlApk,
        canUpdate: canUpdate ?? this.canUpdate,
        isUpdating: isUpdating ?? this.isUpdating,
        advance: advance ?? this.advance,
        isError: isError ?? this.isError);
  }
}
