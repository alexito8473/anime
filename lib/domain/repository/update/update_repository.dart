import 'dart:convert';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
class UpdateRepository {

  Future<String> obtenerVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;  // Obtiene la versión de la app
  }
  Future<bool> obtainPermissionAndroid(int sdkVersion) async {
    if (Platform.isAndroid) {
      bool canInstall = await Permission.requestInstallPackages.isGranted;
      if (!canInstall) {
        var status = await Permission.requestInstallPackages.request();
        if (!status.isGranted) {
          print("Permiso para instalar APKs denegado");
          return false;
        }
      }
    }
    if (sdkVersion <= 28) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Permiso de almacenamiento denegado");
        return false;
      }
    }
    return true;
  }
  Future<String> obtainPathAndroid(int sdkVersion) async {
    if (sdkVersion >= 29) {
      return "/storage/emulated/0/Download/update.apk";
    } else {
      return "${(await getExternalStorageDirectory())!.path}/update.apk";
    }
  }


  Future<int> getSdkVersion() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt;
  }

  Future<Map<String, dynamic>> obtenerUltimaVersionGitHub() async {
    final url = 'https://api.github.com/repos/alexito8473/anime/releases/latest';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Convertir la respuesta JSON
      final Map<String, dynamic> releaseData = json.decode(response.body);
      return releaseData;
    } else {
      throw Exception('No se pudo obtener la última versión de GitHub');
    }
  }
}