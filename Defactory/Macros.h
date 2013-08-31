//
//  Macros.h
//  Defactory
//
//  Created by Luis Solano Bonet on 30/08/13.
//  Copyright (c) 2013 Luis Solano Bonet. All rights reserved.
//

#define _MERGE(a,b)  a##b
#define _LABEL(a) _MERGE(LSFactoryDefinition, a)
#define _UNIQUE_NAME _LABEL(__COUNTER__)

#define FACTORIES(definitions)\
__attribute__((constructor))\
static void _UNIQUE_NAME() {\
definitions();\
}
