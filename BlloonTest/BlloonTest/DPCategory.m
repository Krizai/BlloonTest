//
//  DPCategory.m
//  BlloonTest
//
//  Created by Dmitry Povolotsky on 9/13/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import "DPCategory.h"
#import "DPBook.h"


@implementation DPCategory

@dynamic lastUpdate;
@dynamic onlineId;
@dynamic books;


+ (instancetype) categoryWithOnlineId:(NSString*) onlineId inContext:(NSManagedObjectContext*) context{
    DPCategory *resultCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                       inManagedObjectContext:context];
    resultCategory.onlineId = onlineId;
    
    return resultCategory;
}

//workaround of strange issue (http://stackoverflow.com/questions/7385439/exception-thrown-in-nsorderedset-generated-accessors)
- (void)addBooksObject:(DPBook *)book{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.books];
    [tempSet addObject:book];
    self.books = tempSet;
}
@end
