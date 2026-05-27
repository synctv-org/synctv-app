class LoginResult {
  final String? authCode;
  final String? openID;
  final String? unionID;
  final String? idToken;
  final bool success;
  final String? errorCode;
  final String? errorMessage;

  LoginResult(
      {this.authCode,
      this.openID,
      this.unionID,
      this.idToken,
      required this.success,
      this.errorCode,
      this.errorMessage});
}
