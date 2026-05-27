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
 
import { Any, BinaryMessenger, Log, MethodCall } from '@ohos/flutter_ohos';
import MethodChannel, { MethodCallHandler, MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import { Context } from '@kit.AbilityKit';
import audio from '@ohos.multimedia.audio';
import { ArrayList, JSON, List } from '@kit.ArkTS';
import { call } from '@kit.TelephonyKit';
import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = "OhosAudioManager";

export default class OhosAudioManager implements MethodCallHandler {
  private messenger : BinaryMessenger | null;
  public channel : MethodChannel | null;
  private singleton : Singleton | null = null;

  constructor(applicationContext: Context, messenger: BinaryMessenger) {
    if(this.singleton == null) {
      this.singleton = new Singleton(applicationContext);
    }
    this.messenger = messenger;
    this.channel = new MethodChannel(messenger, "com.ryanheise.ohos_audio_manager");
    this.singleton.add(this);
    this.channel.setMethodCallHandler(this);
  }
  public onMethodCall(call: MethodCall, result: MethodResult): void {
    try {
      const args: Array<ESObject> = call.args as Array<ESObject>;
      Log.i(TAG, "onMethodCall: " + call.method + " args: " + JSON.stringify(args));
      switch (call.method) {
        case "setActive": {
          this.singleton?.setActive(args, result);
          break;
        }
        case "dispatchMediaKeyEvent": {
          result.success(this.singleton?.dispatchMediaKeyEvent(call.args));
          break;
        }
        case "isVolumeUnadjustable": {
          result.success(this.singleton?.isVolumeFixed());
          break;
        }
        case "adjustStreamVolume": {
          result.success(this.singleton?.adjustStreamVolume(args[0] as number,
            args[1] as number, args[2] as number));
          break;
        }
        case "adjustVolume": {
          result.success(this.singleton?.adjustVolume(args[0] as number, args[1] as number));
        }
        case "adjustSuggestedStreamVolume": {
          result.success(this.singleton?.adjustSuggestedStreamVolume(args[0] as number,
            args[1] as number, args[2] as number));
          break;
        }
        case "getRingerMode": {
          result.success(this.singleton?.getRingerMode());
          break;
        }
        case "getMaxVolume": {
          result.success(this.singleton?.getMaxVolume(args[0] as number));
          break;
        }
        case "getMinVolume": {
          result.success(this.singleton?.getMinVolume(args[0] as number));
          break;
        }
        case "getVolume": {
          result.success(this.singleton?.getVolume(args[0] as number));
          break;
        }
        case "getSystemVolumeInDb": {
          result.success(this.singleton?.getSystemVolumeInDb(args[0] as number,
            args[1] as number, args[2] as number));
          break;
        }
        case "setRingerMode": {
          result.success(this.singleton?.setRingerMode(args[0] as number));
          break;
        }
        case "setStreamVolume": {
          result.success(this.singleton?.setStreamVolume(args[0] as number,
            args[1] as number, args[2] as number));
          break;
        }
        case "isMute": {
          result.success(this.singleton?.isMute(args[0] as number));
          break;
        }
        case "getAvailableCommunicationDevices": {
          result.success(this.singleton?.getAvailableCommunicationDevices());
          break;
        }
        case "setCommunicationDevice": {
          result.success(this.singleton?.setCommunicationDevice(args[0] as number));
          break;
        }
        case "getCommunicationDevice": {
          result.success(this.singleton?.getCommunicationDevice());
          break;
        }
        case "clearCommunicationDevice": {
          result.success(this.singleton?.clearCommunicationDevice());
          break;
        }
        case "setSpeakerphoneOn": {
          result.success(this.singleton?.setSpeakerphoneOn(args[0] as boolean));
          break;
        }
        case "isSpeakerphoneOn": {
          result.success(this.singleton?.isSpeakerphoneOn());
          break;
        }
        case "setAllowedCapturePolicy": {
          result.success(this.singleton?.setAllowedCapturePolicy(args[0] as number));
          break;
        }
        case "getAllowedCapturePolicy": {
          result.success(this.singleton?.getAllowedCapturePolicy());
          break;
        }
        case "isBluetoothScoAvailableOffCall": {
          result.success(this.singleton?.isBluetoothScoAvailableOffCall());
          break;
        }
        case "startBluetoothSco": {
          result.success(this.singleton?.startBluetoothSco());
          break;
        }
        case "stopBluetoothSco": {
          result.success(this.singleton?.stopBluetoothSco());
          break;
        }
        case "setBluetoothScoOn": {
          result.success(this.singleton?.setBluetoothScoOn(args[0] as boolean));
          break;
        }
        case "isBluetoothScoOn": {
          result.success(this.singleton?.isBluetoothScoOn());
          break;
        }
        case "setMicrophoneMute": {
          result.success(this.singleton?.setMicrophoneMute(args[0] as boolean));
          break;
        }
        case "isMicrophoneMute": {
          result.success(this.singleton?.isMicrophoneMute());
          break;
        }
        case "setMode": {
          result.success(this.singleton?.setMode(args[0] as number));
          break;
        }
        case "getAudioScene": {
          result.success(this.singleton?.getAudioScene());
          break;
        }
        case "isMusicActive": {
          result.success(this.singleton?.isMusicActive());
          break;
        }
        case "generateAudioSessionId": {
          result.success(this.singleton?.generateAudioSessionId());
          break;
        }
        case "setAudioParameter": {
          result.success(this.singleton?.setAudioParameter(args[0] as string, args[1] as string));
          break;
        }
        case "getAudioParameter": {
          result.success(this.singleton?.getAudioParameter(args[0] as string));
          break;
        }
        case "getProperty": {
          result.success(this.singleton?.getProperty(args[0] as string));
          break;
        }
        case "getDevices": {
          result.success(this.singleton?.getDevices(args[0] as number));
          break;
        }
        case "getMicrophones": {
          result.success(this.singleton?.getMicrophones());
          break;
        }
        case "isHapticPlaybackSupported": {
          result.success(this.singleton?.isHapticPlaybackSupported());
          break;
        }
        case "setInterruptionEventListener": {
          this.singleton?.setInterruptionEventListener(args[0] as Map<string, ESObject>, result);
          break;
        }
        default: {
          result.notImplemented();
          break;
        }
      }
    } catch (err) {
      result.error("Error: " + err, null, null);
    }
  }

  public dispose(): void {
    this.channel?.setMethodCallHandler(null);
    this.singleton?.remove(this);
    if(this.singleton?.isEmpty()) {
      this.singleton?.dispose();
      this.singleton = null;
    }
    this.channel = null;
    this.messenger = null;
  }

}

class Singleton {
  private instances: OhosAudioManager[];
  private applicationContext: Context | null;
  private audioManager: audio.AudioManager | null;
  private audioDeviceDescriptors: audio.AudioDeviceDescriptors | undefined;
  private audioActive: boolean = false;
  private audioRender: audio.AudioRenderer | null = null;
  private audioSessionManager: audio.AudioSessionManager | null = null;

  constructor(applicationContext: Context) {
    this.instances = [];
    this.applicationContext = applicationContext;
    this.audioManager = audio.getAudioManager();
    this.audioDeviceDescriptors = undefined;
    this.initAudioDeviceCallback();
  }

  private initAudioDeviceCallback(): void {
    this.audioManager?.getRoutingManager().on("deviceChange", audio.DeviceFlag.ALL_DEVICES_FLAG,
    (device: audio.DeviceChangeAction) => {
      if(device.type == audio.DeviceChangeType.CONNECT) {
        this.invokeMethod("onAudioDevicesAdded", this.encodeAudioDevices(device.deviceDescriptors));
      } else if(device.type == audio.DeviceChangeType.DISCONNECT) {
        this.invokeMethod("onAudioDevicesRemoved", this.encodeAudioDevices(device.deviceDescriptors));
      }

    });
  }

  private encodeAudioDevices(devices: audio.AudioDeviceDescriptors): Map<string, ESObject>[] {
    let result: Map<string, ESObject>[] = [];
    for(let i = 0; i < devices.length; i++) {
      result.push(this.encodeAudioDevice(devices[i]));
    }
    return result;
  }

  private encodeAudioDevice(device: audio.AudioDeviceDescriptor): Map<string, ESObject> {
    let deviceMap: Map<string, ESObject> = new Map();
    deviceMap.set("deviceRole", device.deviceRole);
    deviceMap.set("deviceType", device.deviceType);
    deviceMap.set("id", device.id);
    deviceMap.set("name", device.name);
    deviceMap.set("address", device.address);
    deviceMap.set("sampleRates", device.sampleRates);
    deviceMap.set("channelMasks", device.channelMasks);
    deviceMap.set("displayName", device.displayName);
    deviceMap.set("channelIndexMasks", device.channelMasks);
    deviceMap.set("channelCounts", device.channelCounts);
    return deviceMap;
  }

  private decodeAudioRendererOptions(attributes: Map<string, ESObject>): audio.AudioRendererOptions | null {
    if(!attributes.has("sampleRate") || !attributes.has("channels") || !attributes.has("sampleFormat")
      || !attributes.has("encodingType") || !attributes.has("streamUsage")) {
      return null;
    }
    let audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: attributes.get("sampleRate") as audio.AudioSamplingRate,
      channels: attributes.get("channels") as audio.AudioChannel,
      sampleFormat: attributes.get("sampleFormat") as audio.AudioSampleFormat,
      encodingType: attributes.get("encodingType") as audio.AudioEncodingType,
    };
    let audioRendererInfo: audio.AudioRendererInfo = {
      usage: attributes.get("streamUsage") as audio.StreamUsage,
      rendererFlags: 0,
    };
    let audioRendererOptions: audio.AudioRendererOptions = {
      streamInfo: audioStreamInfo,
      rendererInfo: audioRendererInfo,
    };
    return audioRendererOptions;
  }

  private decodeAudioConcurrencyMode(mode: Any): audio.AudioConcurrencyMode {
    if(mode) {
      return mode as audio.AudioConcurrencyMode;
    }
    return audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT;
  }

  public add(manager: OhosAudioManager): void {
    this.instances.push(manager);
  }
  public remove(manager: OhosAudioManager): void {
    const index = this.instances.indexOf(manager);
    if(index != -1) {
      this.instances.splice(index, 1);
    }
  }

  public isEmpty() {
    return this.instances.length == 0;
  }

  public dispose(): void {
    this.disposeAudioDeviceCallback();
    this.applicationContext = null;
    this.audioManager = null;
  }

  public async setInterruptionEventListener(args: Map<string, ESObject>, result: MethodResult): Promise<boolean> {
    let isOnListener = args.get("isOnListener") as number;
    if(this.audioSessionManager == null) {
      this.audioSessionManager = audio.getAudioManager().getSessionManager();
    }
    if(isOnListener) {
      this.audioSessionManager.on('audioSessionDeactivated', (event: audio.AudioSessionDeactivatedEvent) => {
        this.invokeMethod('onAudioInterrupt', event.reason);
      });
    } else {
      this.audioSessionManager.off('audioSessionDeactivated');
    }
    result.success(true);
    return true;
  }

  private disposeAudioDeviceCallback(): void {
    this.audioManager?.getRoutingManager().off("deviceChange");
  }

  private invokeMethod(method: string, ...args: Array<ESObject>): void {
    for(let i = 0; i < this.instances.length; i++) {
      const list: ESObject[] = [...args]
      this.instances[i].channel?.invokeMethod(method, list);
    }
  }

  public async setActive(args: Array<ESObject>, result: MethodResult): Promise<boolean> {
    this.audioActive = args[0] as boolean;
    if(this.audioSessionManager == null) {
      this.audioSessionManager = audio.getAudioManager().getSessionManager();
    }
    if(this.audioActive) {
      let sessionStrategy: audio.AudioSessionStrategy = { concurrencyMode: this.decodeAudioConcurrencyMode(args[1] as number) };
      await this.audioSessionManager!.activateAudioSession(sessionStrategy);
    }
    result.success(true);
    return true;
  }

  public dispatchMediaKeyEvent(rawKeyEvent: ESObject): ESObject {
    return null;
  }

  public isVolumeFixed(): ESObject {
    return this.audioManager?.getVolumeManager().getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID)
      .isVolumeUnadjustable();
  }

  public adjustStreamVolume(streamType: number, direction: number, flags: number): ESObject {
    //TODO: AudioVolumeGroupManager.adjustSystemVolumeByStep
    return null;
  }

  public adjustVolume(direction: number, flags: number): ESObject {
    //TODO: AudioVolumeGroupManager.setVolume
    return null;
  }

  public adjustSuggestedStreamVolume(direction: number, suggestedStreamType: number, flags: number): ESObject {
    //TODO: no ohos api
    return null;
  }

  public getRingerMode(): ESObject {
    return this.audioManager?.getVolumeManager().getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID)
      .getRingerModeSync();
  }

  public getMaxVolume(streamType: number): ESObject {
    return this.audioManager?.getVolumeManager().getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID)
      .getMaxVolumeSync(streamType);
  }

  public getMinVolume(streamType: number): ESObject {
    return this.audioManager?.getVolumeManager().getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID)
      .getMinVolumeSync(streamType);
  }

  public getVolume(streamType: number): ESObject {
    return this.audioManager?.getVolumeManager().getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID)
      .getVolumeSync(streamType);
  }

  public getSystemVolumeInDb(streamType: number, index: number, deviceType: number): ESObject {
    return this.audioManager?.getVolumeManager().getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID)
      .getSystemVolumeInDbSync(streamType, index, deviceType);
  }

  public setRingerMode(ringerMode: number): ESObject {
    //TODO: setRingerMode
    return null;
  }

  public setStreamVolume(streamType: number, index: number, flags: number): ESObject {
    //TODO: setVolume
    return null;
  }

  public isMute(streamType: number): ESObject {
    return this.audioManager?.getVolumeManager().getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID)
      .isMuteSync(streamType);
  }

  public getAvailableCommunicationDevices():Map<string, ESObject>[] {
    this.audioDeviceDescriptors = this.audioManager?.getRoutingManager().getDevicesSync(audio.DeviceFlag.OUTPUT_DEVICES_FLAG);
    let result: Map<string, ESObject>[] = [];
    if(this.audioDeviceDescriptors != undefined) {
      for(let i = 0; i < this.audioDeviceDescriptors?.length; i++) {
        result.push(this.encodeAudioDevice(this.audioDeviceDescriptors[i]));
      }
    }
    return result
  }

  public setCommunicationDevice(deviceId: number): boolean {
    this.audioDeviceDescriptors?.forEach(device =>{
      if(device.id == deviceId) {
        //TODO: setCommunicationDevice
      }
    })
    return false;
  }

  public getCommunicationDevice(): Map<string, ESObject>  {
    //TODO: getCommunicationDevice
    return new Map();
  }

  public clearCommunicationDevice(): ESObject {
    //TODO: clearCommunicationDevice
    return null;
  }

  public setSpeakerphoneOn(enabled: boolean): ESObject {
    this.audioManager?.getRoutingManager().setCommunicationDevice(audio.CommunicationDeviceType.SPEAKER, enabled);
    return null;
  }

  public isSpeakerphoneOn(): ESObject {
    return this.audioManager?.getRoutingManager().isCommunicationDeviceActiveSync(audio.CommunicationDeviceType.SPEAKER);
  }

  public setAllowedCapturePolicy(capturePolicy: number): ESObject {
    //TODO: setAllowedCapturePolicy
    return null;
  }

  public getAllowedCapturePolicy(): ESObject {
    //TODO: getAllowedCapturePolicy
    return null;
  }

  public isBluetoothScoAvailableOffCall(): ESObject {
    //TODO: isBluetoothScoAvailableOffCall
  }

  public startBluetoothSco(): ESObject {
    //TODO: startBluetoothSco
  }

  public stopBluetoothSco(): ESObject {
    //TODO: stopBluetoothSco
  }

  public setBluetoothScoOn(enabled: boolean): ESObject {
    //TODO: setBluetoothScoOn
  }

  public isBluetoothScoOn(): ESObject {
    //TODO: isBluetoothScoOn
  }

  public setMicrophoneMute(enabled: boolean): ESObject {
    this.audioManager?.getVolumeManager().getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID)
      .setMicrophoneMute(enabled);
    return null;
  }

  public isMicrophoneMute(): ESObject {
    return this.audioManager?.getVolumeManager().getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID)
      .isMicrophoneMuteSync();
  }

  public setMode(mode: number): ESObject {
    //TODO: audioManager.setAudioScene
    return null;
  }

  public getAudioScene(): ESObject {
    return this.audioManager?.getAudioSceneSync();
  }

  public isMusicActive(): ESObject {
    return this.audioManager?.getStreamManager().isActiveSync(audio.AudioVolumeType.MEDIA);
  }

  public generateAudioSessionId(): ESObject {
    //TODO: no oh api
  }

  public setAudioParameter(key: string, value: string): ESObject {
    this.audioManager?.setAudioParameter(key, value);
    return null;
  }

  public getAudioParameter(key: string): ESObject {
    this.audioManager?.getAudioParameter(key);
  }


  public getProperty(arg: string): ESObject {
    return null;
  }

  public getDevices(flags: number): ESObject {
    let result: Array<Map<string, ESObject>> = [];
    this.audioDeviceDescriptors = this.audioManager?.getRoutingManager().getDevicesSync(flags);
    if(this.audioDeviceDescriptors != undefined) {
      for(let i = 0; i < this.audioDeviceDescriptors?.length; i++) {
        result.push(this.encodeAudioDevice(this.audioDeviceDescriptors[i]));
      }
    }
    return result;
  }

  public getMicrophones(): ESObject {
    let result: ArrayList<Map<string, ESObject>> = new ArrayList();
    this.audioManager?.getRoutingManager().getDevicesSync(audio.DeviceFlag.INPUT_DEVICES_FLAG).forEach(device => {
      if(device.deviceType == audio.DeviceType.MIC)
      result.add(this.encodeAudioDevice(device));
    })
    return result;
  }

  public isHapticPlaybackSupported(): ESObject {
    return false;
  }
}