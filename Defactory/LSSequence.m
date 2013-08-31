//
//  LSSequence.m
//  Defactory
//
//  Created by Luis Solano Bonet on 30/08/13.
//  Copyright (c) 2013 Luis Solano Bonet. All rights reserved.
//

#import "LSSequence.h"

LSSequence *sequence(id(^block)(NSUInteger i)) {
    return [[LSSequence alloc] initWithBlock:block];
}

@interface LSSequence ()
@property (nonatomic, assign) NSUInteger i;
@property (nonatomic, copy) id(^block)(NSUInteger i);
@end

@implementation LSSequence
- (instancetype)initWithBlock:(id(^)(NSUInteger i))block {
    self = [super init];
    if (self) {
        _i = 0;
        _block = block;
    }
    return self;
}

- (id)next {
    return self.block(self.i++);
}
@end
