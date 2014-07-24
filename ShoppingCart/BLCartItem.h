//
//  BLCartItem.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/11/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLProduct.h"
#import "BLVariant.h"

@interface BLCartItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property int quantity;
@property int inventory;
@property double unit_price;
@property long productId;
@property long variantId;

// Transforms an NSArray of JSON into an NSArray of BLCartItem objects
+ (NSMutableArray *)arrayWithJSON:(NSArray *)JSON;
// Initialize with BLProduct and BLVariant
- (instancetype)initWithProduct:(BLProduct *)product andVariant:(BLVariant *)variant;
// Intialize cart item with JSON dictionary
- (instancetype)initWithJSON:(NSDictionary *)JSON;
// Returns the JSON dictionary of the object
- (NSDictionary *)JSONDictionary;
// Returns total price (unit_price * quantity)
- (double) totalPrice;

@end
