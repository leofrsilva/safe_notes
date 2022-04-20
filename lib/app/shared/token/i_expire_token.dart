abstract class IExpireToken {
  Future<void> generaterToken(Map<String, dynamic> infoUser);
  Future<Map<String, dynamic>?> checkToken({Function? onCallBackExpiredTime});
  Future removeToken();
}
