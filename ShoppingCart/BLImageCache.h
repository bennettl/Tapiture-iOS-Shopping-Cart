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

- (UIImage *)imageWithIdentifier;

@end
