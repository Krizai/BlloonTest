//
//  NSDictionary+ClassGetter.h
//
//  Created by Dmitry Povolotsky on 3/14/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ClassGetter)
- (id) valueForKey:(NSString *)key withClass:(Class) class;

@end
