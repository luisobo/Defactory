#import "Kiwi.h"
#import "Defactory.h"

@interface LSUser : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, assign) NSUInteger loginCount;
@property (nonatomic, assign) BOOL somethingBool;
@property (nonatomic, strong) NSString *email;
@end
@implementation LSUser
@end

FACTORIES(^{
    [LSUser defineFactory:^(LSFactory *f) {
        f[@"username"] = @"foo";
        f[@"password"] = @"hunter2";
        f[@"email"] = sequence(^(NSUInteger i) { return [NSString stringWithFormat:@"foo%d@example.com", i]; });
    }];
});

FACTORIES(^{
    [LSUser define:@"suspended" parent:@"LSUser" factory:^(LSFactory *f) {
        f[@"state"] = @"suspended";
        f[@"loginCount"] = @2;
        f[@"somethingBool"] = @YES;
    }];
});

SPEC_BEGIN(DefactorySpec)

it(@"builds an object", ^{
    LSUser *user = [LSUser build];
    [[user.username should] equal:@"foo"];
    [[user.password should] equal:@"hunter2"];
    [[user.state should] beNil];
    [[user.email should] equal:@"foo0@example.com"];

    user = [LSUser buildWithParams:@{@"password": @"secret", @"state": @"active"}];
    [[user.username should] equal:@"foo"];
    [[user.password should] equal:@"secret"];
    [[user.state should] equal:@"active"];
    [[theValue(user.loginCount) should] equal:theValue(0)];
    [[user.email should] equal:@"foo1@example.com"];

    user = [LSUser buildWithParams:@{@"email": @"yeah@example.com"}];
    [[user.email should] equal:@"yeah@example.com"];

    user = [LSUser build:@"suspended"];
    [[user.username should] equal:@"foo"];
    [[user.password should] equal:@"hunter2"];
    [[user.email should] equal:@"foo2@example.com"];
    [[user.state should] equal:@"suspended"];
    [[theValue(user.loginCount) should] equal:theValue(2)];
    [[theValue(user.somethingBool) should] beYes];
});

SPEC_END
