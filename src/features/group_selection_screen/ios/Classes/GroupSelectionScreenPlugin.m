#import "GroupSelectionScreenPlugin.h"
#if __has_include(<group_selection_screen/group_selection_screen-Swift.h>)
#import <group_selection_screen/group_selection_screen-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "group_selection_screen-Swift.h"
#endif

@implementation GroupSelectionScreenPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGroupSelectionScreenPlugin registerWithRegistrar:registrar];
}
@end
