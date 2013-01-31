#import "Xbox360HIDManager.h"

#import <IOKit/hid/IOHIDLib.h>
#import "Xbox360ControllerConstants.h"

@implementation Xbox360HIDManager

static Xbox360HIDManager *sharedXbox360HIDManager = nil;

+ (Xbox360HIDManager*) sharedInstance {
	if (sharedXbox360HIDManager) return sharedXbox360HIDManager;
  sharedXbox360HIDManager = [Xbox360HIDManager new];
  return sharedXbox360HIDManager;
}

void HIDAction(void* device, IOReturn inResult, void* inSender, IOHIDValueRef valueRef) {
  if (!device || inResult != 0) return;
  // Fetching the data
  NSString *serial = (__bridge NSString*)(IOHIDDeviceGetProperty(device, CFSTR(kIOHIDSerialNumberKey)));
  IOHIDElementRef element = IOHIDValueGetElement(valueRef);
  NSNumber *elementID = [NSNumber numberWithInt:IOHIDElementGetCookie(element)];
  NSNumber *value = [NSNumber numberWithInt:IOHIDValueGetIntegerValue(valueRef)];
  // Wrapping it up in a dictionary
  NSArray *dictionaryKeys = [NSArray arrayWithObjects:@"device", @"element", @"value", nil];
  NSArray *dictionaryValues = [NSArray arrayWithObjects:(__bridge id)(device), elementID, value, nil];
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:dictionaryValues forKeys:dictionaryKeys];
  // Sending the Notification with the dictionary
  [[NSNotificationCenter defaultCenter] postNotificationName:Xbox360HIDActionNotification object:dictionary];
}

void HIDWasAdded(void* inContext, IOReturn inResult, void* inSender, IOHIDDeviceRef device) {
  IOHIDDeviceRegisterInputValueCallback(device, HIDAction, device);
  [[NSNotificationCenter defaultCenter] postNotificationName:Xbox360HIDAddedNotification object:(__bridge id)(device)];
}

void HIDWasRemoved(void* inContext, IOReturn inResult, void* inSender, IOHIDDeviceRef device) {
  // Unregistering the callback handling device events
  IOHIDDeviceRegisterInputValueCallback(device, NULL, NULL);
  [[NSNotificationCenter defaultCenter] postNotificationName:Xbox360HIDRemovedNotification object:(__bridge id)(device)];
}

- (void) activate {
  // Instantiate the Human Input Device Manager
  IOHIDManagerRef hidManager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
  // Tell the Manager which devices we're interested in
  IOHIDManagerSetDeviceMatching(hidManager, (__bridge CFDictionaryRef)([self deviceCriteria]));
  // Call these methods when something related to the devices i happening
  IOHIDManagerRegisterDeviceMatchingCallback(hidManager, HIDWasAdded, NULL);
	IOHIDManagerRegisterDeviceRemovalCallback(hidManager, HIDWasRemoved, NULL);
  IOHIDManagerRegisterInputValueCallback(hidManager, HIDAction, NULL);
  // Let the Manager start observing Devices
	IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	IOHIDManagerOpen(hidManager, kIOHIDOptionsTypeNone);
}

- (NSDictionary*) deviceCriteria {
  NSString *usageKey = (NSString*)CFSTR(kIOHIDDeviceUsageKey);
  NSString *pageKey  = (NSString*)CFSTR(kIOHIDDeviceUsagePageKey);
  NSNumber *usageValue = [NSNumber numberWithInt: kHIDUsage_GD_GamePad];
  NSNumber *pageValue  = [NSNumber numberWithInt: kHIDPage_GenericDesktop];
  return [NSDictionary dictionaryWithObjectsAndKeys:usageValue, usageKey, pageValue, pageKey, nil];
}

@end
