import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoadMode {
  LoadMode._();

  /// factory method to create a class [LoadWhenCreated]
  factory LoadMode.whenCreated() = LoadWhenCreated;

  /// factory method to create a class [LoadWhenTriggered]
  factory LoadMode.whenTriggered(Stream triggerLoadingAd) = LoadWhenTriggered;

  /// factory method to create a class [WhenScrolledToAd]
  factory LoadMode.whenScrolledToAd(PublishSubject<ScrollNotification> scrollNotificationSubject, int pixelOffset) = WhenScrolledToAd;
}

/// Use this class to automatically load the ad when it's created in the native code.
///
/// Use the factory method [LoadMode.whenCreated] to create it.
///
/// Check the [WhenCreatedExample] for more info.
class LoadWhenCreated extends LoadMode {
  LoadWhenCreated() : super._();
}

/// Use this class to when you want to asynchronously load the ad via a Stream
///
/// [triggerLoadingAd] is a Stream. [BannerAdView] class listens to it and load an ad on every item passed to this Stream
///
/// Use the factory method [LoadMode.whenTriggered] to create it.
///
/// Check the [WhenTriggeredExample] for more info.
class LoadWhenTriggered extends LoadMode {
  LoadWhenTriggered(this.triggerAdLoading) : super._();

  final Stream triggerAdLoading;
}

/// Use this class to when you want to asynchronously load the ad via scroll gestures.
///
/// [scrollNotificationSubject] pass the [NotificationListener] notifications. Check the [WhenScrolledToExample] for more info.
/// [pixelOffset] number of pixels that is used to calculate when to load the ad.
/// If set to 0, the ad will load when the widget will enter the viewport.
/// If set to -100, the ad will load -100 px before appearing on the screen.
/// If set to 100, the ad will load when 100 px of the ad could be shown.
///
/// Use the factory method [LoadMode.whenScrolledToAd] to create it.
///
/// Check the [WhenScrolledToExample] for more info.
class WhenScrolledToAd extends LoadMode {
  WhenScrolledToAd(this.scrollNotificationSubject, this.pixelOffset) : super._();

  final PublishSubject<ScrollNotification> scrollNotificationSubject;
  final int pixelOffset;
}
