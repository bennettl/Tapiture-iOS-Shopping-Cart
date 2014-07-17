//
//  BLCart.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/14/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLCart.h"
#import "BLCartItem.h"

@interface BLCart ()<NSCoding>

@end

@implementation BLCart

// Initialize cart
- (id)init{
    NSString *path = [BLCart path];
    // If cart file path exists, load that instead
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSLog(@"initialize saved cart");
        self = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    } else{
        NSLog(@"initialize empty cart with JSON Data");
        self = [super init];
        
        NSArray *items =  @[@{
                                 @"product_id": @"237248753",
                                 @"variant_id": @"538764521",
                                 @"quantity": [NSNumber numberWithInt:2],
                                 @"inventory": [NSNumber numberWithInt:10],
                                 @"title": @"Abide Print and T-Shirt - L / Navy",
                                 @"unit_price": @"57.99",
                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/41/c7/a1/ac/4a73aaf556590dd44fefb6.jpg"
                             },
                            @{
                                 @"product_id": @"167919316",
                                 @"variant_id": @"386227396",
                                 @"quantity": [NSNumber numberWithInt:3],
                                 @"inventory": [NSNumber numberWithInt:12],
                                 @"title": @"Gift Card - $25.00",
                                 @"unit_price": @"25.00",
                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/25/3d/8f/d4/eec06a15106a2441ba92565d.png"
                             },
                             @{
                                 @"product_id": @"334016697",
                                 @"variant_id": @"809468877",
                                 @"quantity": [NSNumber numberWithInt:5],
                                 @"inventory": [NSNumber numberWithInt:50],
                                 @"title": @"Gold Anchor' Canvas Art - 24x36 | MULTI",
                                 @"unit_price": @"230.00",
                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/cd/c8/18/8c/978a5bcbb377f9bd5b79dd6.jpg"
                             },
                             @{
                                 @"product_id": @"196400877",
                                 @"variant_id": @"448214221",
                                 @"quantity": [NSNumber numberWithInt:1],
                                 @"inventory": [NSNumber numberWithInt:16],
                                 @"title": @"Ivy Bracelet in Brown - 7 | Brown",
                                 @"unit_price": @"25.00",
                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/17/20/59/6b/ae4dcab4d4faac7deb874f21.jpg"
                             }
//                             @{
//                                 @"product_id": @"334016665",
//                                 @"variant_id": @"809468789",
//                                 @"quantity": [NSNumber numberWithInt:1],
//                                 @"inventory": [NSNumber numberWithInt:50],
//                                 @"title": @"America the Beautiful' Canvas Art - 16x24 | MULTI",
//                                 @"unit_price": @"230.00",
//                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/32/39/92/17/271466f69a86d6d52987f9b3.jpg"
//                             },
//                             @{
//                                 @"product_id": @"334016601",
//                                 @"variant_id": @"809468497",
//                                 @"quantity": [NSNumber numberWithInt:1],
//                                 @"inventory": [NSNumber numberWithInt:50],
//                                 @"title": @"American Surfing Beauties' Canvas Art - 36x24 | MULTI",
//                                 @"unit_price": @"230.00",
//                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/fe/16/47/52/4e5fe6334d2fcc52b9e8bf2.jpg"
//                             },
//                             @{
//                                 @"product_id": @"334016637",
//                                 @"variant_id": @"809468633",
//                                 @"quantity": [NSNumber numberWithInt:1],
//                                 @"inventory": [NSNumber numberWithInt:50],
//                                 @"title": @"Cozy Hamburgers' Canvas Art - 16x16 | MULTI",
//                                 @"unit_price": @"180.00",
//                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/5c/51/fd/70/b3cbad86bbe3356b2a7124d9.jpg"
//                             }
                           ];

        self.items = [BLCartItem arrayWithJSON:items];
        
        [self saveToDisk];
    }
    return self;
}

// Add item to cart
- (void)addItem:(BLCartItem *)item{
    [self.items addObject:item];
}

// Update item at index with quantity
- (void)updateItemAtIndex:(NSInteger)index withQuantity:(NSInteger)quantity{
    BLCartItem *cartItem = [self.items objectAtIndex:index];
    cartItem.quantity = quantity;

}

// Returns the total amount for the cart
- (double)totalAmount{
    double totalAmount = 0.0;
    
    // Add total price of each cart item to the total amount
    for (BLCartItem *cartItem in self.items) {
        totalAmount += [cartItem totalPrice];
    }
    
    return totalAmount;
}

// Returns the URL for checkout with checkout items appended as parameters
// Example URL: http://shop.tapiture.com/cart/variant_id1:quantity1,variant_id2:quantity2
- (NSURL *)checkoutURL{
    
    NSString *baseString            = @"http://shop.tapiture.com/cart/";
   
    NSMutableArray *paramsArray     = [[NSMutableArray alloc] init];
    
    for (BLCartItem *item in self.items) {
        [paramsArray addObject:[NSString stringWithFormat:@"%@:%i", item.variant_id, item.quantity]];
    }
    
    NSString *paramsString          = [paramsArray componentsJoinedByString:@","];
    NSString *fullpath              = [NSString stringWithFormat:@"%@%@", baseString, paramsString];
    
    return [NSURL URLWithString:fullpath];
}

// Save cart to disk
- (void)saveToDisk{
    NSString * path = [BLCart path];
    [NSKeyedArchiver archiveRootObject:self toFile:path];
    //    NSLog(@"saving to disk %@", path);
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]){
        _items = [decoder decodeObjectForKey:@"items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.items forKey:@"items"];
}

# pragma mark - NSKeyArchiver


// Returns document directory with cart.plist filename
+ (NSString *) path{
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory    = [paths objectAtIndex:0];
    NSString *full_path             = [documentsDirectory stringByAppendingPathComponent: @"cart.plist"];
    
    return full_path;
}



@end
