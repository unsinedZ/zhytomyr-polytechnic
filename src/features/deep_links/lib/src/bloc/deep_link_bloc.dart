import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:rxdart/rxdart.dart';

class DeepLinkBloc {
  final StreamSink<String> errorSink;

  StreamController<Uri?> _dynamicLinkController = StreamController();

  DeepLinkBloc({required this.errorSink});

  Stream<Uri?> get dynamicLink => _dynamicLinkController.stream;

  void initLink(List<String> links) => FirebaseDynamicLinks.instance
      .getInitialLink()
      .asStream()
      .doOnData((link) {
        if (links.length == 0) {
          throw Exception("Links list is empty");
        }
      })
      .where((_) => links.length != 0)
      .doOnData((dynamicLink) {
        if (dynamicLink == null) {
          _dynamicLinkController.add(null);
        }
      })
      .where((link) => link != null)
      .doOnError((error, _) => errorSink.add(error.toString()))
      .listen((initedLink) => links
          .where((link) => initedLink!.link.path == link)
          .forEach((link) => _dynamicLinkController.add(initedLink!.link)));

  void dispose() {
    _dynamicLinkController.close();
  }
}
