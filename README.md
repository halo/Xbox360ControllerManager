### Work in Progress Note

Work is in progress. I've established basic connection with the Controllers and am working on the abstraction so that you can plug this cocoa pod into your project. I don't want you to have to deal with IOHIDDevices, but with real controller instances and proper Notifications.

# Xbox 360 Controller Manager

This is a [CocoaPod](http://cocoapods.org) which provides a simple API for you to work with Xbox input devices such as controllers, guitars, and drumsets.

# Requirements

* You need at least Mountain Lion
* Install [the driver](http://tattiebogle.net/index.php/ProjectRoot/Xbox360Controller/OsxDriver#toc1) which allows you to connect Xbox input devices (Controllers, Guitars, Drumsets) to your Mac.

You're ready to roll with USB-cable devices! If you plan on using wireless devices, you'll *have* to buy one of those first:

![Xbox 360 Wireless Receiver](http://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Xbox_360_Wireless_Receiver.png/300px-Xbox_360_Wireless_Receiver.png)

# Installation

Head over to [cocoapods.org](http://cocoapods.org) to learn more about how it works. Here's a quickie:

### 1. Download the repo *next to your project*:

```
git clone git://github.com/halo/Xbox360ControllerManager.git ~/some/where
```

### 2. Create a `Gemfile` in *your* project:

```ruby
source :rubygems

gem 'cocoapods'
```

### 3. Create a `Podfile` in *your* project:

```ruby
platform  :osx
xcodeproj 'YourProject'

pod 'Xbox360ControllerManager', '0.0.1', :local => '~/some/where'
```

### 4. Install and run bundler if you don't already have it:

```bash
gem install bundle
bundle install
```

### 4. Run the pod

```bash
pod install
```

# Usage

This would be a minimal implementation of your Application Delegate:

```objectivec
#import "AppDelegate.h"

#import "Xbox360ControllerManager.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSLog(@"Application started");
  [Xbox360ControllerManager sharedInstance];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerAdded:) name:Xbox360ControllerAddedNotification object:NULL];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerRemoved:) name:Xbox360ControllerRemovedNotification object:NULL];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerAction:) name:Xbox360ControllerActionNotification object:NULL];
}

- (void) controllerAdded:(NSNotification*)notification {
  NSLog(@"You added a controller: %@", [notification object]);
}

- (void) controllerRemoved:(NSNotification*)notification {
  NSLog(@"You removed a controller: %@", [notification object]);
}

- (void) controllerAction:(NSNotification*)notification {
  NSLog(@"You pressed some buttons: %@", [notification object]);
}
@end
```

### Credits

* [Colin Munro](http://mice-software.com/contact.php) is the genius behind the Mac OS driver routine.
* [Derek van Vliet](https://github.com/derekvanvliet/Xbox360ControllerManager) had an inspiring project that had the same conceptual idea behind it - and the project name :)

# License

MIT 2013 funkensturm. See [MIT-LICENSE](http://github.com/halo/Xbox360Controller/blob/master/MIT-LICENSE).
