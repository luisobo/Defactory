//
//  NSObject+Defactory.h
//  Defactory
//
//  Created by Luis Solano Bonet on 30/08/13.
//  Copyright (c) 2013 Luis Solano Bonet. All rights reserved.
//

#import <Foundation/Foundation.h>

id association(Class class);

@interface LSFactory : NSObject<NSMutableCopying>
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;
@end

@interface NSObject (Defactory)
+ (void)defineFactory:(void(^)(LSFactory *factory))definition;
+ (void)define:(NSString *)name factory:(void(^)(LSFactory *factory))definition;
+ (void)define:(NSString *)name parent:(NSString *)parent factory:(void(^)(LSFactory *factory))definition;
+ (instancetype)build;
+ (instancetype)buildWithParams:(NSDictionary *)params;
+ (instancetype)build:(NSString *)factoryName;
+ (instancetype)build:(NSString *)factoryName params:(NSDictionary *)params;

@end