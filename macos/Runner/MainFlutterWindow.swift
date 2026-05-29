import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var textEditingChannel: FlutterMethodChannel?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    textEditingChannel = FlutterMethodChannel(
      name: "synctv_app/text_editing",
      binaryMessenger: flutterViewController.engine.binaryMessenger)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }

  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    if event.type == .keyDown,
       event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.command),
       event.charactersIgnoringModifiers?.lowercased() == "v" {
      sendPasteToFlutter()
      return true
    }

    return super.performKeyEquivalent(with: event)
  }

  @objc func paste(_ sender: Any?) {
    sendPasteToFlutter()
  }

  private func sendPasteToFlutter() {
    textEditingChannel?.invokeMethod("paste", arguments: nil)
  }
}
