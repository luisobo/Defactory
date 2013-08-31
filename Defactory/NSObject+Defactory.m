//
//  NSObject+Defactory.m
//  Defactory
//
//  Created by Luis Solano Bonet on 30/08/13.
//  Copyright (c) 2013 Luis Solano Bonet. All rights reserved.
//

#import "NSObject+Defactory.h"
#import <objc/runtime.h>

__attribute__((constructor))
static void PIXFactoriesConstruct() {
    Class class = NSClassFromString(@"LSFactories");
    [class performSelector:@selector(loadFactoryDefinitions)];
}

@interface LSFactory ()
@property (nonatomic, strong) NSMutableDictionary *properties;
@end

@implementation LSFactory

- (instancetype)init {
    self = [super init];
    if (self) {
        _properties = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    self.properties[key] = object;
}

- (id)copyWithZone:(NSZone *)zone {
    LSFactory *copy = [[LSFactory alloc] init];
    copy.properties = [self.properties copy];
    return copy;
}

@end

@implementation NSObject (Defactory)

static void * LSFactoriesKey = &LSFactoriesKey;
- (NSMutableDictionary *)factories {
    NSMutableDictionary *factories = objc_getAssociatedObject(self, LSFactoriesKey);
    if (!factories) {
        factories = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, LSFactoriesKey, factories, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return factories;
}

+ (LSFactory *)factoryNamed:(NSString *)name {
    return self.factories[name];
}

+ (void)defineFactory:(void(^)(LSFactory *factory))definition {
    [self define:NSStringFromClass(self) factory:definition];
}

+ (void)define:(NSString *)name factory:(void(^)(LSFactory *factory))definition {
    LSFactory *factory = [[LSFactory alloc] init];
    definition(factory);
    self.factories[name] = factory;
}

+ (instancetype)build {
    return [self build:NSStringFromClass(self)];
}

+ (instancetype)build:(NSString *)factoryName {
    return [self build:factoryName params:@{}];
}

+ (instancetype)buildWithParams:(NSDictionary *)params {
    return [self build:NSStringFromClass(self) params:params];
}

+ (instancetype)build:(NSString *)factoryName params:(NSDictionary *)params {
    LSFactory *factory = self.factories[factoryName];
    if (!factory) {
        [NSException raise:NSInvalidArgumentException format:@"No factory defined for class %@", NSStringFromClass(self)];
    }

    NSObject *object = [[self alloc] init];
    NSMutableDictionary *properties = [factory.properties mutableCopy];
    [properties addEntriesFromDictionary:params];
    for (NSString *key in properties) {
        [object setValue:properties[key] forKey:key];
    }
    return object;
}

@end
