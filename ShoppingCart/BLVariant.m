//
//  BLVariant.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/21/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLVariant.h"

// Keys used to identifier properties in JSON
#define KEY_PRODUCT_ID      @"product_id"
#define KEY_VARIANT_ID      @"variant_id"
#define KEY_INVENTORY       @"inventory"
#define KEY_OPTION          @"options"
#define KEY_PRICE           @"price"

@implementation BLVariant

#pragma mark Initialization

// Transforms an NSArray of JSON into an NSArray of BLVariant objects
+ (NSMutableArray *)arrayWithJSON:(NSArray *)JSON{
    
    NSMutableArray *variants = [[NSMutableArray alloc] init];
    
    // Transform JSON into BLVariant Objects and add it to variants mutable array
    for (NSDictionary *variantJSON in JSON) {
        [variants addObject:[[BLVariant alloc] initWithJSON:variantJSON]];
    }
    
    // Return the mutable array
    return variants;
    
}

// Intialize cart item with JSON dictionary
- (instancetype)initWithJSON:(NSDictionary *)JSON{
    if (self = [super init]){
        _productId  = [JSON[KEY_PRODUCT_ID] longValue];
        _variantId  = [JSON[KEY_VARIANT_ID] longValue];
        _inventory  = [JSON[KEY_INVENTORY] intValue];
        _price      = JSON[KEY_PRICE];
        _options    = JSON[KEY_OPTION];
    }
    
    return self;
}

// Returns the JSON dictionary of the object
- (NSDictionary *)JSONDictionary{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSNumber numberWithLong:self.productId] forKey:KEY_PRODUCT_ID];
    [dict setObject:[NSNumber numberWithLong:self.variantId] forKey:KEY_VARIANT_ID];
    [dict setObject:[NSNumber numberWithInt:self.inventory] forKey:KEY_INVENTORY];
    [dict setObject:self.price forKey:KEY_PRICE];
    [dict setObject:self.options forKey:KEY_OPTION];
    
    return dict;
}

// Use for debugging purposes
-(NSString *)description{
    return [NSString stringWithFormat:@"%@", [self.options componentsJoinedByString:@", "]];
}

@end
