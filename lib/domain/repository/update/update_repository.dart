import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateRepository {
  Future<String> obtenerVersionApp() async => (await PackageInfo.fromPlatform())
      .version; // Obtiene la versión de la app

  Future<bool> obtainPermissionAndroid(int sdkVersion) async {
    if (Platform.isAndroid) {
      final bool canInstall = await Permission.requestInstallPackages.isGranted;
      if (!canInstall) {
        final status = await Permission.requestInstallPackages.request();
        if (!status.isGranted) {
          if (kDebugMode) {
            print('Permiso para instalar APKs denegado');
          }
          return false;
        }
      }
    }
    if (sdkVersion <= 28) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (kDebugMode) {
          print('Permiso de almacenamiento denegado');
        }
        return false;
      }
    }
    return true;
  }

  Future<String> obtainPathAndroid(int sdkVersion) async {
    if (sdkVersion >= 29) {
      return '/storage/emulated/0/Download/update${DateTime.now().hour}.apk';
    } else {
      return '${(await getExternalStorageDirectory())!.path}/update${DateTime.now().hour}.apk';
    }
  }

  Future<int> getSdkVersion() async =>
      (await DeviceInfoPlugin().androidInfo).version.sdkInt;

  Future<Map<String, dynamic>> obtenerUltimaVersionGitHub() async {
    final url =
        'https://api.github.com/repos/alexito8473/anime/releases/latest';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Convertir la respuesta JSON
      return json.decode(response.body);
    } else {
      throw Exception('No se pudo obtener la última versión de GitHub');
    }
  }
}
