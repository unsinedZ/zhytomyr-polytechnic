#import "GoogleAuthenticationPlugin.h"
#if __has_include(<google_authentication/google_authentication-Swift.h>)
#import <google_authentication/google_authentication-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "google_authentication-Swift.h"
#endif

@implementation GoogleAuthenticationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGoogleAuthenticationPlugin registerWithRegistrar:registrar];
}
@end
