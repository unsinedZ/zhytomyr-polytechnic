import 'dart:async';
import 'dart:io';

import 'package:package_info/package_info.dart';
import 'package:version/version.dart' as VersionPackage;
import 'package:rxdart/rxdart.dart';

import 'package:update_check/src/bl/models/version.dart';
import 'package:update_check/src/bl/abstraction/versions_repository.dart';

class UpdateCheckBloc {
  final StreamSink<String> errorSink;
  final VersionsRepository versionsRepository;

  BehaviorSubject<Version?> _newVersionController = BehaviorSubject<Version?>();

  UpdateCheckBloc({
    required this.errorSink,
    required this.versionsRepository,
  });

  Stream<Version?> get version => _newVersionController.stream;

  void checkForUpdates() async {
    versionsRepository
        .loadLastVersion(Platform.operatingSystem)
        .then((lastVersion) async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      if (VersionPackage.Version.parse(lastVersion.version) >
          VersionPackage.Version.parse(packageInfo.version)) {
        return _newVersionController.add(lastVersion);
      }
    }).onError((error, stackTrace) {
      errorSink.add(error.toString());
      _newVersionController.add(null);
    });
  }

  void dispose() {
    _newVersionController.close();
  }
}
