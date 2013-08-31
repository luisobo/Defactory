//
//  Defactory.h
//  Defactory
//
//  Created by Luis Solano Bonet on 30/08/13.
//  Copyright (c) 2013 Luis Solano Bonet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Defactory.h"

#define FACTORIES(definitions)\
@interface LSFactories : NSObject\
\
@end\
@implementation LSFactories\
+ (void)loadFactoryDefinitions {\
    definitions();\
}\
@end
