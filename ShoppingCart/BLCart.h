//
//  BLCart.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/14/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BLCartItem.h"

@interface BLCart : NSObject

@property (nonatomic, strong) NSMutableArray *items;

// Singleton
+ (instancetype) sharedCart;

// Intialize cart wtih an array of JSON
//- (instancetype)initWithJSON:(NSArray *)JSON;
//Add item to cart
- (void)addItem:(BLCartItem *)item;
// Update item at index with quantity
- (void)updateItemAtIndex:(NSInteger)index withQuantity:(NSInteger)quantity;
// Returns the total amount for the cart
- (double)totalAmount;
// Returns the total number of items
- (int)totalItems;
// Returns the URL for checkout with checkout items appended as parameters
- (NSURL *)checkoutURL;
// Save cart to disk
- (void)saveToDisk;

@end
