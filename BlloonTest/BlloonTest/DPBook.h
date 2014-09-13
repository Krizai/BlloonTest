//
//  DPBook.h
//  BlloonTest
//
//  Created by Dmitry Povolotsky on 9/13/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DPCategory;

@interface DPBook : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) DPCategory *category;

+ (instancetype) bookFromJSONDictionary:(NSDictionary*) dictionary inContext:(NSManagedObjectContext*) context;

@end
