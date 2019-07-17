package com.schibsted.flutter.flutter_appnexus.models

sealed class AdListenerEvent(val name: String) {
    data class AdRequestFailed(val errorCode: String) : AdListenerEvent("adRequestFailed")
    object AdLoaded : AdListenerEvent("adLoaded")
    data class AdClicked(val clickUrl: String? = null) : AdListenerEvent("adClicked")
}
