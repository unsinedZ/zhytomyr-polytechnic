abstract class UserRepository {
  Future<Map<String,dynamic>?> changeUserInfo(String userId, Map<String, dynamic> data);

  Future<Map<String, dynamic>?> getUserInfo(String userId);
}