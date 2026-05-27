export class LoginInfo {
  private authCode: string;
  private openID: string;
  private unionID: string;
  private idToken: string;

  constructor(authCode: string, openID: string, unionID: string, idToken: string) {
    this.authCode = authCode;
    this.openID = openID;
    this.unionID = unionID;
    this.idToken = idToken;
  }
}