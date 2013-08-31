# Defactory
Objective-C object factory for testing.

## Features
* Define factories once, build everywhere.
* Named factories.
* Sequences.
* Associations.
* Handle primitives
* Factory inheritance.
* Tested.

## Installation
### [Coming soon] As a [CocoaPod](http://cocoapods.org/)
Just add this to your Podfile
```ruby
pod 'Defactory'
```

### Other approaches
* You should be able to add Defactory to you source tree. If you are using git, consider using a `git submodule`

## Usage
Given the following User class

LSUser

```objc
@interface LSUser : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, assign) NSUInteger loginCount;
@property (nonatomic, assign) BOOL somethingBool;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) LSUser *dad;
@end
@implementation LSUser
@end
```

#### Define the one or multiple factories

```objc
FACTORIES(^{
    // Default factory
    [LSUser defineFactory:^(LSFactory *f) {
        f[@"username"] = @"foo"; // Set values.
        f[@"password"] = @"hunter2";

        // Define sequences.
        f[@"email"] = sequence(^(NSUInteger i) { return [NSString stringWithFormat:@"foo%d@example.com", i]; });
    }];

    // Other named factories with inheritance.
    [LSUser define:@"suspended" parent:@"LSUser" factory:^(LSFactory *f) {
        f[@"state"] = @"suspended";

        // User boxed primitives, Defactory will take care of the rest.
        f[@"loginCount"] = @2;
        f[@"somethingBool"] = @YES;
    }];

    [LSUser define:@"son" parent:@"LSUser" factory:^(LSFactory *f) {

        // Associations.
        f[@"dad"] = association([LSUser class]);
    }];
});
```

## Contributing

1. Fork it
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create new Pull Request
