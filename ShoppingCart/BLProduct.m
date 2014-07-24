//
//  BLProduct.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/21/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLProduct.h"
#import "BLVariant.h"
#import "BLImageCache.h"

// Keys used to identifier properties in JSON
#define KEY_PRODUCT_ID          @"id"
#define KEY_TITLE               @"title"
#define KEY_VENDOR              @"vendor"
#define KEY_IMAGES              @"images"
#define KEY_OPTION_CATEGORY     @"options"
#define KEY_VARIANTS            @"variants"
#define KEY_INVENTORY           @"inventory"

@implementation BLProduct

#pragma mark Initialization

// Transforms an NSArray of JSON into an NSArray of BLProduct objects
+ (NSMutableArray *)arrayWithJSON:(NSArray *)JSON{
    NSMutableArray *products = [[NSMutableArray alloc] init];
    
    for (NSDictionary *productJSON in JSON) {
        [products addObject:[[BLProduct alloc] initWithJSON:productJSON]];
    }
    
    return products;
}


// Intialize cart item with JSON dictionary
- (instancetype)initWithJSON:(NSDictionary *)JSON{
    
    if (self = [super init]){
        _productId          = [JSON[KEY_PRODUCT_ID] longValue];
        _title              = JSON[KEY_TITLE];
        _vendor             = JSON[KEY_VENDOR];
        _optionCategories   = JSON[KEY_OPTION_CATEGORY];
        _variants           = [BLVariant arrayWithJSON:JSON[KEY_VARIANTS]];
        
        // Download and sets image asynchronously
        self.imageURL = [NSURL URLWithString:[JSON[KEY_IMAGES] objectAtIndex:0]];
//        [self downloadImageFromURL:imageURL];
    }
    return self;
}

#pragma mark Instance Methods

// Return an array of variants that NSArray (string) options. Used from BLProductDetailViewController -> BLOptionDetailViewController
// Example: How many variants exist for color blue and material silk?
-(NSArray *)filteredVariants:(NSArray *)options{
    NSArray *filteredVariants = self.variants;
    
    // Each iteration will keep filtering down filteredVariants using NSPredicate
    for (NSString *option in options) {
        filteredVariants = [filteredVariants filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"options contains %@", option]];
    }
    
    return filteredVariants;
}

    
// Returns the JSON dictionary of the object
- (NSDictionary *)JSONDictionary{
    NSMutableDictionary *JSON = [[NSMutableDictionary alloc] init];
    
    [JSON setObject:[NSNumber numberWithLong:self.productId] forKey:KEY_PRODUCT_ID];
    [JSON setObject:self.title forKey:KEY_TITLE];
    [JSON setObject:self.vendor forKey:KEY_VENDOR];
    [JSON setObject:self.optionCategories forKey:KEY_OPTION_CATEGORY];
    [JSON setObject:self.variants forKey:KEY_VARIANTS];
    
    return [JSON mutableCopy];
    
}

//- (void) downloadImageFromURL:(NSURL *)url {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        self.image  = [UIImage imageWithData:data];
//    });
//}


@end
