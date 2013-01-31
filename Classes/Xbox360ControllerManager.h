@interface Xbox360ControllerManager : NSObject {}

@property (nonatomic, strong) NSMutableArray *controllers;

//@property (readonly) int controllerCount;

+ (Xbox360ControllerManager*) sharedInstance;

//-(Xbox360Controller*)controllerWithHid:(io_object_t)hid;

//-(void)updateControllers;
//-(Xbox360Controller*)getController:(int)index;
//-(void)setAllDelegates:(id<Xbox360ControllerDelegate>)d;

@end
