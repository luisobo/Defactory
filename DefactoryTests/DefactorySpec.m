#import "Kiwi.h"
#import "Defactory.h"

@interface LSUser : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@end
@implementation LSUser
@end

FACTORIES(^{
    [LSUser defineFactory:^(LSFactory *f) {
        f[@"username"] = @"foo";
        f[@"password"] = @"hunter2";
    }];
});

SPEC_BEGIN(DefactorySpec)

it(@"builds an object", ^{
    LSUser *user = [LSUser build];

    [[user.username should] equal:@"foo"];
    [[user.password should] equal:@"hunter2"];

    user = [LSUser buildWithParams:@{@"password": @"secret"}];
    [[user.username should] equal:@"foo"];
    [[user.password should] equal:@"secret"];
});

SPEC_END
