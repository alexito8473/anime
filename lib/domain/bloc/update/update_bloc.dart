import 'package:anime/domain/repository/update/update_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

part 'update_event.dart';
part 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateBloc() : super(UpdateState.init()) {
    UpdateRepository updateRepository = UpdateRepository();
    on<CanUpdateMobileEvent>((event, emit) async {
      String url = "";
      String versionInstalada = await updateRepository.obtenerVersionApp();
      Map<String, dynamic> ultimaVersion =
          await updateRepository.obtenerUltimaVersionGitHub();
      for (var asset in ultimaVersion['assets']) {
        if (asset['name'].endsWith('.apk')) {
          url = asset['browser_download_url'];
        }
      }
      String versionUltima = ultimaVersion['tag_name'];
      print("version. " + versionInstalada);
      print("version. " + versionUltima);
      if (versionInstalada != versionUltima) {
        emit(state.copyWith(canUpdate: true, urlApk: url));
      }
    });

    on<UpdateMobileEvent>((event, emit) async {
      int sdkVersion = await updateRepository.getSdkVersion();
      bool canUpdate =
          await updateRepository.obtainPermissionAndroid(sdkVersion);
      String filePath = await updateRepository.obtainPathAndroid(sdkVersion);
      if (!canUpdate) {
        emit(state.copyWith(
            isUpdating: false,
            canUpdate: false,
            urlApk: "",
            advance: "",
            isError: true));
        return;
      }
      try {
        Dio dio = Dio();
        emit(state.copyWith(isUpdating: true, canUpdate: false, advance: ""));
        await dio.download(state.urlApk, filePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            String data = (received / total * 100).toStringAsFixed(0);
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
          print("Error al abrir la APK: ${result.message}");
        } else {
          emit(state.copyWith(isError: false));
          print("APK abierta correctamente para instalación");
        }
      } catch (e) {
        emit(state.copyWith(isError: true));
        print("Error al descargar la APK: $e");
      }
    });
  }
}
