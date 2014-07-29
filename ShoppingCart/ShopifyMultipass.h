//
//  ShopifyKey.h
//  ShopifyKey
//
//  Created by jbauer on 7/28/14.
//  Copyright (c) 2014 Tapiture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopifyMultipass : NSObject

// Run generate token and perform the get reqeust to log user in
- (void)loginForCustomer:(NSDictionary *)customerDict;

@end
