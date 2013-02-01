#import <IOKit/hid/IOHIDLib.h>

extern NSString* const Xbox360ControllerUpdatedNotification;
extern NSString* const Xbox360ControllerActionNotification;

@interface Xbox360Controller : NSObject {}

// Hardware References
@property (readonly) IOHIDDeviceRef hid;

// Metadata
@property (readonly, strong) NSString *serial;
@property (readonly, strong) NSString *transport;
@property (readonly, strong) NSString *vendor;
@property (readonly, strong) NSString *manufacturer;
@property (readonly, strong) NSString *name;

// Buttons
@property (atomic) BOOL aButton;
@property (atomic) BOOL bButton;
@property (atomic) BOOL xButton;
@property (atomic) BOOL yButton;
@property (atomic) BOOL leftButton;
@property (atomic) BOOL rightButton;
@property (atomic) BOOL upButton;
@property (atomic) BOOL downButton;
@property (atomic) BOOL backButton;
@property (atomic) BOOL xboxButton;
@property (atomic) BOOL startButton;
@property (atomic) BOOL leftShoulderButton;
@property (atomic) BOOL rightShoulderButton;
@property (atomic) BOOL leftStickButton;
@property (atomic) BOOL rightStickButton;

// Trigger Buttons
@property (atomic) int leftTrigger;
@property (atomic) int rightTrigger;

// Sticks
@property (atomic) int leftStickHorizontal;
@property (atomic) int leftStickVertical;
@property (atomic) int rightStickHorizontal;
@property (atomic) int rightStickVertical;

// Internal variables used for action detection
@property (atomic) int leftStickDeadZoneThreshold;
@property (atomic) BOOL leftStickInLeftPosition;
@property (atomic) BOOL leftStickInRightPosition;
@property (atomic) BOOL leftStickInUpPosition;
@property (atomic) BOOL leftStickInDownPosition;

- (Xbox360Controller*) initWithHidDevice:(IOHIDDeviceRef)device;

@end
