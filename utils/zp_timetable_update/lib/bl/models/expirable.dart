class Expirable<T> {
  final DateTime expireAt;
  final T data;

  Expirable._({required this.expireAt, required this.data});

  Expirable({required Duration duration, required this.data})
      : expireAt = DateTime.now().add(duration);

  factory Expirable.fromJson(Map<String, dynamic> json) =>
      Expirable._(expireAt: DateTime.parse(json['expireAt']), data: json['data']);

  toJson() => <String, dynamic>{
    'expireAt': expireAt.toString(),
    'data': data,
  };
}