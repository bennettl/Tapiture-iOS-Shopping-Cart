//
//  BLVariant.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/21/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLVariant : NSObject

@property long productId;
@property long variantId;
@property int inventory;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSMutableArray *options;

// Transforms an NSArray of JSON into an NSArray of BLVariant objects
+ (NSMutableArray *)arrayWithJSON:(NSArray *)JSON;
// Intialize cart item with JSON dictionary
- (instancetype)initWithJSON:(NSDictionary *)JSON;
// Returns the JSON dictionary of the object
- (NSDictionary *)JSONDictionary;

@end
