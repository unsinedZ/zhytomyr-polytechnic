class ErrorModel {
  final int status;
  final String message;

  ErrorModel({this.status = 0, required this.message});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      status: json['status'] as int,
      message: json['message'] as String,
    );
  }

  @override
  String toString() => message;
}
