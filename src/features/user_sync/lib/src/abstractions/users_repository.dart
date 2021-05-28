abstract class UserRepository {
  
  Future<void> changeUserInfo(String userId, String groupId, String subgroupId);

  Future<Map<String, dynamic>> getUserInfo(String userId);
}