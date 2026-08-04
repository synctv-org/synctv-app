import AVFAudio
import AVKit
import Foundation

class BackgroundAudioPlayer: NSObject {
    static let shared = BackgroundAudioPlayer()

    var audioPlayer: AVAudioPlayer?
    var audioSession = AVAudioSession.sharedInstance()
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?

    func startPlay(_ path: String) -> Bool {
        do {
            stopPlay()
            if !FileManager.default.fileExists(atPath: path) {
                return false
            }
            let audio = Bundle.main.path(forResource: path, ofType: nil)
            if audio != nil {
                // 设置后台模式和锁屏模式下依旧能够播放
                try audioSession.setCategory(.playback, options: .mixWithOthers)
                try audioSession.setActive(true)
                backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "FlPiPBackgroundAudio") {
                    // 后台任务结束时的清理工作
                    print("Background task ended.")
                }
                if audioPlayer == nil {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audio!))
                }
                audioPlayer!.volume = 0
                audioPlayer!.numberOfLoops = -1
                return true
            }

        } catch {
            print("FlPiP BackgroundAudioPlayer error")
        }
        return false
    }

    func stopPlay() {
        audioPlayer?.stop()
        audioPlayer = nil
        do {
            try audioSession.setActive(false)
        } catch {
            print("FlPiP AVAudioSession setActive error")
        }
        if backgroundTaskIdentifier != nil {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier!)
            backgroundTaskIdentifier = nil
        }
    }
}
