//
//  BLImageCache.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/23/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLImageCache.h"

@interface BLImageCache()
    @property (nonatomic, strong) NSMutableDictionary *imageDict; //key-image name 
@end

@implementation BLImageCache

// Singleton
+ (instancetype) sharedCache{
    
    static BLImageCache *_sharedCache;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[BLImageCache alloc] init];
    });
    
    return _sharedCache;
    
}

// Initalizer
- (id)init{
    self = [super init];
    if (self) {
        _imageDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// Returns document directory with images path
+ (NSString *) path{
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory    = [paths objectAtIndex:0];
    NSString *full_path             = [documentsDirectory stringByAppendingPathComponent: @"images"];
    
    return full_path;
}

// Save images to disk
- (void)saveToDisk {
    for (NSString *imageName in self.imageDict) {
        NSString *imagePath = [[BLImageCache path] stringByAppendingPathComponent:imageName];
        UIImage *image = [self.imageDict objectForKey:imageName];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
        [imageData writeToFile:imagePath atomically:YES];
        
    }
}

@end
