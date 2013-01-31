#import "Xbox360ControllerManager.h"

#import <IOKit/hid/IOHIDLib.h>
#import "Xbox360ControllerConstants.h"
#import "Xbox360HIDManager.h"
#import "Xbox360Controller.h"

@implementation Xbox360ControllerManager

static Xbox360ControllerManager *sharedXbox360ControllerManager = nil;

@synthesize controllers;

+ (Xbox360ControllerManager*) sharedInstance {
	if (sharedXbox360ControllerManager) return sharedXbox360ControllerManager;
  sharedXbox360ControllerManager = [Xbox360ControllerManager new];
  return sharedXbox360ControllerManager;
}

- (Xbox360ControllerManager*) init {
  self = [super init];
  if (self) {
    [[Xbox360HIDManager sharedInstance] activate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HIDWasAdded:) name:Xbox360HIDAddedNotification object:NULL];
  }
  return self;
}


- (void) HIDWasAdded:(NSNotification*)notification {
  IOHIDDeviceRef device = (__bridge IOHIDDeviceRef)([notification object]);
  NSString *manufacturer = (__bridge NSString*)(IOHIDDeviceGetProperty(device, CFSTR(kIOHIDManufacturerKey)));
  NSString *name = (__bridge NSString*)(IOHIDDeviceGetProperty(device, CFSTR(kIOHIDProductKey)));
  NSString *serial = (__bridge NSString*)(IOHIDDeviceGetProperty(device, CFSTR(kIOHIDSerialNumberKey)));
  NSLog(@"HID was plugged in: %@ %@ %@", manufacturer, name, serial);
  //  Xbox360Controller *controller = [[Xbox360Controller new] initWithHidDevice:device];
  //Xbox360Controller* controller = [notification object];
 // NSLog(@"Look at my controllers: %@", self.controllers);
  
}






- (NSMutableArray*) controllers {
  if (controllers) return controllers;
  controllers = [NSMutableArray arrayWithCapacity:4];
  return controllers;
}

@end
