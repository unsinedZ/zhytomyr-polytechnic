#import "TermsAndConditionsPlugin.h"
#if __has_include(<terms_and_conditions/terms_and_conditions-Swift.h>)
#import <terms_and_conditions/terms_and_conditions-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "terms_and_conditions-Swift.h"
#endif

@implementation TermsAndConditionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTermsAndConditionsPlugin registerWithRegistrar:registrar];
}
@end
