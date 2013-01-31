#import <IOKit/hid/IOHIDLib.h>

@interface Xbox360Controller : NSObject {}

@property (readonly) IOHIDDeviceRef hid;
@property (readonly, strong) NSString *serial;
@property (readonly, strong) NSString *transport;
@property (readonly, strong) NSString *vendor;
@property (readonly, strong) NSString *manufacturer;
@property (readonly, strong) NSString *name;

- (Xbox360Controller*) initWithHidDevice:(IOHIDDeviceRef)device;

@end
