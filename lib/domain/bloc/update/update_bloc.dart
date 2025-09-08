import 'package:anime/domain/repository/update/update_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';

part 'update_event.dart';

part 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateBloc() : super(UpdateState.init()) {
    final UpdateRepository updateRepository = UpdateRepository();
    on<CanUpdateMobileEvent>((event, emit) async {
      String url = '';
      final String versionInstalada =
          await updateRepository.obtenerVersionApp();
      final Map<String, dynamic> ultimaVersion =
          await updateRepository.obtenerUltimaVersionGitHub();
      for (var asset in ultimaVersion['assets']) {
        if (asset['name'].endsWith('.apk')) {
          url = asset['browser_download_url'];
        }
      }
      final String versionUltima = ultimaVersion['tag_name'];

      if (kDebugMode) {
        print('version instalada. $versionInstalada');
        print('version última. $versionUltima');
      }
      if (versionInstalada != versionUltima) {
        emit(state.copyWith(canUpdate: true, urlApk: url));
      }
    });

    on<UpdateMobileEvent>((event, emit) async {
      final int sdkVersion = await updateRepository.getSdkVersion();
      final bool canUpdate =
          await updateRepository.obtainPermissionAndroid(sdkVersion);
      final String filePath =
          await updateRepository.obtainPathAndroid(sdkVersion);
      if (!canUpdate) {
        emit(state.copyWith(
            isUpdating: false,
            canUpdate: false,
            urlApk: '',
            advance: '',
            isError: true));
        return;
      }
      try {
        final Dio dio = Dio();
        emit(state.copyWith(isUpdating: true, canUpdate: false, advance: ''));
        await dio.download(state.urlApk, filePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            final String data = (received / total * 100).toStringAsFixed(0);
            if (data != state.advance) {
              emit(state.copyWith(
                  advance: (received / total * 100).toStringAsFixed(0)));
            }
          }
        });
        emit(state.copyWith(isUpdating: false));
        final result = await OpenFile.open(filePath);
        if (result.type == ResultType.error) {
          emit(state.copyWith(isError: true));
          if (kDebugMode) {
            print('Error al abrir la APK: ${result.message}');
          }
        } else {
          emit(state.copyWith(isError: false));
          if (kDebugMode) {
            print('APK abierta correctamente para instalación');
          }
        }
      } catch (e) {
        emit(state.copyWith(isError: true));
        if (kDebugMode) {
          print('Error al descargar la APK: $e');
        }
      }
    });
  }
}
