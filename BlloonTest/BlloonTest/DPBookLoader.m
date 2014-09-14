//
//  DPBookLoader.m
//  BlloonTest
//
//  Created by Dmitry Povolotsky on 9/12/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import "DPBookLoader.h"
#import "DPBook.h"
#import "DPCategory.h"
#import <CoreData/CoreData.h>

static const NSInteger pageItemsCount = 20;
static const NSInteger cacheLiveTime = 60*60*24;

@interface DPBookLoader ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DPBookLoader

+ (DPBookLoader*) sharedInstance{
    static DPBookLoader *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DPBookLoader new];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        //create oblject model
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"blloon" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        //store
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"blloon.sqlite"];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
        
        //object context
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
        
        
    }
    return self;
}

#pragma mark Public 

- (void)booksForCategoryOnlineId:(NSString*) onlineId
                            page:(NSUInteger) page
               complitionHandler:(void (^)(NSArray* items, NSUInteger page, BOOL success)) handler{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DPCategory* category = [self cachedCategoryByOnlineId:onlineId];
        if(!category){
            category = [self createCategoryCacheForOnlineId:onlineId];
        }
        if(page == 1){ //check for reset only on initial loading
            [self resetCategoryCacheIfNeeded:category];
        }
        
        NSArray* books = [self cachedBooksForCategory:category page:page];
        if(books.count == 0){
            BOOL success = [self loadBooksForCategory:category page:page];
            if(!success){
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, page, NO);
                });
                return;
            }
            books = [self cachedBooksForCategory:category page:page];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(books, page, YES);
        });
        
    });
    
}

#pragma mark Cache

- (NSArray*) cachedBooksForCategory:(DPCategory*) category
                               page:(NSUInteger) page{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"category = %@", category]];
    [fetchRequest setFetchLimit:pageItemsCount];
    [fetchRequest setFetchOffset:pageItemsCount*(page-1)];
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (DPCategory*) cachedCategoryByOnlineId:(NSString*)onlineId{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Category"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"onlineId = %@", onlineId]];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if(fetchedObjects.count == 0){
        return nil;
    }
    return fetchedObjects[0];
}

- (DPCategory*)createCategoryCacheForOnlineId:(NSString*) onlineId{
    
    DPCategory* category = [DPCategory categoryWithOnlineId:onlineId inContext:self.managedObjectContext];
    [self.managedObjectContext save:nil];
    return category;
    
}



- (void)resetCategoryCacheIfNeeded:(DPCategory*) category{
    if(!category || [category.lastUpdate timeIntervalSinceNow] < cacheLiveTime){
        return;
    }
    [category removeBooks:category.books];
    [self.managedObjectContext save:nil];
}

- (BOOL)loadBooksForCategory:(DPCategory*) category
                        page:(NSUInteger) page{
    NSURL* url = [self booksUrlForCategoryId:category.onlineId page:page];
    NSData* data = [NSData dataWithContentsOfURL:url];
    if(!data){
        return NO;
    }
    
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self parseBooksFromJSONArray:jsonArray toCategory:category];

    if(page == 1){
        category.lastUpdate = [NSDate date];
    }

    [self.managedObjectContext save:nil];
    return YES;
}


- (void)parseBooksFromJSONArray:(NSArray*) jsonArray toCategory:(DPCategory*) category {
    for(NSDictionary* jsonDictionary in jsonArray){
        DPBook* book = [DPBook bookFromJSONDictionary:jsonDictionary inContext:self.managedObjectContext];
        [category addBooksObject:book];
    }
}

#pragma mark Utility methods

- (NSURL*) booksUrlForCategoryId:(NSString*) categoryId page:(NSUInteger) page{
    NSDictionary* arguments = @{@"page": [NSString stringWithFormat:@"%d",page],
                                @"per_page":  [NSString stringWithFormat:@"%d",pageItemsCount],
                                };

    NSString* booksPath = [NSString stringWithFormat:@"http://turbine-production-eu.herokuapp.com:80/categories/%@/books", categoryId];
    NSString* urlString = [self urlStringWithPath:booksPath arguments:arguments];
    return [NSURL URLWithString:urlString];
}

- (NSString*) urlStringWithPath:(NSString*) path arguments:(NSDictionary*) arguments{
    NSMutableString* urlString = [NSMutableString stringWithString:path];
    [urlString appendString:@"?"];
    __block BOOL isFirst = YES;
    [arguments enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL *stop) {
        if(key.length == 0 || obj.length == 0) return;
        NSString* encodedValue = [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if(!isFirst){
            [urlString appendString:@"&"];
        }
        isFirst = NO;
        [urlString appendFormat:@"%@=%@", key, encodedValue];
    }];
    return urlString;
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
