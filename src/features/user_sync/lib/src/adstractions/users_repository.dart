abstract class UserRepository {
  Future<void> changeUserInfo(String userId, Map<String, dynamic> data);

  Future<Map<String, dynamic>?> getUserInfo(String userId);
}