//
//  DPCategory.h
//  BlloonTest
//
//  Created by Dmitry Povolotsky on 9/13/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DPBook;

@interface DPCategory : NSManagedObject

@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * onlineId;
@property (nonatomic, retain) NSOrderedSet *books;

+ (instancetype) categoryWithOnlineId:(NSString*) onlineId inContext:(NSManagedObjectContext*) context;


@end

@interface DPCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(DPBook *)value inBooksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBooksAtIndex:(NSUInteger)idx;
- (void)insertBooks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBooksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBooksAtIndex:(NSUInteger)idx withObject:(DPBook *)value;
- (void)replaceBooksAtIndexes:(NSIndexSet *)indexes withBooks:(NSArray *)values;
- (void)addBooksObject:(DPBook *)value;
- (void)removeBooksObject:(DPBook *)value;
- (void)addBooks:(NSOrderedSet *)values;
- (void)removeBooks:(NSOrderedSet *)values;
@end
