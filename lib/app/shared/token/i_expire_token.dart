abstract class IExpireToken {
  Future<void> expireToken();
  Future<void> generaterToken(Map<String, dynamic> infoUser);
  Future<Map<String, dynamic>?> checkToken();
  Future removeToken();
}
