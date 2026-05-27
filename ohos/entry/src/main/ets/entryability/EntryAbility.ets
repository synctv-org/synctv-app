
import { FlutterAbility, FlutterEngine } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import { EventChannel, EventSink, StreamHandler } from '@ohos/flutter_ohos';
import { motion } from '@kit.MultimodalAwarenessKit';
import { BusinessError } from '@kit.BasicServicesKit';

class SmartGripStreamHandler implements StreamHandler {
  private eventSink: EventSink | null = null;

  onListen(args: Object, events: EventSink): void {
    this.eventSink = events;
    try {
      motion.on('holdingHandChanged', (data: number) => {
        if (this.eventSink) {
          this.eventSink.success(data);
        }
      });
    } catch (err) {
      console.error(`SmartGrip start error: ${JSON.stringify(err as BusinessError)}`);
    }
  }

  onCancel(args: Object): void {
    try {
      motion.off('holdingHandChanged');
    } catch (err) {
      console.error(`SmartGrip stop error: ${JSON.stringify(err as BusinessError)}`);
    }
    this.eventSink = null;
  }
}

export default class EntryAbility extends FlutterAbility {
  private eventChannel: EventChannel | null = null;

  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)

    this.eventChannel = new EventChannel(flutterEngine.dartExecutor.getBinaryMessenger(), "com.synctv/smart_grip");
    this.eventChannel.setStreamHandler(new SmartGripStreamHandler());
  }
}
