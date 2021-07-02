import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:user_sync/src/abstractions/users_repository.dart';
import 'package:user_sync/src/models/user.dart';

class UserSyncBloc {
  final FlutterSecureStorage storage;
  final UserRepository repository;
  final StreamSink<String> errorSink;

  BehaviorSubject<User?> _mappedUserController = BehaviorSubject();

  UserSyncBloc({
    this.storage = const FlutterSecureStorage(),
    required this.repository,
    required this.errorSink,
  });

  Stream<User?> get mappedUser => _mappedUserController.stream;

  void loadUser() => _getUserFromStorage()
      .doOnData((userJson) {
        if (userJson == null || userJson.isEmpty) {
          _mappedUserController.add(User.empty());
        }
      })
      .where((userJson) => userJson != null && userJson.isNotEmpty)
      .map((userJson) => jsonDecode(userJson!))
      .map((userJson) => User.fromStorage(userJson))
      .doOnError((error, _) => errorSink.add(error.toString()))
      .listen(_mappedUserController.add);

  Stream<String?> _getUserFromStorage() =>
      storage.readAll().asStream().map((values) => values['user']);

  void setData(String? userId, AuthProvider authProvider) =>
      Stream.value(userId)
          .doOnData((userId) {
            if (userId == null) {
              _mappedUserController.add(null);
            }
          })
          .where((userId) => userId != null)
          .switchMap((value) => repository
                  .getUserInfo(userId!)
                  .asStream()
                  .map((userJson) => User.fromJson(userJson, authProvider))
                  .doOnData(_mappedUserController.add)
                  .asyncMap((user) => storage.write(
                      key: "user", value: jsonEncode(user.toJson())))
                  .doOnError((error, _) {
                _mappedUserController.add(User.empty());
                errorSink.add(error.toString());
              }))
          .toList();

  void updateUserData(String groupId, String subgroupId) => mappedUser
      .take(1)
      .where((user) =>
          user != null &&
          (user.groupId != groupId || user.subgroupId != subgroupId))
      .map((user) => User(
            authProvider: user!.authProvider,
            userId: user.userId,
            groupId: groupId,
            subgroupId: subgroupId,
          ))
      .switchMap((dataNew) => Stream.value(null)
          .asyncMap((_) => repository.changeUserInfo(
              dataNew.userId, dataNew.groupId, dataNew.subgroupId))
          .doOnData((_) => _mappedUserController.add(dataNew))
          .asyncMap((_) =>
              storage.write(key: "user", value: jsonEncode(dataNew.toJson()))))
      .doOnError((error, _) => errorSink.add(error.toString()))
      .toList();

  void cleanData() => storage
      .delete(key: "user")
      .then((_) => _mappedUserController.add(User.empty()));
}
