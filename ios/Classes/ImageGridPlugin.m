#import "ImageGridPlugin.h"
#if __has_include(<image_grid/image_grid-Swift.h>)
#import <image_grid/image_grid-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "image_grid-Swift.h"
#endif

@implementation ImageGridPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImageGridPlugin registerWithRegistrar:registrar];
}
@end
