import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:user_sync/src/adstractions/users_repository.dart';
import 'package:user_sync/src/models/user.dart';

class UserSyncBloc {
  final FlutterSecureStorage storage;
  final UserRepository repository;
  StreamController<User> _controller = StreamController.broadcast();
  Stream<User> get mappedUser => _controller.stream;

  UserSyncBloc(
      {this.storage = const FlutterSecureStorage(), required this.repository});

  void loadUser() => getUserFromStorage()
      .doOnData((userJson) {
        if (userJson == null || userJson.isEmpty) {
          _controller.add(User());
        }
      })
      .where((userJson) => userJson?.isNotEmpty == true)
      .map((userJson) => jsonDecode(userJson!))
      .map((userJson) => User.fromJson(userJson))
      .listen(_controller.add);

  Stream<String?> getUserFromStorage() =>
      storage.readAll().asStream().map((values) => values['user']);

  void setData(String userId) => repository
      .getUserInfo(userId)
      .asStream()
      .map((userJson) => User.fromJson(userJson!))
      .switchMap((user) => Stream.value(user)
          .asyncMap((user) =>
              storage.write(key: "user", value: jsonEncode(user.toJson())))
          .map((_) => _controller.add(user)))
      .toList();

  void updateUserData(Map<String, dynamic> data) => mappedUser
      .asyncMap((user) => repository.changeUserInfo(user.userId, data))
      .map((userJson) => User.fromJson(userJson!))
      .switchMap((user) => Stream.value(user)
          .asyncMap((user) =>
              storage.write(key: "user", value: jsonEncode(user.toJson())))
          .map((_) => _controller.add(user)))
      .toList();
}
