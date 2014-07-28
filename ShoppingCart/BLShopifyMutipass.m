//
//  BLShopifyMutipass.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/25/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLShopifyMutipass.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "BBAES.h"
#import "NSData+Base64.h"
#import "NSString+sha256.h"

#define SHOPIFY_SECRET_TOKEN @"54b4627015fc81c34b6e92d366ceb770" // secret from Shopify
#define BLOCK_SIZE 16

@interface BLShopifyMutipass ()
@property (nonatomic, strong) NSData *encryptionKey;
@property (nonatomic, strong) NSData *signatureKey;
@end

//https://github.com/mdznr/iOS-Passcode/blob/master/Passcode/NSString%2Bsha256.m

@implementation BLShopifyMutipass

- (id)init{
    if (self = [super init]){
        // 1. Use the Multipass secret to derive two cryptographic keys through SHA-256
        // The first 128 bit are used as encryption key and the last 128 bit are used as signature key.
        NSData *sha256Secret    = [SHOPIFY_SECRET_TOKEN sha256Data];
        _encryptionKey          = [sha256Secret subdataWithRange:NSMakeRange(0, BLOCK_SIZE)];
        _signatureKey           = [sha256Secret subdataWithRange:NSMakeRange(BLOCK_SIZE, BLOCK_SIZE)];
    }
    return self;
}

// Return token base on customre data
- (NSString *)generateToken:(NSMutableDictionary *)customerDict{
    // 2. Change customre data to store the current date in ISO8601 format.
    [customerDict setObject:[BLShopifyMutipass iso8061StringFromDate:[NSDate date]] forKey:@"created_at"];
    
    // 3. Encrypt the JSON data using AES: 128 bit key length, CBC mode of operation, random initialization vector
    NSData *encryptedData   = [self encryptCustomerDict:customerDict];
    
    // 4. Sign the "encrypted" data using HMAC | SHA 256
    NSData *signature       = [self sign:encryptedData];
    
    // Multipass login token now consists of the 128 bit initialization vector, a variable length ciphertext, and a 256 bit signature
    NSMutableData *combinedData = [[NSMutableData alloc] initWithData:encryptedData];
    [combinedData appendData:signature];
    
    // 5. Token is base64 encoded
    NSString *token         = [[combinedData base64EncodedStringWithOptions:nil]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return token;
}

- (NSData *)encryptCustomerDict:(NSMutableDictionary *)customerDict{
    NSData *customerData    = [NSKeyedArchiver archivedDataWithRootObject:customerDict];
    // Random initialization vector
    NSData *iv = [BBAES randomIV];

    //  AES: 128 bit key length, CBC mode of operation, random IV
    NSData *encryptedData = [BBAES encryptedDataFromData:customerData
                                                      IV:iv
                                                     key:_encryptionKey
                                                 options:BBAESEncryptionOptionsIncludeIV];
    
    return encryptedData;
}

// 4. Sign the encrypted data using HMAC with a SHA-256 hash function
- (NSData *)sign:(NSData *)encryptedData{
    
    NSMutableData* result       = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, _signatureKey.bytes, _signatureKey.length, encryptedData.bytes, encryptedData.length, result.mutableBytes);
    
    return result;
}


#pragma mark Helper functions


// Returns iso8061 representation of date
+(NSString *)iso8061StringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale       = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSString *iso8601String         = [dateFormatter stringFromDate:date];
    return iso8601String;
}






@end
