import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:user_sync/src/abstractions/users_repository.dart';
import 'package:user_sync/src/models/user.dart';

class UserSyncBloc {
  final UserRepository repository;
  final StreamSink<String> errorSink;

  BehaviorSubject<User?> _mappedUserController = BehaviorSubject();

  UserSyncBloc({
    required this.repository,
    required this.errorSink,
  });

  Stream<User?> get mappedUser => _mappedUserController.stream;

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
  )
      .doOnError((error, _) => errorSink.add(error.toString()))
      .toList();

  void cleanData() => _mappedUserController.add(User.empty());
}
