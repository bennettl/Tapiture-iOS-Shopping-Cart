//
//  BLCart.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/14/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLCart.h"
#import "BLCartItem.h"
#import "BLSampleData.h"

@interface BLCart ()<NSCoding>

@end

@implementation BLCart

#pragma mark Initialization

// Singleton
+ (instancetype) sharedCart{
    static BLCart *_sharedCart = nil;
    
    // Code to be executed oly once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCart = [[BLCart alloc] init];
    });
    
    return _sharedCart;
}

// Initialize cart
- (id)init{
    NSString *path = [BLCart path];
    // If cart file path exists, load that instead
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSLog(@"Initialized saved cart %s", __PRETTY_FUNCTION__);
        self = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    } else{
        NSLog(@"initialize empty cart with JSON Data %s", __PRETTY_FUNCTION__);
        self = [super init];
        self.items = [BLSampleData cartItemsData];
        
        [self saveToDisk];
    }
    return self;
}

#pragma mark Getters

// Returns the total amount for the cart
- (double)totalAmount{
    double totalAmount = 0.0;
    
    // Add total price of each cart item to the total amount
    for (BLCartItem *cartItem in self.items) {
        totalAmount += [cartItem totalPrice];
    }
    
    return totalAmount;
}

// Returns the total number of items
- (int)totalItems{
    int totalItems = 0;
    for (BLCartItem *item in self.items) {
        totalItems += item.quantity;
    }
    return totalItems;
}

// Returns the URL for checkout with checkout items appended as parameters
// Example URL: http://shop.tapiture.com/cart/variant_id1:quantity1,variant_id2:quantity2
- (NSURL *)checkoutURL{
    
    NSString *baseString            = @"http://shop.tapiture.com/cart/";
    
    NSMutableArray *paramsArray     = [[NSMutableArray alloc] init];
    
    for (BLCartItem *item in self.items) {
        [paramsArray addObject:[NSString stringWithFormat:@"%li:%i", item.variantId, item.quantity]];
    }
    
    NSString *paramsString          = [paramsArray componentsJoinedByString:@","];
    NSString *fullpath              = [NSString stringWithFormat:@"%@%@", baseString, paramsString];
    
    return [NSURL URLWithString:fullpath];
}

#pragma mark Modifying Cart

// Add item to cart
- (void)addItem:(BLCartItem *)item{
    // If the item exist, simply increment the count by one and return
    for (BLCartItem *cartItem in self.items) {
        if (item.variantId == cartItem.variantId){
            // Only increment quantity if it's less than inventory
            if (cartItem.quantity < cartItem.inventory){
                cartItem.quantity += 1;
            }
            return;
        }
    }
    [self.items addObject:item];
    [self saveToDisk];
}

// Update item at index with quantity
- (void)updateItemAtIndex:(NSInteger)index withQuantity:(NSInteger)quantity{
    BLCartItem *cartItem = [self.items objectAtIndex:index];
    cartItem.quantity = quantity;
}

#pragma mark Persistance

// Save cart to disk
- (void)saveToDisk{
    NSString * path = [BLCart path];
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}


#pragma mark - NSCoding

// Decode array of BLCartItems
- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]){
        _items = [decoder decodeObjectForKey:@"items"];
    }
    return self;
}

// Encode array of BLCartItems
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.items forKey:@"items"];
}

# pragma mark - Helper

// Returns document directory with cart.plist filename
+ (NSString *) path{
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory    = [paths objectAtIndex:0];
    NSString *full_path             = [documentsDirectory stringByAppendingPathComponent: @"cart.plist"];
    
    return full_path;
}



@end
