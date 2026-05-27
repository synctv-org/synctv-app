import { MethodCall, MethodResult } from "@ohos/flutter_ohos";
import authentication from '@hms.core.authentication';
import { BusinessError } from "@ohos.base";
import { UIAbility } from "@kit.AbilityKit";
import { loginComponentManager } from "@kit.AccountKit";
import { ErrorCode } from "./ErrorCode";
import { LoginInfo } from "./LoginInfo";
import util from "@ohos.util";
import hilog from "@ohos.hilog";

export class HwLoginPluginDelegate {
  ability: UIAbility | null = null

  handleMethodCall(call: MethodCall, result: MethodResult) {
    switch (call.method) {
      // 获取当前手机号
      case "getPhone":
        this.getPhone(call, result)
        break;
      case "login":
        this.login(call, result)
        break;
      default:
        result.notImplemented()
        break;
    }
  }

  cancel() {
    // doNothing
  }

  async getPhone(call: MethodCall, result: MethodResult) {
    // 因为不再需要获取手机号，直接返回null或者不实现
    result.success(null);
  }

  async login(call: MethodCall, result: MethodResult) {
    if (this.ability == null) {
        result.error("NO_ABILITY", "Ability is null, cannot start login", null);
        return;
    }
    // 创建登录请求，并设置参数。
    // 对于个人开发者，必须只请求最基础的权限，绝对不能包含手机号等敏感信息。
    const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    // 强制拉起登录页面
    loginRequest.forceLogin = true;
    // 用于防跨站点请求伪造
    loginRequest.state = util.generateRandomUUID();
    // 执行登录请求
    try {
      const controller = new authentication.AuthenticationController(this.ability.context);
      controller.executeRequest(loginRequest).then((response: authentication.LoginWithHuaweiIDResponse) => {
        const loginWithHuaweiIDResponse = response as authentication.LoginWithHuaweiIDResponse;
        const state = loginWithHuaweiIDResponse.state;
        if (state && loginRequest.state !== state) {
          hilog.error(0x0000, 'HwLoginPlugin', `Failed to login. The state is different, response state: ${state}`);
          result.error("STATE_MISMATCH", "State mismatch", null);
          return;
        }
        const loginWithHuaweiIDCredential = loginWithHuaweiIDResponse?.data;
        const code = loginWithHuaweiIDCredential?.authorizationCode;
        const idToken = loginWithHuaweiIDCredential?.idToken;
        // 开发者处理code, idToken
        result.success(code);
      }).catch((error: BusinessError) => {
        hilog.error(0x0000, 'HwLoginPlugin', `Login failed: code=${error.code}, msg=${error.message}`);
        if (error.code === ErrorCode.ERROR_CODE_NETWORK_ERROR) {
          result.error(error.code.toString(), "网络未连接", error)
        } else if (error.code === ErrorCode.ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED) {
          result.error(error.code.toString(), "未同意协议", error)
        } else if (error.code === ErrorCode.ERROR_CODE_LOGIN_OUT) {
          // 提示华为账号未登录
          result.error(error.code.toString(), "华为账号未登录", error)
        } else if (error.code === ErrorCode.ERROR_CODE_NOT_SUPPORTED) {
          // 不支持该scopes或permissions提示
          result.error(error.code.toString(), "不支持该scopes或permissions提示", error)
        } else {
          // 当前提示系统或服务异常，可根据实际情况处理
          result.error(error.code.toString(), `系统或服务异常: ${error.message}`, error)
        }
      })
    } catch (error) {
      hilog.error(0x0000, 'HwLoginPlugin', `Login exception: ${JSON.stringify(error)}`);
      let code = "EXCEPTION";
      let msg = "登录异常";
      if (error && (error as BusinessError).code) {
          code = (error as BusinessError).code.toString();
          msg = (error as BusinessError).message;
      }
      result.error(code, msg, error)
    }
  }
}