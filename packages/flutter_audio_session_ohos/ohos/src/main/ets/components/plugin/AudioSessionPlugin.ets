/**
 * Copyright (c) 2025 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
import { FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import MethodChannel, { MethodCallHandler, MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import MethodCall from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCall';
import OhosAudioManager from './OhosAudioManager';
import { Log } from '@ohos/flutter_ohos';

/** AudioSessionPlugin **/
export default class AudioSessionPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private ohosAudioManager: OhosAudioManager | null = null;
  private static instances: AudioSessionPlugin[] = [];
  private static configuration: Map<ESObject, ESObject>;

  constructor() {
  }

  getUniqueClassName(): string {
    return "AudioSessionPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "com.ryanheise.audio_session");
    this.channel.setMethodCallHandler(this);
    this.ohosAudioManager = new OhosAudioManager(binding.getApplicationContext(), binding.getBinaryMessenger());
    AudioSessionPlugin.instances.push(this);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
    this.ohosAudioManager?.dispose();
    this.ohosAudioManager = null;
    let index = AudioSessionPlugin.instances.indexOf(this);
    AudioSessionPlugin.instances.splice(index, 1);
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    Log.i("AudioSessionPlugin", "onMethodCall: " + call.method);
    switch (call.method) {
      case "setConfiguration": {
        const args: Array<ESObject> = call.args as Array<ESObject>;
        Log.i("AudioSessionPlugin", "setConfiguration: " + args[0]);
        AudioSessionPlugin.configuration = args[0] as Map<ESObject, ESObject>;
        result.success(null);
        this.invokeMethod("onConfigurationChanged", AudioSessionPlugin.configuration);
      }
      case "getConfiguration": {
        result.success(AudioSessionPlugin.configuration);
        break;
      }
      default:
        result.notImplemented();
        break;
    }
  }

  private invokeMethod(method: string, ...args: Array<ESObject>): void {
    for(let i = 0; i < AudioSessionPlugin.instances.length; i++) {
      const list: ESObject[] = [...args]
      AudioSessionPlugin.instances[i].channel?.invokeMethod(method, list);
    }
  }
}