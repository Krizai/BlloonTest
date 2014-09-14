//
//  DPImageLoader.h
//
//  Created by Dmitry Povolotsky on 3/6/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPImageLoader : NSObject

+ (DPImageLoader*) sharedInstance;

- (void) loadImageWithURL:(NSString*) urlString complitionHandler:(void(^)(UIImage* result, NSString* url))complitionHandler;
@end
