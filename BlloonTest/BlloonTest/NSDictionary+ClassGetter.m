//
//  NSDictionary+ClassGetter.m
//
//  Created by Dmitry Povolotsky on 3/14/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import "NSDictionary+ClassGetter.h"

@implementation NSDictionary (ClassGetter)

- (id) valueForKey:(NSString *)key withClass:(Class) class{
    NSObject* value = self[key];
    if([value isKindOfClass:class]){
        return value;
    }
    return nil;
}
@end
