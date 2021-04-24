import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:user_sync/src/adstractions/users_repository.dart';
import 'package:user_sync/src/models/user.dart';

class UserSyncBloc {
  final FlutterSecureStorage storage;
  final UserRepository repository;
  StreamController<User?> _mappedUserController = StreamController.broadcast();
  Stream<User?> get mappedUser => _mappedUserController.stream;

  UserSyncBloc({
    this.storage = const FlutterSecureStorage(),
    required this.repository,
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
      .toList();

  void updateUserData(Map<String, dynamic> data) => mappedUser
          .switchMap((user) => Stream.empty()
              .asyncMap((_) => repository.changeUserInfo(user!.userId, data))
              .asyncMap((_) => repository.getUserInfo(user!.userId)))
          .map((userJson) => User.fromJson(userJson!))
          .doOnData(_mappedUserController.add)
          .asyncMap((user) =>
              storage.write(key: "user", value: jsonEncode(user.toJson())))
          .doOnError((error, stack) {
        print(error);
        print(stack);
      }).toList();
}
