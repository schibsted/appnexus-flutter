class AdListenerEvent {
  final String name;

  static fromJson(Map<String, dynamic> json) {
    switch (json["name"]) {
      case "adRequestFailed":
        return AdListenerEvent.adRequestFailed(json["errorCode"]);
        break;
      case "adLoaded":
        return AdListenerEvent.adLoaded();
        break;
      case "adClicked":
        return AdListenerEvent.onAdClicked(json["clickUrl"]);
        break;
      default:
        return EventError();
        break;
    }
  }

  AdListenerEvent._(this.name);

  /// factory method to create [AdRequestFailed] class
  factory AdListenerEvent.adRequestFailed(String errorCode) {
    return AdRequestFailed(errorCode);
  }

  /// factory method to create [AdLoaded] class
  factory AdListenerEvent.adLoaded() {
    return AdLoaded();
  }

  /// factory method to create [AdClicked] class
  factory AdListenerEvent.onAdClicked(String clickUrl) {
    return AdClicked(clickUrl);
  }

  /// factory method to create [EventError] class
  factory AdListenerEvent.eventError() {
    return EventError();
  }

  @override
  String toString() {
    return "$name";
  }
}

/// Callback event from AppNexus AdListener, informing that the ad did not load.
///
/// [errorCode] errorCode from the AppNexus SDK
class AdRequestFailed extends AdListenerEvent {
  AdRequestFailed(this.errorCode) : super._("adRequestFailed");

  String errorCode;

  AdRequestFailed.fromJson(Map<String, dynamic> json) : super._("adRequestFailed") {
    this.errorCode = json['errorCode'];
  }

  @override
  String toString() {
    return "$name ;errorCode= $errorCode";
  }
}

/// Callback event from AppNexus AdListener, informing that the ad has loaded.
class AdLoaded extends AdListenerEvent {
  AdLoaded() : super._("adLoaded");
}

/// Callback event from AppNexus AdListener, informing that the ad was clicked.
///
/// [clickUrl] the ad URL
class AdClicked extends AdListenerEvent {
  AdClicked(this.clickUrl) : super._("adClicked");

  String clickUrl;

  AdClicked.fromJson(Map<String, dynamic> json) : super._("adClicked") {
    this.clickUrl = json['clickUrl'];
  }

  @override
  String toString() {
    return "$name ;clickUrl= $clickUrl";
  }
}

/// Internal event, should never happen
class EventError extends AdListenerEvent {
  EventError() : super._("eventError");
}
