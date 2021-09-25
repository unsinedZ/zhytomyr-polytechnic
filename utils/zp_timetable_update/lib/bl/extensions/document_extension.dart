import 'package:googleapis/firestore/v1.dart';

extension DocumentExtensions on Document {
  Map<String, dynamic> toJsonFixed() {
    return this.fields!.map((key, value) {
      return MapEntry(key, value.toJsonFixed());
    });
  }
}

extension ValueExtensions on Value {
  dynamic toJsonFixed() {
    if(this.stringValue != null) {
      return this.stringValue;
    }

    if(this.doubleValue != null) {
      return this.doubleValue;
    }

    if(this.booleanValue != null) {
      return this.booleanValue;
    }

    if(this.integerValue != null) {
      return this.integerValue;
    }

    if(this.arrayValue != null) {
      if(this.arrayValue!.values == null){
        return [];
      }
      return this.arrayValue!.values!.map((e) => e.toJsonFixed()).toList();
    }

    if(this.mapValue != null) {
      return this.mapValue!.fields!.map((key, value) => MapEntry(key, value.toJsonFixed()));
    }
  }
}