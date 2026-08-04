package fl.pip

import android.content.res.Configuration
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

open class FlPiPActivity : FlutterActivity() {
    private val pipHelper: PiPHelper = PiPHelper.getInstance()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        pipHelper.setActivity(this, this.applicationContext)
    }


    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean, newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        pipHelper.onPictureInPictureModeChanged(isInPictureInPictureMode)
    }

    override fun onPause() {
        super.onPause()
        pipHelper.onActivityPaused()
    }

    override fun onResume() {
        super.onResume()
        pipHelper.onActivityResume()
    }

}