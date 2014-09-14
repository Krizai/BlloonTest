//
//  BlloonTestTests.m
//  BlloonTestTests
//
//  Created by Dmitry Povolotsky on 9/12/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DPBook.h"

@interface BlloonTestTests : XCTestCase

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation BlloonTestTests

- (void)setUp
{
    [super setUp];

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"blloon" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //store
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"test.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    
    //object context
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBookCreation
{
    DPBook* book = [DPBook bookFromJSONDictionary:nil inContext:self.managedObjectContext];
    XCTAssert(book != nil, @"Book creation failed (nil dictionary )");
    XCTAssert(book.title == nil, @"Book creation failed (nil dictionary )");
    XCTAssert(book.author == nil, @"Book creation failed (nil dictionary )");
    XCTAssert(book.thumbnailUrl == nil, @"Book creation failed (nil dictionary)");
    
    book = [DPBook bookFromJSONDictionary:[NSDictionary dictionary] inContext:self.managedObjectContext];
    XCTAssert(book != nil, @"Book creation failed (empty dictionary )");
    XCTAssert(book.title == nil, @"Book creation failed (empty dictionary )");
    XCTAssert(book.author == nil, @"Book creation failed (empty dictionary )");
    XCTAssert(book.thumbnailUrl == nil, @"Book creation failed (empty dictionary)");
    
    NSDictionary* dictionary = @{@"title": @"test1",
                                 @"author": @"test2",
                                 @"payout": @"test3"};
    book = [DPBook bookFromJSONDictionary:dictionary inContext:self.managedObjectContext];
    XCTAssert(book != nil, @"Book creation failed (title and author)");
    XCTAssert([book.title isEqualToString:@"test1"], @"Book creation failed (title and author)");
    XCTAssert([book.author isEqualToString:@"test2"], @"Book creation failed (title and author)");
    XCTAssert(book.thumbnailUrl == nil, @"Book creation failed (title and author)");
    
    dictionary = @{@"title": @"test1",
                   @"author": @"test2",
                   @"small_cover_image_url": @"test3"};
    book = [DPBook bookFromJSONDictionary:dictionary inContext:self.managedObjectContext];
    XCTAssert(book != nil, @"Book creation failed (title and author and thumbnailUrl)");
    XCTAssert([book.title isEqualToString:@"test1"], @"Book creation failed (title and author and thumbnailUrl)");
    XCTAssert([book.author isEqualToString:@"test2"], @"Book creation failed (title and author and thumbnailUrl)");
    XCTAssert([book.thumbnailUrl isEqualToString:@"test3"], @"Book creation failed (title and author and thumbnailUrl)");
    
}
    
    - (NSURL *)applicationDocumentsDirectory
    {
        return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }

@end
