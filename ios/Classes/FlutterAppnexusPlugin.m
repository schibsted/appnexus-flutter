#import "FlutterAppnexusPlugin.h"
#import <flutter_appnexus/flutter_appnexus-Swift.h>

@implementation FlutterAppnexusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAppnexusPlugin registerWithRegistrar:registrar];
}
@end
