#import "GoogleAppleAuthenticationPlugin.h"
#if __has_include(<google_apple_authentication/google_apple_authentication-Swift.h>)
#import <google_apple_authentication/google_apple_authentication-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "google_apple_authentication-Swift.h"
#endif

@implementation GoogleAppleAuthenticationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGoogleAppleAuthenticationPlugin registerWithRegistrar:registrar];
}
@end
