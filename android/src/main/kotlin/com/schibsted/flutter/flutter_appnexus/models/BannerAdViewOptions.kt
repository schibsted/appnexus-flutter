package com.schibsted.flutter.flutter_appnexus.models

data class BannerAdViewOptions(val adHeight: Int? = null,
                               val adWidth: Int? = null,
                               val layoutWidth: Int? = null,
                               val layoutHeight: Int? = null,
                               val shouldServePSAs: Boolean? = null,
                               val loadsInBackground: Boolean? = null,
                               val resizeAdToFitContainer: Boolean? = null,
                               val loadWhenCreated: Boolean? = null,
                               val placementID: String? = null,
                               val memberId: String? = null,
                               val inventoryCode: Int? = null,
                               val clickThroughAction: String? = null,
                               val autoRefreshInterval: Int? = null,
                               val resizeWhenLoaded: Boolean? = null)

fun Map<*, *>.toBannerAdViewOptions(): BannerAdViewOptions {
    return BannerAdViewOptions(
            adHeight = this["adHeight"] as Int?,
            adWidth = this["adWidth"] as Int?,
            layoutHeight = this["layoutHeight"] as Int?,
            layoutWidth = this["layoutWidth"] as Int?,
            shouldServePSAs = this["shouldServePSAs"] as Boolean?,
            loadsInBackground = this["loadsInBackground"] as Boolean?,
            resizeAdToFitContainer = this["resizeAdToFitContainer"] as Boolean?,
            loadWhenCreated = this["loadWhenCreated"] as Boolean?,
            placementID = this["placementID"] as String?,
            memberId = this["memberId"] as String?,
            inventoryCode = this["inventoryCode"] as Int?,
            clickThroughAction = this["clickThroughAction"] as String?,
            autoRefreshInterval = this["autoRefreshInterval"] as Int?,
            resizeWhenLoaded = this["resizeWhenLoaded"] as Boolean?
    )
}