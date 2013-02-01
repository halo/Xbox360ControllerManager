extern NSString* const Xbox360ControllerAddedNotification;
extern NSString* const Xbox360ControllerRemovedNotification;
extern NSString* const Xbox360ControllerActivityNotification;

@interface Xbox360ControllerManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *controllers;

+ (Xbox360ControllerManager*) sharedInstance;

@end
