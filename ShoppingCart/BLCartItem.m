//
//  BLCartItem.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/11/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLCartItem.h"

@interface BLCartItem () <NSCoding>

@end

// Keys used to identifier properties in JSON
#define KEY_TITLE           @"title"
#define KEY_PRODUCT_ID      @"product_id"
#define KEY_VARIANT_ID      @"variant_id"
#define KEY_IMAGE           @"image"
#define KEY_QUANTITY        @"quantity"
#define KEY_INVENTORY       @"inventory"
#define KEY_UNIT_PRICE      @"unit_price"

@implementation BLCartItem

#pragma mark Initialization

- (instancetype)initWithJSON:(NSDictionary *)JSON{

    if (self = [super init]){
        _title          = JSON[KEY_TITLE];
        _productId      = [JSON[KEY_PRODUCT_ID] longValue];
        _variantId      = [JSON[KEY_VARIANT_ID] longValue];
        _image          = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:JSON[KEY_IMAGE]]]];
        _quantity       = [JSON[KEY_QUANTITY] intValue];
        _inventory      = [JSON[KEY_INVENTORY] intValue];
        _unit_price     = [JSON[KEY_UNIT_PRICE] doubleValue];
    }
    
    return self;
}

// Transforms an NSArray of JSON into an NSArray of BLCartItem objects
+ (NSMutableArray *) arrayWithJSON:(NSArray *)JSON{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *itemJSON in JSON) {
        BLCartItem *cartItem = [[BLCartItem alloc] initWithJSON:itemJSON];
        [items addObject:cartItem];
    }
    return items;
}

// Initialize with BLProduct
- (instancetype)initWithProduct:(BLProduct *)product andVariant:(BLVariant *)variant{
    if (self = [super init]){
        _title          = [NSString stringWithFormat:@"%@ | %@", product.title, [variant description]]; // combination of product title and options in variant
        _productId      = product.productId;
        _variantId      = variant.variantId;
        _image          = product.image;
        _quantity       = 1;
        _inventory      = variant.inventory;
        _unit_price     = [variant.price doubleValue];
    }
    return self;
}

#pragma mark Getter

- (double)totalPrice{
    return _unit_price * _quantity;
}

#pragma mark Instance Method

// Returns the JSON dictionary of the object
- (NSDictionary *)JSONDictionary{
    NSMutableDictionary *JSONDictionary = [[NSMutableDictionary alloc] init];
    
    [JSONDictionary setObject:self.title forKey:KEY_TITLE];
    [JSONDictionary setObject:[NSNumber numberWithLong:self.productId] forKey:KEY_PRODUCT_ID];
    [JSONDictionary setObject:[NSNumber numberWithLong:self.variantId] forKey:KEY_VARIANT_ID];
    [JSONDictionary setObject:self.image forKey:KEY_IMAGE];
    [JSONDictionary setObject:[NSNumber numberWithInt:self.quantity] forKey:KEY_QUANTITY];
    [JSONDictionary setObject:[NSNumber numberWithInt:self.inventory] forKey:KEY_INVENTORY];
    [JSONDictionary setObject:[NSNumber numberWithDouble:self.unit_price] forKey:KEY_UNIT_PRICE];
    
    return [JSONDictionary copy];
}

#pragma mark - NSCoding protocol

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        _title      = [decoder decodeObjectForKey:KEY_TITLE];
        _productId  = [[decoder decodeObjectForKey:KEY_PRODUCT_ID] longValue];
        _variantId  = [[decoder decodeObjectForKey:KEY_VARIANT_ID] longValue];
        _image      = [decoder decodeObjectForKey:KEY_IMAGE];
        _quantity   = [[decoder decodeObjectForKey:KEY_QUANTITY] intValue];
        _inventory  = [[decoder decodeObjectForKey:KEY_INVENTORY] intValue];
        _unit_price = [[decoder decodeObjectForKey:KEY_UNIT_PRICE] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.title forKey:KEY_TITLE];
    [encoder encodeObject:[NSNumber numberWithLong:self.productId]forKey:KEY_PRODUCT_ID];
    [encoder encodeObject:[NSNumber numberWithLong:self.variantId]forKey:KEY_VARIANT_ID];
    [encoder encodeObject:self.image forKey:KEY_IMAGE];
    [encoder encodeObject:[NSNumber numberWithInt:self.quantity] forKey:KEY_QUANTITY];
    [encoder encodeObject:[NSNumber numberWithInt:self.inventory] forKey:KEY_INVENTORY];
    [encoder encodeObject:[NSNumber numberWithDouble:self.unit_price] forKey:KEY_UNIT_PRICE];
}

@end
