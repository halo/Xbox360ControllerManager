#import <IOKit/hid/IOHIDLib.h>

@interface Xbox360Controller : NSObject {}

@property (readwrite) IOHIDDeviceRef hid;

- (Xbox360Controller*) initWithHidDevice:(IOHIDDeviceRef)device;

@end
