#import "Xbox360Controller.h"

@implementation Xbox360Controller

@synthesize hid;
@synthesize serial, transport, vendor, manufacturer, name;

- (Xbox360Controller*) initWithHidDevice:(IOHIDDeviceRef)device {
  self = [super init];
  if (self) hid = device;
  return self;
}

- (NSString*) serial {
  if (serial) return serial;
  serial = [self property:kIOHIDSerialNumberKey];
  return serial;
}

- (NSString*) transport {
  if (transport) return transport;
  transport = [self property:kIOHIDTransportKey];
  return transport;
}

- (NSString*) manufacturer {
  if (manufacturer) return manufacturer;
  manufacturer = [self property:kIOHIDManufacturerKey];
  return manufacturer;
}

- (NSString*) name {
  if (name) return name;
  name = [self property:kIOHIDProductKey];
  return name;
}

- (NSString*) property:(char*)key {
  if (!self.hid) return @"HID not found";
  return (__bridge NSString*)(IOHIDDeviceGetProperty(self.hid, (__bridge CFStringRef)([NSString stringWithUTF8String:key])));
}

@end

