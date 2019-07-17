package com.schibsted.flutter.flutter_appnexus

import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterAppnexusPlugin {

    companion object {

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            registrar.platformViewRegistry()
                    .registerViewFactory("com.schibsted.flutter.appnexus/banner_ad_view", BannerAdViewFactory(registrar.messenger(), registrar.activity()))
        }
    }
}