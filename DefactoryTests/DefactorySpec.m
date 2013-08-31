#import "Kiwi.h"
#import "Defactory.h"

@interface LSUser : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *state;
@end
@implementation LSUser
@end

FACTORIES(^{
    [LSUser defineFactory:^(LSFactory *f) {
        f[@"username"] = @"foo";
        f[@"password"] = @"hunter2";
    }];
});

FACTORIES(^{
    [LSUser define:@"suspended" factory:^(LSFactory *f) {
        f[@"state"] = @"suspended";
    }];
});

SPEC_BEGIN(DefactorySpec)

it(@"builds an object", ^{
    LSUser *user = [LSUser build];
    [[user.username should] equal:@"foo"];
    [[user.password should] equal:@"hunter2"];
    [[user.state should] beNil];

    user = [LSUser buildWithParams:@{@"password": @"secret", @"state": @"active"}];
    [[user.username should] equal:@"foo"];
    [[user.password should] equal:@"secret"];
    [[user.state should] equal:@"active"];

    user = [LSUser build:@"suspended"];
    [[user.username should] beNil];
    [[user.password should] beNil];
    [[user.state should] equal:@"suspended"];
});

SPEC_END
