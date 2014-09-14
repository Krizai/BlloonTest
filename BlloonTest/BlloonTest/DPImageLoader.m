//
//  DPImageLoader.m
//
//  Created by Dmitry Povolotsky on 3/6/14.
//  Copyright (c) 2014 Dmitry Povolotsky. All rights reserved.
//

#import "DPImageLoader.h"

@interface DPImageLoader ()

@property ( nonatomic, retain) NSMutableDictionary* memoryCache;
@end

@implementation DPImageLoader

- (id)init
{
    self = [super init];
    if (self) {
        _memoryCache = [NSMutableDictionary new];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (DPImageLoader*) sharedInstance{
    static DPImageLoader *sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DPImageLoader new];
    });
    return sharedInstance;
}

- (void) loadImageWithURL:(NSString*) urlString complitionHandler:(void(^)(UIImage* result, NSString* url))complitionHandler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage* resultImage = self.memoryCache[urlString];
        if (resultImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complitionHandler(resultImage, urlString);
            });
            return;
        }
        
        resultImage = [self loadFromDiscCacheImageWithUrl:urlString];
        if (resultImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complitionHandler(resultImage, urlString);
            });
            return;
        }
        
        resultImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        self.memoryCache[urlString] = resultImage;
        [self saveToDiscCacheImage:resultImage withUrl:urlString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complitionHandler(resultImage, urlString);
        });
    });

}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [self.memoryCache removeAllObjects];
}

#pragma mark Caching

- (void) saveToDiscCacheImage:(UIImage*) image withUrl:(NSString*) urlString{
    NSString* cachePath = [self cachePathForImageWithUrlString:urlString];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:cachePath atomically:YES];
}

- (UIImage*) loadFromDiscCacheImageWithUrl:(NSString*) urlString{
    NSString* cachePath = [self cachePathForImageWithUrlString:urlString];
    UIImage* image = [UIImage imageWithContentsOfFile:cachePath];
    return image;
}
   
- (NSString*) cachePathForImageWithUrlString:(NSString*) urlString{

    NSString* filteredUrl = [self filterPathForFilename:urlString];
    NSString *cachesPath = NSTemporaryDirectory();
    NSString *imageCachesPath = [cachesPath stringByAppendingPathComponent:@"images"];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageCachesPath withIntermediateDirectories:YES attributes:nil error:nil];
	NSString *path  = [imageCachesPath stringByAppendingPathComponent:filteredUrl];
	
    return path;
}


-(NSString *) filterPathForFilename:(NSString*) path{
	int length = [path length];
	if (!length) return nil;
	
	NSCharacterSet* checkSet= [NSCharacterSet characterSetWithCharactersInString:
                               @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRTUVWXYZ1234567890._-"];
	
	unichar *buffer = calloc(length, sizeof (unichar));
	
	[path getCharacters:buffer range:NSMakeRange(0, length)];
	
	int newLength = 0;
	
	for(int i = 0; i < length; i++){
		if([checkSet characterIsMember:buffer[i]]){
			buffer[newLength] = buffer[i];
			newLength++;
		}
	}
	
	NSString *result = [NSString stringWithCharacters:buffer length:newLength];
	free(buffer);
    NSRange extRange = [result rangeOfString:@"." options:NSBackwardsSearch];
    if(extRange.location == NSNotFound || extRange.location < [result length] -4){
        result = [NSString stringWithFormat:@"%@.png",result];
    }
    
	return result;
}



@end
