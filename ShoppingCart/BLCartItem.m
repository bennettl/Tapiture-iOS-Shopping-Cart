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

@implementation BLCartItem

// Initialization
- (instancetype)initWithJSON:(NSDictionary *)JSON{

    if (self = [super init]){
        _title          = JSON[@"title"];
        _product_id     = JSON[@"product_id"];
        _variant_id     = JSON[@"variant_id"];
        _image          = [NSURL URLWithString:JSON[@"image"]];
        _quantity       = [JSON[@"quantity"] intValue];
        _inventory      = [JSON[@"inventory"] intValue];
        _unit_price     = [JSON[@"unit_price"] doubleValue];
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

// Getter
- (double)totalPrice{
    return _unit_price * _quantity;
}

// Returns the JSON dictionary of the object
- (NSDictionary *)JSONDictionary{
    NSMutableDictionary *JSONDictionary = [[NSMutableDictionary alloc] init];
    
    [JSONDictionary setObject:self.title forKey:@"title"];
    [JSONDictionary setObject:self.product_id forKey:@"product_id"];
    [JSONDictionary setObject:self.variant_id forKey:@"variant_id"];
    [JSONDictionary setObject:self.image forKey:@"image"];
    [JSONDictionary setObject:[NSNumber numberWithInt:self.quantity] forKey:@"quantity"];
    [JSONDictionary setObject:[NSNumber numberWithInt:self.inventory] forKey:@"inventory"];
    [JSONDictionary setObject:[NSNumber numberWithDouble:self.unit_price] forKey:@"unit_price"];
    
    return [JSONDictionary copy];
}

#pragma mark - NSCoding protocol

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        _title      = [decoder decodeObjectForKey:@"title"];
        _product_id = [decoder decodeObjectForKey:@"product_id"];
        _variant_id = [decoder decodeObjectForKey:@"variant_id"];
        _image      = [decoder decodeObjectForKey:@"image"];
        _quantity   = [[decoder decodeObjectForKey:@"quantity"] intValue];
        _inventory  = [[decoder decodeObjectForKey:@"inventory"] intValue];
        _unit_price = [[decoder decodeObjectForKey:@"unit_price"] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.product_id forKey:@"product_id"];
    [encoder encodeObject:self.variant_id forKey:@"variant_id"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:[NSNumber numberWithInt:self.quantity] forKey:@"quantity"];
    [encoder encodeObject:[NSNumber numberWithInt:self.inventory] forKey:@"inventory"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.unit_price] forKey:@"unit_price"];
}

@end
