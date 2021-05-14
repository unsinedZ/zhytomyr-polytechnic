import 'package:update_check/src/bl/models/version.dart';

abstract class VersionsRepository {
  Future<Version> loadLastVersion(String platformOS);
}