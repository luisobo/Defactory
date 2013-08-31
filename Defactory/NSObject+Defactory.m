//
//  NSObject+Defactory.m
//  Defactory
//
//  Created by Luis Solano Bonet on 30/08/13.
//  Copyright (c) 2013 Luis Solano Bonet. All rights reserved.
//

#import "NSObject+Defactory.h"
#import <objc/runtime.h>
#import "LSSequence.h"

id association(Class class) {
    return [[class performSelector:@selector(factories)] objectForKey:[class description]];
}

@interface LSFactory ()
@property (nonatomic, strong) Class klass;
@property (nonatomic, strong) NSMutableDictionary *properties;

@end

@implementation LSFactory

- (instancetype)initWithClass:(Class)klass {
    self = [super init];
    if (self) {
        _klass = klass;
        _properties = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    self.properties[key] = object;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    LSFactory *copy = [[LSFactory alloc] initWithClass:[self klass]];
    copy.properties = [self.properties mutableCopy];
    return copy;
}

- (id)build {
    return [self buildWithParams:nil];
}

- (id)buildWithParams:(NSDictionary *)params {
    params = params ?: @{};
    NSObject *object = [[self.klass alloc] init];
    NSMutableDictionary *properties = [self.properties mutableCopy];
    [properties addEntriesFromDictionary:params];
    for (NSString *key in properties) {
        id value = properties[key];
        if ([value isKindOfClass:[LSSequence class]]) {
            value = [value next];
        }
        if ([value isKindOfClass:[LSFactory class]]) {
            value = [value build];
        }
        [object setValue:value forKey:key];
    }
    return object;
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
    [self define:name parent:nil factory:definition];
}
+ (void)define:(NSString *)name parent:(NSString *)parent factory:(void(^)(LSFactory *factory))definition {
    if (self.factories[name]) {
        [NSException raise:NSInvalidArgumentException format:@"Redefinition of factory '%@' for class '%@'", name, NSStringFromClass(self)];
    }
    LSFactory *factory = parent ? [self.factories[parent] mutableCopy] : [[LSFactory alloc] initWithClass:self];
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
        [NSException raise:NSInvalidArgumentException format:@"No factory '%@' defined for class %@", factoryName, NSStringFromClass(self)];
    }

    return [factory buildWithParams:params];
}

@end
