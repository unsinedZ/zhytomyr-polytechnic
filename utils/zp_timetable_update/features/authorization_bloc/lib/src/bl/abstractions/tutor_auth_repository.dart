import 'package:googleapis_auth/auth_io.dart';


abstract class ITutorAuthRepository {
  Future<int> loadTutorId(AuthClient client, String clientId);
}

