
//
//  ShopifyKey.m
//  ShopifyKey
//
//  Created by jbauer on 7/28/14.
//  Copyright (c) 2014 Tapiture. All rights reserved.
//

#import "ShopifyMultipass.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <AFNetworking/AFNetworking.h>


#define SHOPIFY_SECRET_KEY @"54b4627015fc81c34b6e92d366ceb770"

//#define TEST_DATA @"{\"email\":\"blee908@yahoo.com\",\"remote_ip\":\"64.183.67.138\",\"identifier\":\"511158\",\"return_to\":\"https://shop.tapiture.com/cart?utm=tapiture.com\",\"created_at\":\"2014-07-29T18:41:47.935Z\"}"
#define TEST_IV @"KCHixj05AcH8m7yBKn7aqg=="

@interface ShopifyMultipass()

@property (nonatomic,strong) NSData *encryptionKey;
@property (nonatomic,strong) NSData *signatureKey;
@property (nonatomic,strong) NSData *shopifyKey;
@property (nonatomic,strong) NSData *testIv;

@end

@implementation ShopifyMultipass

// Initalization: create encrpytion and signature key
-(id) init{
    
    if (self = [super init]){
        unsigned char hash[CC_SHA256_DIGEST_LENGTH];
        
        const char *cstr        = [SHOPIFY_SECRET_KEY cStringUsingEncoding:NSUTF8StringEncoding];
        self.shopifyKey         = [NSData dataWithBytes:cstr length:SHOPIFY_SECRET_KEY.length];
        
        // 1. Use the multipass secret to derive two cryptographic keys through SHA-256. First 128 bit = encryption key. Last 128 bit = signature key.
        if ( CC_SHA256([self.shopifyKey bytes], (int)[self.shopifyKey length], hash) ) {
            NSData *sha256      = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
            _encryptionKey      = [sha256 subdataWithRange:NSMakeRange(0, 16)];
            _signatureKey       = [sha256 subdataWithRange:NSMakeRange(16, 16)];
        }
        
        self.testIv             = [[NSData alloc] initWithBase64EncodedString:TEST_IV options:0];
    }
    
    return self;
}

#pragma mark Public Methods

// Run generate token and perform the get reqeust to log user in
- (void)loginForCustomer:(NSDictionary *)customerDict{
    // Generate the token and url
    NSString *token                                     = [self generateTokenForCustomer:customerDict];
    NSString *multipassLoginURL                         = [self multipassLoginURLWithToken:token];
    
//    NSLog(@"Multipass login url is %@", multipassLoginURL);
    
    // Perform the GET request with multipassLoginURL
    NSMutableURLRequest *request                        = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:multipassLoginURL]];
    
    NSError *error                                      = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode                     = nil;
    
    NSData *oResponseData                               = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", multipassLoginURL, [responseCode statusCode]);
    }
    
//    AFHTTPRequestOperationManager *manager              = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer                           = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes   = [NSSet setWithObject:@"text/html"];
//
//    [manager GET:multipassLoginURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success multiplass login: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error on multipass login: %@", error);
//    }];
}

#pragma mark Private Methods

// Return token base on customre data
-(NSString *)generateTokenForCustomer:(NSDictionary *)customerDict{
    
    NSMutableDictionary *customerMutableDict    = [customerDict mutableCopy];
    
    // 2. Change customre data to store the current date in ISO8601 format.
    [customerMutableDict setObject:[ShopifyMultipass iso8061StringFromNow] forKey:@"created_at"];
    
    NSString *plaintext                         =  [self getStringFromDictionary:customerMutableDict];
    NSMutableData *tokenData                    = [[NSMutableData alloc] init];
    
    // 3. Encrypt the JSON data using AES: 128 bit key length, CBC mode of operation, random initialization vector
    NSData *encryptedData                       = [self encrypt:plaintext];
    [tokenData appendData: encryptedData];
//    NSString *sk64EncryptedData               = [encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSLog(@"encrypted data %@", sk64EncryptedData );

    // 4. Sign the "encrypted" data using HMAC | SHA 256
    NSData *signedData                          = [self signData: encryptedData];
    [tokenData appendData:signedData];
//    NSString *sk64SignedData                  = [signedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSLog(@"signedData  %@", sk64SignedData );

    NSData *sk64Data                            = [tokenData base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *token                             =  [[NSString alloc] initWithData:sk64Data encoding:NSASCIIStringEncoding];
    token                                       = [[token stringByReplacingOccurrencesOfString:@"+" withString:@"-"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//    NSLog( @"Token is: %@", token);

    return token;
}

#pragma mark Encryption functions

// 3. Encrypt the JSON data using AES: 128 bit key length, CBC mode of operation, random initialization vector
-(NSData*) encrypt:(NSString*) _plaintext{
    unsigned char *buffer = NULL;
    size_t bufferSize;
    NSUInteger i = 0;
    CCCryptorStatus err;
    
    const char *cstr = [_plaintext cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *plainData = [NSData dataWithBytes:cstr length:strlen(cstr)];
    
//    NSLog(@"data length: %lu", (unsigned long)[plainData length]);
//    NSLog(@"_plaintext length:%lu", (unsigned long) [_plaintext length]);
//    NSLog(@"sizeof: %lu", sizeof([self.testIv bytes]));
    
    bufferSize =  kCCBlockSizeAES128 + [plainData length] + kCCBlockSizeAES128  ;
    
    
    buffer = (unsigned char *) malloc( bufferSize );
    
    
    // generate random iv
    
    srandomdev();
    
    for ( i = 0; i < kCCBlockSizeAES128; ++i )
    {
        //  buffer[ i ] = 0;
    }
    
    // NSData *randomData = [NSData dataWithBytes:buffer length:kCCBlockSizeAES128];
    
    memcpy(buffer, [self.testIv bytes], [self.testIv length] );
    
    err = CCCrypt(
                  kCCEncrypt,// operation
                  kCCAlgorithmAES128, // algorithm
                  kCCOptionPKCS7Padding, // options
                  [self.encryptionKey bytes], // key
                  [self.encryptionKey length], // key length
                  buffer, // intialization vector
                  [plainData bytes], // input
                  [plainData length], // input length
                  buffer + kCCBlockSizeAES128 , // output
                  bufferSize  , // output size
                  &bufferSize );
    
    if ( err ) {
        NSLog(@"error: %d", err);
        if ( buffer ) free( buffer );
        return nil;
    }
    
    
    return [[NSData alloc] initWithBytesNoCopy:buffer length:bufferSize + kCCBlockSizeAES128 ];;
}

// 4. Sign the encrypted data using HMAC with a SHA-256 hash function
-(NSData *) signData:(NSData *) _data{
    unsigned char hmac[CC_SHA256_DIGEST_LENGTH];
    
    const char *ckey    = [self.signatureKey bytes];
    const char *cdata   = [_data bytes];
    
    CCHmac(kCCHmacAlgSHA256,ckey, strlen(ckey), cdata, strlen(cdata), hmac);
    return [[NSData alloc] initWithBytes:hmac length:sizeof(hmac)];
}

#pragma mark Helper functions

// Transform and NSDictionary into and JSON string
- (NSString *)getStringFromDictionary:(NSDictionary *)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    
    if (! jsonData) {
        NSLog(@"Got an error: %@ %s", error, __PRETTY_FUNCTION__);
    } else {
        // UTF8 encoding, remove newlines, trim ' : ', ', '{ ' substrings
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        jsonString = [[[[jsonString stringByReplacingOccurrencesOfString:@" : " withString:@":"] stringByReplacingOccurrencesOfString:@",  " withString:@","] stringByReplacingOccurrencesOfString:@"{  " withString:@"{"] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }
    
    return jsonString;
}

// Returns the shopify multipass url with the Shopify token
- (NSString *)multipassLoginURLWithToken:(NSString *)token{
    return [NSString stringWithFormat:@"%@%@", @"https://tapiture.myshopify.com/account/login/multipass/", token];
}

+(NSString *) hexRepresentation:(NSData*) _data{
    NSUInteger dataLength = [_data length];
    NSMutableString *string = [NSMutableString stringWithCapacity:dataLength*2];
    const unsigned char *dataBytes = [_data bytes];
    for (NSInteger idx = 0; idx < dataLength; ++idx) {
        [string appendFormat:@"%02x", dataBytes[idx]];
    }
    return string;
}

// Returns iso8061 representation of date
+(NSString *)iso8061StringFromNow{
    NSDate *date                    = [NSDate date];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale       = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSString *iso8601String         = [dateFormatter stringFromDate:date];
    return iso8601String;
}



@end
