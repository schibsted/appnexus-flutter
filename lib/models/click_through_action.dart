class ClickThroughAction {
  final String action;

  ClickThroughAction._(this.action);

  /// factory method to create a class [OpenDeviceBrowser]
  factory ClickThroughAction.openDeviceBrowser() = OpenDeviceBrowser;

  /// factory method to create a class [OpenSdkBrowser]
  factory ClickThroughAction.openSdkBrowser() = OpenSdkBrowser;

  /// factory method to create a class [ReturnUrl]
  factory ClickThroughAction.returnUrl() = ReturnUrl;
}

/// Use this class to open the clicked load the ad in the device browser
///
/// Use the factory method [ClickThroughAction.openDeviceBrowser] to create it.
class OpenDeviceBrowser extends ClickThroughAction {
  OpenDeviceBrowser() : super._("open_device_browser");
}

/// Use this class to open the clicked load the ad in AppNexus SDK browser
///
/// Use the factory method [ClickThroughAction.openSdkBrowser] to create it.
class OpenSdkBrowser extends ClickThroughAction {
  OpenSdkBrowser() : super._("open_sdk_browser");
}

/// Use this class open a clicked ad in a custom way. You will get a AdClicked event with the URL.
///
/// Use the factory method [ClickThroughAction.returnUrl] to create it.
class ReturnUrl extends ClickThroughAction {
  ReturnUrl() : super._("return_url");
}
