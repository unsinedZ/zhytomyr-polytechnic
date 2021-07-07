import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filepicker_windows/filepicker_windows.dart';

class FilesPicker {
  final String defaultExtension;

  FilesPicker({required this.defaultExtension});

  Future<File?> open() async {
    if (Platform.isWindows) {
      final file = OpenFilePicker()
        ..defaultFilterIndex = 0
        ..defaultExtension = defaultExtension;

      return file.getFile();
    }

    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowedExtensions: [defaultExtension]);
      return File(result!.files.single.path!);
    }
  }
}
