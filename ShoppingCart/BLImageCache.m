//
//  BLImageCache.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/23/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLImageCache.h"

@interface BLImageCache() <NSCoding>

@end

@implementation BLImageCache

#pragma mark Initialization

+ (instancetype) sharedCache{
    
    static BLImageCache *_sharedCache;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[BLImageCache alloc] init];
    });
    
    return _sharedCache;
    
}


# pragma mark Image Handling functions
- (void)saveImage:(NSData *)image withProductID:(long)productID{
    // Save the file
//    NSData *imagePNG    = UIImageJPEGRepresentation(image, 0.8f);
    
    // Get the image path with productIDStr appended to it
    NSString *productIDStr  = [NSString stringWithFormat:@"%li.jpg", productID];
    NSString *imageFilePath = [[BLImageCache imagesDirectory] stringByAppendingPathComponent:productIDStr]; //Add the file name
        
    [image writeToFile:imageFilePath atomically:YES]; //Write the file
}

// Whether or not product exists at path
- (BOOL)imageExistForProductWithID:(long)productID{
    NSString *productIdStr  = [NSString stringWithFormat:@"%li.jpg", productID];
    NSString *productPath   = [[BLImageCache imagesDirectory] stringByAppendingPathComponent:productIdStr];
    return [[NSFileManager defaultManager] fileExistsAtPath:productPath isDirectory:NO];
}

// Returns UIImage for product with ID from the images directory
- (UIImage *)imageForProductWithID:(long)productID{
    NSString *productIdStr  = [NSString stringWithFormat:@"%li.jpg", productID];
    NSString *productPath   = [[BLImageCache imagesDirectory] stringByAppendingPathComponent:productIdStr];
    NSData *imageData       = [NSData dataWithContentsOfFile:productPath];
    return [UIImage imageWithData:imageData];
}



#pragma mark - NSCoding


# pragma mark - Path functions

// Returns document directory with cart.plist filename
+ (NSString *) imageCachePath{
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory    = [paths objectAtIndex:0];
    NSString *full_path             = [documentsDirectory stringByAppendingPathComponent: @"imageCache.plist"];
    
    return full_path;
}

// Returns document directory with images path
+ (NSString *) imagesDirectory{
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory    = [paths objectAtIndex:0];
    NSString *imagesDirectory             = [documentsDirectory stringByAppendingPathComponent: @"images/"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }

    return imagesDirectory;
}



@end
