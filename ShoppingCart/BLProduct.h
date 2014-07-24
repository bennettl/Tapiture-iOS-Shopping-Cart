//
//  BLProduct.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/21/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

// Product Model Object used in BLWaterfallViewController and BLProductDetailViewController

@interface BLProduct : NSObject

@property long productId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *vendor;
@property (nonatomic, strong) NSArray *optionCategories;
@property (nonatomic, strong) NSMutableArray *variants;


// Transforms an NSArray of JSON into an NSArray of BLProduct objects
+ (NSMutableArray *)arrayWithJSON:(NSArray *)JSON;
// Intialize cart item with JSON dictionary
- (instancetype)initWithJSON:(NSDictionary *)JSON;
// Returns the JSON dictionary of the object
- (NSDictionary *)JSONDictionary;
// Return an array of variants that contains options
-(NSArray *)filteredVariants:(NSArray *)options;

@end
