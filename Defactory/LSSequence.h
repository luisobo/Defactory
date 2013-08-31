//
//  LSSequence.h
//  Defactory
//
//  Created by Luis Solano Bonet on 30/08/13.
//  Copyright (c) 2013 Luis Solano Bonet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSSequence;

LSSequence *sequence(id(^block)(NSUInteger i));

@interface LSSequence : NSObject
- (instancetype)initWithBlock:(id(^)(NSUInteger i))block;

- (id)next;
@end
