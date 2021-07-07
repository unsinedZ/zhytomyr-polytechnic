import 'dart:async';

class ErrorBloc {
  final StreamController<String> _errorController = StreamController();
  StreamSink<String> get errorSink => _errorController.sink;
  Stream<String> get error => _errorController.stream;

  void dispose() {
    _errorController.close();
  }
}
