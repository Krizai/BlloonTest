//
//  DPViewController.m
//  BlloonTest
//
//  Created by Dmitry Povolotsky on 9/12/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import "DPViewController.h"
#import "DPBookLoader.h"
#import "DPBook.h"
#import "DPBookViewCell.h"

static const NSString* categoryId = @"Wma8RpqpC6UcWye2U8qUg-6a21w";

@interface DPViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray* books;
@property (assign, nonatomic) NSUInteger lastPageLoaded;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation DPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark Data Loading
- (void)loadPage:(NSUInteger) page{
    [[DPBookLoader sharedInstance] booksForCategoryOnlineId:categoryId
                                                       page:self.lastPageLoaded + 1
                                          complitionHandler:^(NSArray *books, NSUInteger page) {
                                              self.lastPageLoaded = page;
                                              if(!self.books){
                                                  self.books = [NSMutableArray new];
                                              }
                                              [self.books addObjectsFromArray:books];
                                              [self.collectionView reloadData];
                                          }];
}


#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.books.count){
        static NSString *cellIdentifier = @"BookCell";
        DPBookViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        DPBook* book = self.books[indexPath.row];
        [cell setupWithBook:book];
        return cell;
    }else{
        return nil;
        
    }
}


@end
