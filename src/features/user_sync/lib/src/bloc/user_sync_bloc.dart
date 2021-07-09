import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:user_sync/src/abstractions/users_repository.dart';
import 'package:user_sync/src/models/user.dart';

class UserSyncBloc {
  final UserRepository repository;
  final StreamSink<String> errorSink;

  BehaviorSubject<User?> _syncUserSubject = BehaviorSubject();

  UserSyncBloc({
    required this.repository,
    required this.errorSink,
  });

  Stream<User?> get syncUser => _syncUserSubject.stream;

  void setData(String? userId, AuthProvider authProvider) =>
      Stream.value(userId)
          .doOnData((userId) {
            if (userId == null) {
              _syncUserSubject.add(null);
            }
          })
          .where((userId) => userId != null)
          .switchMap((value) => repository
                  .getUserInfo(userId!)
                  .asStream()
                  .map((userJson) => User.fromJson(userJson, authProvider))
                  .doOnData(_syncUserSubject.add)
                  .doOnError((error, _) {
                _syncUserSubject.add(User.empty());
                errorSink.add(error.toString());
              }))
          .toList();

  void updateUserData(String groupId, String subgroupId) => syncUser
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
          .doOnData((_) => _syncUserSubject.add(dataNew)))
      .doOnError((error, _) => errorSink.add(error.toString()))
      .toList();

  void cleanData() => _syncUserSubject.add(User.empty());
}
