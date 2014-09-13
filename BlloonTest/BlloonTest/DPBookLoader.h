//
//  DPBookLoader.h
//  BlloonTest
//
//  Created by Dmitry Povolotsky on 9/12/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPBookLoader : NSObject

+ (DPBookLoader*) sharedInstance;

- (void)booksForCategoryOnlineId:(NSString*) onlineId
                            page:(NSUInteger) page
               complitionHandler:(void (^)(NSArray* items, NSUInteger page)) handler;

@end
