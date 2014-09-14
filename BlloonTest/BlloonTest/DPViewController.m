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
@property (assign, nonatomic) BOOL additionalDataAvailable;
@property (assign, nonatomic) BOOL pageLoadingInProgress;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation DPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.additionalDataAvailable = YES;
    self.lastPageLoaded = 0;
    [self switchToLoadingState:YES];
    [self loadPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark Data Loading
- (void)switchToLoadingState:(BOOL) loadingState{
    self.progressIndicator.hidden = !loadingState;
    self.collectionView.hidden = loadingState;
}

- (void)loadPage:(NSUInteger) page{
    self.pageLoadingInProgress = YES;
    [[DPBookLoader sharedInstance] booksForCategoryOnlineId:categoryId
                                                       page:self.lastPageLoaded + 1
                                          complitionHandler:^(NSArray *books, NSUInteger page, BOOL success) {
                                              [self switchToLoadingState:NO];
                                              self.lastPageLoaded = page;
                                              if(success){
                                                  self.additionalDataAvailable = books.count > 0;
                                                  if(!self.books){
                                                      self.books = [NSMutableArray new];
                                                  }
                                                  [self.books addObjectsFromArray:books];
                                                  [self.collectionView reloadData];
                                              }
                                              self.pageLoadingInProgress = NO;
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


#pragma mark UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.pageLoadingInProgress || !self.additionalDataAvailable) return;

    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height - 100) {
        [self loadPage:self.lastPageLoaded+1];
    }
}


@end
