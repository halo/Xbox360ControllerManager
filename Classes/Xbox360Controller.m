#import "Xbox360Controller.h"

#import "Xbox360ControllerManager.h"

NSString* const Xbox360ControllerUpdatedNotification = @"Xbox360ControllerUpdatedNotification";
NSString* const Xbox360ControllerActionNotification = @"Xbox360ControllerActionNotification";

@implementation Xbox360Controller

@synthesize hid;
@synthesize serial, transport, vendor, manufacturer, name;

- (Xbox360Controller*) initWithHidDevice:(IOHIDDeviceRef)device {
  self = [super init];
  if (self) {
    hid = device;
    self.leftStickDeadZoneThreshold = (32767 * 0.8);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerActivity:) name:Xbox360ControllerActivityNotification object:NULL];
  }
  return self;
}

- (void) controllerActivity:(NSNotification*)notification {
  NSDictionary *event = [notification object];
  NSNumber *element = [event objectForKey:@"element"];
  NSNumber *value = [event objectForKey:@"value"];
  if (self == [event objectForKey:@"controller"]) {
    [self updateFromElement:[element intValue] andValue:[value intValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:Xbox360ControllerUpdatedNotification object:self];
  }
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

- (void) updateFromElement:(int)element andValue:(int)value {
  switch (element) {
    case 10: self.upButton = value; break;
    case 11: self.downButton = value; break;
    case 12: self.leftButton = value; break;
    case 13: self.rightButton = value; break;
    case 14: self.startButton = value; break;
    case 15: self.backButton = value; break;
    case 16: self.leftStickButton = value; break;
    case 17: self.rightStickButton = value; break;
    case 18: self.leftShoulderButton = value; break;
    case 19: self.rightShoulderButton = value; break;
    case 20: self.xboxButton = value; break;
    case 21: self.aButton = value; break;
    case 22: self.bButton = value; break;
    case 23: self.xButton = value; break;
    case 24: self.yButton = value; break;
    case 27:
      self.leftStickHorizontal = value;
      if (value < -self.leftStickDeadZoneThreshold) {
        if (self.leftStickInLeftPosition) return;
        self.leftStickInLeftPosition = YES;
        self.leftStickInRightPosition = NO;
        [self sendLeftStickLeftActionNotification];
        [NSTimer scheduledTimerWithTimeInterval:0.19 target:self selector:@selector(leftStickLeftAction:) userInfo:NULL repeats:YES];
      } else if (value > self.leftStickDeadZoneThreshold) {
        if (self.leftStickInRightPosition) return;
        self.leftStickInLeftPosition = NO;
        self.leftStickInRightPosition = YES;
        [self sendLeftStickRightActionNotification];
        [NSTimer scheduledTimerWithTimeInterval:0.19 target:self selector:@selector(leftStickRightAction:) userInfo:NULL repeats:YES];
      } else {
        self.leftStickInLeftPosition = NO;
        self.leftStickInRightPosition = NO;
      }
      break;
    case 28:
      self.leftStickHorizontal = value;
      if (value < -self.leftStickDeadZoneThreshold) {
        if (self.leftStickInUpPosition) return;
        self.leftStickInUpPosition = YES;
        self.leftStickInDownPosition = NO;
        [self sendLeftStickUpActionNotification];
        [NSTimer scheduledTimerWithTimeInterval:0.19 target:self selector:@selector(leftStickUpAction:) userInfo:NULL repeats:YES];
      } else if (value > self.leftStickDeadZoneThreshold) {
        if (self.leftStickInDownPosition) return;
        self.leftStickInUpPosition = NO;
        self.leftStickInDownPosition = YES;
        [self sendLeftStickDownActionNotification];
        [NSTimer scheduledTimerWithTimeInterval:0.19 target:self selector:@selector(leftStickDownAction:) userInfo:NULL repeats:YES];
      } else {
        self.leftStickInUpPosition = NO;
        self.leftStickInDownPosition = NO;
      }
      break;
    case 29: self.rightStickHorizontal = value; break;
    case 30: self.rightStickVertical = value; break;
  }
}

- (void) leftStickLeftAction:(NSTimer*)timer {
  if (self.leftStickInLeftPosition) {
    [self sendLeftStickLeftActionNotification];
  } else {
    [timer invalidate];
  }
}

- (void) leftStickRightAction:(NSTimer*)timer {
  if (self.leftStickInRightPosition) {
    [self sendLeftStickRightActionNotification];
  } else {
    [timer invalidate];
  }
}

- (void) leftStickUpAction:(NSTimer*)timer {
  if (self.leftStickInUpPosition) {
    [self sendLeftStickUpActionNotification];
  } else {
    [timer invalidate];
  }
}

- (void) leftStickDownAction:(NSTimer*)timer {
  if (self.leftStickInDownPosition) {
    [self sendLeftStickDownActionNotification];
  } else {
    [timer invalidate];
  }
}

- (void) sendLeftStickLeftActionNotification {
  [self sendActionNotification:@"left"];
}

- (void) sendLeftStickRightActionNotification {
  [self sendActionNotification:@"right"];
}

- (void) sendLeftStickUpActionNotification {
  [self sendActionNotification:@"up"];
}

- (void) sendLeftStickDownActionNotification {
  [self sendActionNotification:@"down"];
}

- (void) sendActionNotification:(NSString*)action {
  [[NSNotificationCenter defaultCenter] postNotificationName:Xbox360ControllerActionNotification object:action];
}

- (NSString*) property:(char*)key {
  if (!self.hid) return @"HID not found";
  return (__bridge NSString*)(IOHIDDeviceGetProperty(self.hid, (__bridge CFStringRef)([NSString stringWithUTF8String:key])));
}

@end

