//
//  BLCartItem.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/11/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLCartItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *variant_id;
@property (nonatomic, strong) NSURL *image;
@property int quantity;
@property int inventory;
@property double unit_price;


// Transforms an NSArray of JSON into an NSArray of BLCartItem objects
+ (NSMutableArray *)arrayWithJSON:(NSArray *)JSON;
// Intialize cart item with JSON dictionary
- (instancetype)initWithJSON:(NSDictionary *)JSON;
// Returns the JSON dictionary of the object
- (NSDictionary *)JSONDictionary;
// Returns total price (unit_price * quantity)
- (double) totalPrice;

@end
