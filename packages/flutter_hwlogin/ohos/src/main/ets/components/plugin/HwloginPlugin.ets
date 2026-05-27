import {
  AbilityAware,
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import { HwLoginPluginDelegate } from './HwLoginPluginDelegate';

/** HwloginPlugin **/
export default class HwloginPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware {
  private channel: MethodChannel | null = null;

  private delegate: HwLoginPluginDelegate = new HwLoginPluginDelegate()

  constructor() {
  }

  getUniqueClassName(): string {
    return "HwloginPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "com.looptry/hwlogin");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
    this.delegate.cancel()
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.delegate.ability = binding.getAbility()
  }

  onDetachedFromAbility(): void {
    this.delegate.ability = null
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    this.delegate.handleMethodCall(call, result)
  }
}