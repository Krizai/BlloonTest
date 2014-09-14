//
//  DPBookViewCell.h
//  BlloonTest
//
//  Created by Dmitry Povolotsky on 9/12/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DPBook;
@interface DPBookViewCell : UICollectionViewCell

- (void) setupWithBook:(DPBook*) book;

@end
