extern NSString* const Xbox360HIDAddedNotification;
extern NSString* const Xbox360HIDRemovedNotification;
extern NSString* const Xbox360HIDActivityNotification;

@interface Xbox360HIDManager : NSObject

+ (Xbox360HIDManager*) sharedInstance;

@end
