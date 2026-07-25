import fl_pip
import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func sceneWillEnterForeground(_ scene: UIScene) {
    super.sceneWillEnterForeground(scene)
    (UIApplication.shared.delegate as? FlFlutterAppDelegate)?
      .applicationWillEnterForeground(UIApplication.shared)
  }

  override func sceneDidEnterBackground(_ scene: UIScene) {
    super.sceneDidEnterBackground(scene)
    (UIApplication.shared.delegate as? FlFlutterAppDelegate)?
      .applicationDidEnterBackground(UIApplication.shared)
  }
}
