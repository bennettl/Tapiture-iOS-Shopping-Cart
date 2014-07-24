//
//  BLProductSampleData.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/22/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLSampleData : NSObject

// Return an array of BLProducts shared by application
+ (NSMutableArray *)productsData;
// Return an array of BLCartItems shared by application
+ (NSMutableArray *)cartItemsData;

@end
