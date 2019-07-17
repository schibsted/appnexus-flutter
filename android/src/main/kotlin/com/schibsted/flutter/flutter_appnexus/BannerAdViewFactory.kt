package com.schibsted.flutter.flutter_appnexus

import android.app.Activity
import android.content.Context
import com.schibsted.flutter.flutter_appnexus.models.toBannerAdViewOptions
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BannerAdViewFactory(private val messenger: BinaryMessenger, private val activity: Activity) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private val tag = BannerAdViewFactory::class.java.simpleName

    private val flutterBannerAdViews = mutableMapOf<Int, FlutterBannerAdView>()

    override fun create(context: Context, id: Int, o: Any?): PlatformView {

        if (!flutterBannerAdViews.containsKey(id)) {
            Log.d(tag, "Create new FlutterBannerAdView for id=$id")
            flutterBannerAdViews[id] = FlutterBannerAdView(messenger, id, (o as? Map<*, *>)?.toBannerAdViewOptions(), activity)
        }
        Log.d(tag, "Return existing FlutterBannerAdView for id=$id")
        return flutterBannerAdViews[id]!!
    }
}