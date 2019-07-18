import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appnexus/models/ad_listener_event.dart';
import 'package:flutter_appnexus/models/click_through_action.dart';
import 'package:flutter_appnexus/models/load_mode.dart';

/// Widget that shows AppNexus Banners https://wiki.appnexus.com/display/sdk/Show+Banners
///
/// To use this widget please provide:
/// [layoutWidth] - The ad is wrapped in a Container. This is it's width. Must be positive!
/// [layoutHeight] - The ad is wrapped in a Container. This is it's height. Must be positive!
/// [loadMode] - When would you like to load the ad. Check more info below.
/// and a pair of
/// [memberId] - The member id that this AdView belongs to.
/// [inventoryCode] - The inventory code provides a more human readable way to identify the location in your application where ads will be shown.
/// or
/// [placementID] - The placement ID associated with your app's inventory.
///
/// Widget supports different load modes via the [loadMode] parameter:
/// * [LoadWhenCreated] - automatically loads ad after creating the view in native code
/// * [LoadWhenTriggered] - you trigger the ad loading via a Stream
/// * [WhenInViewport] - Ad loading is dependent if it's in the viewport
///
/// Widget passes AdListener events from native code described here: https://wiki.appnexus.com/display/sdk/Receive+Ad+View+Status+Events via [AdListenerEvent]
/// events. Just provide the [Sink<AdListenerEvent>] to [adListener] constructor property
///
/// Widget supports different opening ad modes via the [clickThroughAction] parameter:
/// * [OpenDeviceBrowser] - opens the ad in the device browser
/// * [OpenSdkBrowser] - opens the ad in the AppNexus browser
/// * [ReturnUrl]  - decide how to open the clicked ads. Just set a [Sink<AdListenerEvent>] to [adListener] and listen to a [AdClicked] event with
/// the [AdClicked.clickUrl] parameter.
///
/// Other parameters passed to native code:
/// [adWidth] - Width of the ad in pixels. If not provided [layoutWidth] is taken by default. Must be positive!
/// [adHeight] - Height of the ad in pixels.If not provided [layoutHeight] is taken by default. Must be positive!
/// [shouldServePSAs] Enables Public Service Announcements ads. More info https://wiki.appnexus.com/display/sdk/Toggle+PSAs
/// [loadsInBackground] Sets whether or not to load landing pages in the background before displaying them. More info https://wiki.appnexus.com/display/ST/AdView#setLoadsInBackground-boolean-
/// [resizeAdToFitContainer] Sets whether ads will expand to fit the BannerAdView. More info https://wiki.appnexus
/// .com/display/ST/BannerAdView#setResizeAdToFitContainer-boolean-
/// [autoRefreshInterval] Sets the auto-refresh interval.
// ignore: must_be_immutable
class BannerAdView extends StatefulWidget {
  int adWidth;
  int adHeight;
  int layoutWidth;
  int layoutHeight;
  LoadMode loadMode;
  Sink<AdListenerEvent> adListener;

  BannerAdView({
    Key key,
    @required this.layoutWidth,
    @required this.layoutHeight,
    @required this.loadMode,
    this.adHeight,
    this.adWidth,
    this.adListener,
    bool shouldServePSAs = false,
    bool loadsInBackground = false,
    bool resizeAdToFitContainer = false,
    bool resizeWhenLoaded = false,
    int autoRefreshInterval = 0,
    ClickThroughAction clickThroughAction,
    String placementID,
    String memberId,
    int inventoryCode,
  }) : super(key: key) {
    assert(layoutWidth != null && layoutWidth > 0);
    assert(layoutHeight != null && layoutHeight > 0);
    assert(loadMode != null);
    assert(placementID != null || (memberId != null && inventoryCode != null));
    adHeight = adHeight ?? layoutHeight;
    adWidth = adWidth ?? layoutWidth;
    creationParameters = <String, dynamic>{
      'adWidth': adWidth,
      'adHeight': adHeight,
      'layoutWidth': layoutWidth,
      'layoutHeight': layoutHeight,
      'shouldServePSAs': shouldServePSAs,
      'loadsInBackground': loadsInBackground,
      'resizeAdToFitContainer': resizeAdToFitContainer,
      'resizeWhenLoaded': resizeWhenLoaded,
      'loadWhenCreated': this.loadMode is LoadWhenCreated,
      'placementID': placementID,
      'memberId': memberId,
      'inventoryCode': inventoryCode,
      'clickThroughAction': (clickThroughAction ?? ClickThroughAction.openDeviceBrowser()).action,
      'autoRefreshInterval': autoRefreshInterval
    };
  }

  /// parameters passed to the native code via [AndroidView]
  Map<String, dynamic> creationParameters;

  @override
  State<StatefulWidget> createState() => BannerAdViewState();
}

class BannerAdViewState extends State<BannerAdView> with AutomaticKeepAliveClientMixin {
  var loaded = false;
  var loading = false;
  MethodChannel loadAdChannel;
  EventChannel adListenerEventsChannel;

  @override
  void initState() {
    context.toString();
    if (widget.loadMode is LoadWhenCreated) {
      loading = true;
    } else if (widget.loadMode is WhenInViewport) {
      (widget.loadMode as WhenInViewport).checkIfInViewport?.listen((_) {
        _checkViewport((widget.loadMode as WhenInViewport).pixelOffset);
      });
    } else if (widget.loadMode is LoadWhenTriggered) {
      (widget.loadMode as LoadWhenTriggered).triggerAdLoading?.listen((_) {
        loadAd();
      });
    }
    super.initState();
  }

  /// trigger ad loading via [MethodChannel]
  void loadAd() {
    if ((widget.loadMode is LoadWhenTriggered || !loaded) && !loading) {
      setState(() {
        loading = true;
      });
      loadAdChannel.invokeMethod('loadAd');
    }
  }

  /// function used only with the [WhenInViewport] loadMode
  void _checkViewport(int pixelOffset) {
    if (context == null) return;
    final RenderObject object = context.findRenderObject();

    if (object == null || !object.attached) {
      return;
    }

    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
    final double vpHeight = viewport.paintBounds.height;
    final RevealedOffset vpOffset = viewport.getOffsetToReveal(object, 0.0);

    final double deltaTop = vpOffset.offset - Scrollable.of(context).position.pixels;

    if ((vpHeight - deltaTop) > pixelOffset) {
      loadAd();
    }
  }

  /// Offstage is used to show the ad only if it loads (if a error occurs, no empty space will be added to your widget tree).
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Offstage(
        offstage: !loaded,
        child: Container(
          height: widget.layoutHeight.toDouble(),
          width: widget.layoutWidth.toDouble(),
          child: AndroidView(
              viewType: 'com.schibsted.flutter.appnexus/banner_ad_view',
              onPlatformViewCreated: _onPlatformViewCreated,
              creationParams: widget.creationParameters,
              creationParamsCodec: StandardMessageCodec(),
              hitTestBehavior: PlatformViewHitTestBehavior.translucent),
        ),
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  /// Better performance when scrolling on ListViews
  @override
  bool get wantKeepAlive => true;

  void _onPlatformViewCreated(int id) {
    loadAdChannel = new MethodChannel('com.schibsted.flutter.appnexus/banner_ad_view/$id');
    adListenerEventsChannel = EventChannel('com.schibsted.flutter.appnexus/banner_ad_view/callback/$id', const JSONMethodCodec());
    adListenerEventsChannel.receiveBroadcastStream().map((dynamic event) {
      return AdListenerEvent.fromJson(json.decode(event));
    }).listen((dynamic event) {
      if (!mounted) {
        return;
      }
      widget.adListener?.add(event);
      if (event is AdLoaded) {
        setState(() {
          loaded = true;
          loading = false;
        });
      } else if (event is AdRequestFailed) {
        setState(() {
          loaded = false;
          loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.adListener?.close();
    super.dispose();
  }
}
