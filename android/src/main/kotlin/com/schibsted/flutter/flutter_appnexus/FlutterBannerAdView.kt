package com.schibsted.flutter.flutter_appnexus

import android.app.Activity
import android.support.v4.content.ContextCompat
import android.view.View
import android.view.ViewGroup
import android.webkit.WebView
import android.widget.FrameLayout
import com.appnexus.opensdk.*
import com.google.gson.Gson
import com.schibsted.flutter.flutter_appnexus.models.AdListenerEvent
import com.schibsted.flutter.flutter_appnexus.models.BannerAdViewOptions
import io.flutter.Log
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.platform.PlatformView

class FlutterBannerAdView internal constructor(messenger: BinaryMessenger, private val id: Int, private val bannerAdViewOptions: BannerAdViewOptions?,
                                               private val activity: Activity) : PlatformView, MethodCallHandler {

    private val tag = FlutterBannerAdView::class.java.simpleName

    private lateinit var bannerAdView: BannerAdView

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.schibsted.flutter.appnexus/banner_ad_view/$id")
    private var adListenerSink: EventChannel.EventSink? = null

    private val gson = Gson()

    init {
        Log.d(tag, "init FlutterBannerAdView; id=$id")
        methodChannel.setMethodCallHandler(this)
        val eventChannel = EventChannel(messenger, "com.schibsted.flutter.appnexus/banner_ad_view/callback/$id", JSONMethodCodec.INSTANCE)
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
                adListenerSink = eventSink
            }

            override fun onCancel(arguments: Any?) {
                adListenerSink = null
            }
        })
    }

    override fun getView(): View {
        if (::bannerAdView.isInitialized) {
            Log.d(tag, "getView returned, because bannerAdView is initialized; id=$id")
            return this.bannerAdView
        }
        Log.d(tag, "getView initialize bannerAdView; id=$id")
        bannerAdView = BannerAdView(activity)

        bannerAdViewOptions?.let {
            if (it.adWidth != null && it.adHeight != null) {
                bannerAdView.setAdSize(it.adWidth, it.adHeight)
            }
            it.shouldServePSAs?.let { shouldServePSAs ->
                bannerAdView.shouldServePSAs = shouldServePSAs
            }
            if (it.inventoryCode != null && it.memberId != null) {
                bannerAdView.setInventoryCodeAndMemberID(it.inventoryCode, it.memberId)
            }
            it.placementID?.let { placementID ->
                bannerAdView.placementID = placementID
            }
            it.clickThroughAction?.let { clickThroughAction ->
                when (clickThroughAction) {
                    "open_device_browser" -> {
                        bannerAdView.clickThroughAction = ANClickThroughAction.OPEN_DEVICE_BROWSER
                    }
                    "open_sdk_browser" -> {
                        bannerAdView.clickThroughAction = ANClickThroughAction.OPEN_SDK_BROWSER
                    }
                    "return_url" -> {
                        bannerAdView.clickThroughAction = ANClickThroughAction.RETURN_URL
                    }
                }
            }
            it.autoRefreshInterval?.let { autoRefreshInterval ->
                bannerAdView.autoRefreshInterval = autoRefreshInterval
            }
            it.loadsInBackground?.let { loadsInBackground ->
                bannerAdView.loadsInBackground = loadsInBackground
            }
            it.resizeAdToFitContainer?.let { resizeAdToFitContainer ->
                bannerAdView.resizeAdToFitContainer = resizeAdToFitContainer
            }
        }

        bannerAdViewOptions?.loadWhenCreated?.let { loadWhenCreated ->
            if (loadWhenCreated) {
                loadAd()
            }
        }
        return this.bannerAdView
    }

    override fun onMethodCall(methodCall: MethodCall, result: Result) {
        when (methodCall.method) {
            "loadAd" -> loadAd()
            else -> result.notImplemented()
        }

    }

    private fun AdView.resize() {
        this.addOnLayoutChangeListener(object : View.OnLayoutChangeListener {
            override fun onLayoutChange(view: View?, left: Int, top: Int, right: Int, bottom: Int, oldLeft: Int, oldTop: Int, oldRight: Int, oldBottom: Int) {
                (this@resize as ViewGroup).getChildAt(0)?.let { adWebView ->
                    val screenHeight = ((bannerAdViewOptions?.layoutHeight ?: 0) * resources.displayMetrics.density).toInt()
                    if (screenHeight != 0 && screenHeight != adWebView.height && oldBottom != 0) {
                        //post avoid "requestLayout() improperly called by com.appnexus.opensdk.AdWebView"
                        adWebView.post {
                            adWebView.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, screenHeight)
                            (adWebView as WebView).settings.useWideViewPort = true
                            adWebView.invalidate()
                            sendAdListenerEvent(AdListenerEvent.AdLoaded)
                        }
                        removeOnLayoutChangeListener(this)
                    }
                }
            }
        })
    }

    private fun loadAd() {
        Log.d(tag, "loadAd; id=$id")
        bannerAdView.adListener = null
        val adListener = object : AdListener {
            override fun onAdRequestFailed(bav: AdView, errorCode: ResultCode?) {
                sendAdListenerEvent(AdListenerEvent.AdRequestFailed(errorCode.toString()))
            }

            override fun onAdLoaded(bav: AdView) {
                if (bannerAdViewOptions?.resizeWhenLoaded != null && bannerAdViewOptions.resizeWhenLoaded) {
                    bav.resize()
                } else {
                    sendAdListenerEvent(AdListenerEvent.AdLoaded)
                }
            }

            override fun onAdLoaded(nativeAdResponse: NativeAdResponse) {
                sendAdListenerEvent(AdListenerEvent.AdLoaded)
            }

            override fun onAdExpanded(bav: AdView) {}

            override fun onAdCollapsed(bav: AdView) {}

            override fun onAdClicked(bav: AdView) {
                sendAdListenerEvent(AdListenerEvent.AdClicked(null))
            }

            override fun onAdClicked(adView: AdView, clickUrl: String) {
                sendAdListenerEvent(AdListenerEvent.AdClicked(clickUrl))
            }
        }
        bannerAdView.adListener = adListener
        bannerAdView.setBackgroundColor(ContextCompat.getColor(activity, android.R.color.transparent))
        bannerAdView.loadAd()
    }

    override fun dispose() {
        bannerAdView.destroy()
        Log.d(tag, "dispose; id=$id")
    }

    private fun sendAdListenerEvent(event: AdListenerEvent) {
        adListenerSink?.success(gson.toJson(event))
    }
}