import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

class downloadIcons {
  Future<void> downloadIconsGet() async {
    try {
      Directory? appDirectory = await getExternalStorageDirectory();
      // Reemplaza estas variables con la información de tu repositorio
      String username = 'AldaSttiven';
      String repository = 'IconsEssentialControl';
      String branch = 'main';

      // Obtiene la URL del archivo ZIP
      final url =
          'https://api.github.com/repos/$username/$repository/zipball/$branch';

      // Descarga el archivo ZIP
      final response = await http.get(Uri.parse(url));
      print("respose code : ${response.statusCode}");

      var file = File('${appDirectory!.path}/icons.zip');

      file.writeAsBytesSync(response.bodyBytes);

      if (file.existsSync()) {
        print("existe el archivo ${file.path}");
        unzipFile(zipFile: file, extractToPath: appDirectory.path);
      } else {
        print("no existe el archivo");
      }

      print('La carpeta "icons" se ha descargado correctamente.');
    } on Exception catch (e) {
      print("Ocurrio una exception en la descarga de los iconos : $e");
    }
  }

  Future<void> unzipFile({
    required File zipFile,
    required String extractToPath,
  }) async {
    try {
      print("zipFile : ${zipFile.path}, extractPath : ${extractToPath}");
      // Read the Zip file from disk.
      final bytes = await zipFile.readAsBytes();

      // Decode the Zip file
      final Archive archive =
          ZipDecoder().decodeBuffer(InputFileStream(zipFile.path));

      // Extract the contents of the Zip archive to extractToPath.
      for (final ArchiveFile file in archive) {
        final String filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('$extractToPath/$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data, flush: true);
        } else {
          // it should be a directory
          Directory('$extractToPath/$filename').create(recursive: true);
        }
      }
      fetchFiles();
    } on Exception catch (e) {
      print("error al descomprimir : $e");
    }
  }

  Future<List<dynamic>> fetchFiles() async {
    Directory? appDirectory = await getExternalStorageDirectory();

    List<dynamic> listImage = <dynamic>[];

    await Directory(appDirectory!.path)
        .list(recursive: false, followLinks: false)
        .forEach((element) {
      if (element.toString().contains("IconsEssentialControl")) {
        Directory(element.path + "/icons/").list().forEach((e) {
          listImage.add(e);
        });
      }
    });
    return listImage;
  }
}
