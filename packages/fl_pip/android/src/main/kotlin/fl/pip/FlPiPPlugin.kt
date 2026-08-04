package fl.pip

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


/** FlPiPPlugin */
class FlPiPPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private val pipHelper: PiPHelper = PiPHelper.getInstance()
    private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = binding
        channel = MethodChannel(binding.binaryMessenger, "fl_pip")
        channel.setMethodCallHandler(this)
        pipHelper.channels.add(channel)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        pipHelper.onMethodCall(call, result, pluginBinding)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        pipHelper.channels.remove(channel)
    }

}