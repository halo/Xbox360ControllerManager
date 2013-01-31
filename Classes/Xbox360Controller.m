#import "Xbox360Controller.h"

@implementation Xbox360Controller

@synthesize hid;

- (Xbox360Controller*) initWithHidDevice:(IOHIDDeviceRef)device {
  self = [super init];
  if (self) hid = device;
  return self;
}

/*
+ (Xbox360Controller*) initWithHidDevice:(IOHIDDeviceRef)device {
	Xbox360Controller *result = [self new];
	if (result) {
    result.hid = device;
  }
  return result;
}
*/

@end

