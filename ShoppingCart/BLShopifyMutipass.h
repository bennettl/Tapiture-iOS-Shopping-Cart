//
//  BLShopifyMutipass.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/25/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLShopifyMutipass : NSObject

// Returns token base on the given customer data
- (NSString *)generateToken:(NSMutableDictionary *)customerDict;

@end
