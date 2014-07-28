//
//  NSString+sha256.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/25/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (sha256)

+ (NSString *)base64StringFromData:(NSData *)theData;

- (NSData *)sha256Data;
- (NSString *)sha256;


@end
