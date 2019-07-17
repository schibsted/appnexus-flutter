package com.schibsted.flutter.flutter_appnexus_example

import android.os.Bundle
import com.appnexus.opensdk.SDKSettings
import com.appnexus.opensdk.utils.Clog
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        SDKSettings.setOMEnabled(true)
        SDKSettings.setLocationEnabled(false)
        SDKSettings.useHttps(true)
        GeneratedPluginRegistrant.registerWith(this)
    }

}
