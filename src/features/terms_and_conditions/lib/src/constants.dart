import 'dart:core';

const String packageName = 'terms_and_conditions';
const bool isMainPackage = false;

String getAssetPathPrefix() {
  if (isMainPackage) {
    return '';
  }

  return 'packages/$packageName/';
}
