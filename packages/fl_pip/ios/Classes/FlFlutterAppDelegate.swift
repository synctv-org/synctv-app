import Flutter

open class FlFlutterAppDelegate: FlutterAppDelegate {
    open func registerPlugin(_ registry: FlutterPluginRegistry) {}

    override open func applicationWillEnterForeground(_ application: UIApplication) {
        PiPHelper.shared.applicationWillEnterForeground(application)
    }

    override open func applicationDidEnterBackground(_ application: UIApplication) {
        PiPHelper.shared.applicationDidEnterBackground(application)
    }
}
