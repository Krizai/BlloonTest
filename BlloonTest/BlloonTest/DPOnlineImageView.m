//
//  DPOnlineImageView.m
//
//  Created by Dmitry Povolotsky on 3/6/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import "DPOnlineImageView.h"
#import "DPImageLoader.h"

@interface DPOnlineImageView ()


@end

@implementation DPOnlineImageView



- (void) setUrlString:(NSString *)urlString{
    if(urlString == _urlString) return;
    _urlString = urlString;
    
    self.image = nil;
    [[DPImageLoader sharedInstance] loadImageWithURL:urlString complitionHandler:^(UIImage *result, NSString *url) {
        if ([url isEqualToString:self.urlString]) {
            self.image = result;
        }
    }];
}

@end
