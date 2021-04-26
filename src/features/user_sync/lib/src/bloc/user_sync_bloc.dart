import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:user_sync/src/adstractions/users_repository.dart';
import 'package:user_sync/src/models/user.dart';

class UserSyncBloc {
  final FlutterSecureStorage storage;
  final UserRepository repository;
  final StreamSink<String> errorSink;

  BehaviorSubject<User?> _mappedUserController = BehaviorSubject();
  Stream<User?> get mappedUser => _mappedUserController.stream;

  UserSyncBloc({
    this.storage = const FlutterSecureStorage(),
    required this.repository,
    required this.errorSink,
  });

  void loadUser() => getUserFromStorage()
      .doOnData((userJson) {
        if (userJson == null || userJson.isEmpty) {
          _mappedUserController.add(null);
        }
      })
      .where((userJson) => userJson?.isNotEmpty == true)
      .map((userJson) => jsonDecode(userJson!))
      .map((userJson) => User.fromStorage(userJson))
      .listen(_mappedUserController.add);

  Stream<String?> getUserFromStorage() =>
      storage.readAll().asStream().map((values) => values['user']);

  void setData(String userId) => repository
      .getUserInfo(userId)
      .asStream()
      .map((userJson) => User.fromJson(userJson!))
      .doOnData(_mappedUserController.add)
      .asyncMap((user) =>
          storage.write(key: "user", value: jsonEncode(user.toJson())))
      .doOnError((error, _) => errorSink.add(error.toString()))
      .toList();

  void updateUserData(Map<String, dynamic> data) => mappedUser
      .take(1)
      .map((user) => User(data: data, userId: user!.userId))
      .switchMap((dataNew) => Stream.value(null)
          .asyncMap(
              (_) => repository.changeUserInfo(dataNew.userId, dataNew.data))
          .doOnData((_) => _mappedUserController.add(dataNew))
          .asyncMap((_) =>
              storage.write(key: "user", value: jsonEncode(dataNew.toJson()))))
      .doOnError((error, _) => errorSink.add(error.toString()))
      .toList();
}
