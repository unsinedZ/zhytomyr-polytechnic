import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:rxdart/rxdart.dart';

class DeepLinkBloc {
  final StreamSink<String> errorSink;

  BehaviorSubject<Uri?> _dynamicLinkSubject = BehaviorSubject();

  DeepLinkBloc({required this.errorSink});

  Stream<Uri?> get dynamicLink => _dynamicLinkSubject.stream;

  void initLink(List<String> links) => FirebaseDynamicLinks.instance
      .getInitialLink()
      .asStream()
      .doOnData((deepLink) {
        if (links.length == 0) {
          throw Exception("Links list is empty");
        }
      })
      .where((_) => links.length != 0)
      .doOnData((deepLink) {
        if (deepLink == null || !links.contains(deepLink.link)) {
          _dynamicLinkSubject.add(null);
        }
      })
      .where((deepLink) => deepLink != null && links.contains(deepLink.link))
      .doOnError((error, _) {
        errorSink.add(error.toString());
        _dynamicLinkSubject.add(null);
      })
      .listen((deepLink) => _dynamicLinkSubject.add(deepLink!.link));

  void dispose() {
    _dynamicLinkSubject.close();
  }
}
