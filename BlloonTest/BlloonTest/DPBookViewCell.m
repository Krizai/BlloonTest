//
//  DPBookViewCell.m
//  BlloonTest
//
//  Created by Dmitry Povolotsky on 9/12/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import "DPBookViewCell.h"
#import "DPBook.h"

@interface DPBookViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation DPBookViewCell

- (void) setupWithBook:(DPBook*) book{
    self.titleLabel.text = book.title;
    self.authorLabel.text = book.author;
    
}

@end
