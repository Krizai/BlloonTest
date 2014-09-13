//
//  DPBook.m
//  BlloonTest
//
//  Created by Dmitry Povolotsky on 9/13/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import "DPBook.h"
#import "DPCategory.h"
#import "NSDictionary+ClassGetter.h"

@implementation DPBook

@dynamic title;
@dynamic author;
@dynamic thumbnailUrl;
@dynamic category;



+ (instancetype) bookFromJSONDictionary:(NSDictionary*) dictionary inContext:(NSManagedObjectContext*) context{
    DPBook *resultBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book"
                                                      inManagedObjectContext:context];
    resultBook.title = [dictionary valueForKey:@"title" withClass:[NSString class]];
    resultBook.author = [dictionary valueForKey:@"author" withClass:[NSString class]];
    resultBook.thumbnailUrl = [dictionary valueForKey:@"small_cover_image_url" withClass:[NSString class]];
    
    return resultBook;
}

@end
