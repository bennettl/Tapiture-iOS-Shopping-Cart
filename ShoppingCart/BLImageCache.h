//
//  BLImageCache.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/23/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLImageCache : NSObject

// Singleton
+ (instancetype) sharedCache;

// Whether or not product exists at path
- (BOOL)imageExistForProductWithID:(long)productID;
// Returns UIImage for product with ID
- (UIImage *)imageForProductWithID:(long)productID;
// Return the directory where images are stored
+ (NSString *)imagesDirectory;
// Save image with product ID
- (void)saveImage:(NSData *)image withProductID:(long)productID;

@end
