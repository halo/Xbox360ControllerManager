#import "Xbox360ControllerManager.h"

#import <IOKit/hid/IOHIDLib.h>
#import "Xbox360HIDManager.h"
#import "Xbox360Controller.h"

NSString* const Xbox360ControllerAddedNotification = @"Xbox360ControllerAddedNotification";
NSString* const Xbox360ControllerRemovedNotification = @"Xbox360ControllerRemovedNotification";
NSString* const Xbox360ControllerActionNotification = @"Xbox360ControllerActionNotification";

@implementation Xbox360ControllerManager

static Xbox360ControllerManager *sharedXbox360ControllerManager = nil;

@synthesize controllers;

+ (Xbox360ControllerManager*) sharedInstance {
	if (sharedXbox360ControllerManager) return sharedXbox360ControllerManager;
  [Xbox360HIDManager sharedInstance];
  sharedXbox360ControllerManager = [Xbox360ControllerManager new];
  return sharedXbox360ControllerManager;
}

- (Xbox360ControllerManager*) init {
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HIDWasAdded:) name:Xbox360HIDAddedNotification object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HIDWasRemoved:) name:Xbox360HIDRemovedNotification object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HIDAction:) name:Xbox360HIDActionNotification object:NULL];
  }
  return self;
}

- (void) HIDAction:(NSNotification*)notification {
  // Fetching the data
  NSDictionary *event = [notification object];
  IOHIDDeviceRef device = (__bridge IOHIDDeviceRef)([event objectForKey:@"device"]);
  NSString *serial = (__bridge NSString*)(IOHIDDeviceGetProperty(device, CFSTR(kIOHIDSerialNumberKey)));
  Xbox360Controller *controller = [self.controllers objectForKey:serial];
  if (!controller) return;
  // Wrapping it up in a dictionary
  NSArray *keys = [NSArray arrayWithObjects:@"controller", @"element", @"value", nil];
  NSArray *values = [NSArray arrayWithObjects:controller, [event objectForKey:@"element"], [event objectForKey:@"value"], nil];
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
  [[NSNotificationCenter defaultCenter] postNotificationName:Xbox360ControllerActionNotification object:dictionary];
}

- (void) HIDWasAdded:(NSNotification*)notification {
  IOHIDDeviceRef device = (__bridge IOHIDDeviceRef)([notification object]);
  Xbox360Controller *controller = [[Xbox360Controller new] initWithHidDevice:device];
  [self.controllers setObject:controller forKey:controller.serial];
  [[NSNotificationCenter defaultCenter] postNotificationName:Xbox360ControllerAddedNotification object:controller];
}

- (void) HIDWasRemoved:(NSNotification*)notification {
  IOHIDDeviceRef device = (__bridge IOHIDDeviceRef)([notification object]);
  NSString *serial = (__bridge NSString*)(IOHIDDeviceGetProperty(device, CFSTR(kIOHIDSerialNumberKey)));
  Xbox360Controller *controller = [self.controllers objectForKey:serial];
  [self.controllers removeObjectForKey:serial];
  [[NSNotificationCenter defaultCenter] postNotificationName:Xbox360ControllerRemovedNotification object:controller];
}

- (NSMutableDictionary*) controllers {
  if (controllers) return controllers;
  controllers = [NSMutableDictionary dictionaryWithCapacity:4];
  return controllers;
}

@end
