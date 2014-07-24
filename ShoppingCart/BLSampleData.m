//
//  BLProductSampleData.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/22/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLSampleData.h"

#import "BLCartItem.h"
#import "BLProduct.h"

@implementation BLSampleData

// Return a JSON array of product data
+ (NSMutableArray *)productsData{
    static NSMutableArray *_sharedProductsData = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *productsJSON = @[
                                      @{ @"id": [NSNumber numberWithLong:178500921],
                                         @"title": @"Saints Footbar T-Shirt 1967",
                                         @"vendor": @"Junk Food Clothing",
                                         @"images": @[ @"http://cdn.shopify.com/s/files/1/0209/4636/products/JUNKFOOD_N3944-7798_FULL.jpg?v=1384799842"],
                                         @"options": @[ @"Size", @"Color"],
                                         @"variants": @[
                                                 @{
                                                     @"product_id": [NSNumber numberWithLong:178500921],
                                                     @"variant_id": [NSNumber numberWithLong:409050473],
                                                     @"inventory": [NSNumber numberWithInt:0],
                                                     @"options": @[@"S", @"Navy"],
                                                     @"price": @"19.95"
                                                     },
                                                 @{
                                                     @"product_id": [NSNumber numberWithLong:178500921],
                                                     @"variant_id": [NSNumber numberWithLong:409050481],
                                                     @"inventory": [NSNumber numberWithInt:12],
                                                     @"options": @[@"M", @"Navy"],
                                                     @"price": @"19.95"
                                                     },
                                                 @{
                                                     @"product_id": [NSNumber numberWithLong:178500921],
                                                     @"variant_id": [NSNumber numberWithLong:409050485],
                                                     @"inventory": [NSNumber numberWithInt:5],
                                                     @"options": @[@"L", @"Navy"],
                                                     @"price": @"39.95"
                                                     },
                                                 @{
                                                     @"product_id": [NSNumber numberWithLong:178500921],
                                                     @"variant_id": [NSNumber numberWithLong:409050489],
                                                     @"inventory": [NSNumber numberWithInt:0],
                                                     @"options": @[@"XL", @"Navy" ],
                                                     @"price": @"49.95"
                                                     },
                                                 @{
                                                     @"product_id": [NSNumber numberWithLong:178500921],
                                                     @"variant_id": [NSNumber numberWithLong:409050493],
                                                     @"inventory": [NSNumber numberWithInt:2],
                                                     @"options": @[@"XXL", @"Navy"],
                                                     @"price": @"59.95"
                                                     }
                                                 ]
                                         },
                                        @{  @"id": [NSNumber numberWithLong:259470281],
                                              @"title": @"Turf War Boardshorts in Navy",
                                              @"vendor": @"Fyasko",
                                              @"images": @[ @"http://cdn.shopify.com/s/files/1/0209/4636/products/turfwar_boardshort_nvy_04.jpg?v=1394235003"],
                                              @"options": @[ @"Size" ],
                                              @"variants": @[
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:259470281],
                                                      @"variant_id": [NSNumber numberWithLong:598897829],
                                                      @"inventory": [NSNumber numberWithInt:3],
                                                      @"options": @[
                                                              @"28"
                                                              ],
                                                      @"price": @"48.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:259470281],
                                                      @"variant_id": [NSNumber numberWithLong:598897833],
                                                      @"inventory": [NSNumber numberWithInt:20],
                                                      @"options": @[
                                                              @"30"
                                                              ],
                                                      @"price": @"48.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:259470281],
                                                      @"variant_id": [NSNumber numberWithLong:598897837],
                                                      @"inventory": [NSNumber numberWithInt:16],
                                                      @"options": @[ @"31" ],
                                                      @"price": @"48.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:259470281],
                                                      @"variant_id": [NSNumber numberWithLong:598897841],
                                                      @"inventory": [NSNumber numberWithInt:41],
                                                      @"options": @[
                                                              @"32"
                                                              ],
                                                      @"price": @"48.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:259470281],
                                                      @"variant_id": [NSNumber numberWithLong:598897845],
                                                      @"inventory": [NSNumber numberWithInt:14],
                                                      @"options": @[
                                                              @"33"
                                                              ],
                                                      @"price": @"48.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:259470281],
                                                      @"variant_id": [NSNumber numberWithLong:598897849],
                                                      @"inventory": [NSNumber numberWithInt:24],
                                                      @"options": @[
                                                              @"34"
                                                              ],
                                                      @"price": @"48.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:259470281],
                                                      @"variant_id": [NSNumber numberWithLong:598897853],
                                                      @"inventory": [NSNumber numberWithInt:14],
                                                      @"options": @[
                                                              @"36"
                                                              ],
                                                      @"price": @"48.00"
                                                      }
                                                  ]
                                          },
                                      
                                      @{
                                          @"id": [NSNumber numberWithLong:334016665],
                                          @"title": @"'America the Beautiful' Canvas Art",
                                          @"vendor": @"Iconic American Art",
                                          @"images": @[@"http://cdn.shopify.com/s/files/1/0209/4636/products/12724_America_the_Beautiful_ROOM.jpg?v=1403556301"],
                                          @"options": @[ @"Size", @"Color" ],
                                          @"variants": @[
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:334016665],
                                                      @"variant_id": [NSNumber numberWithLong:809468789],
                                                      @"inventory": [NSNumber numberWithInt:50],
                                                      @"options": @[
                                                              @"16x24",
                                                              @"MULTI"
                                                              ],
                                                      @"price": @"230.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:334016665],
                                                      @"variant_id": [NSNumber numberWithLong:809468801],
                                                      @"inventory": [NSNumber numberWithInt:50],
                                                      @"options": @[
                                                              @"20x30",
                                                              @"MULTI"
                                                              ],
                                                      @"price": @"374.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:334016665],
                                                      @"variant_id": [NSNumber numberWithLong:809468809],
                                                      @"inventory": [NSNumber numberWithInt:50],
                                                      @"options": @[
                                                              @"24x36",
                                                              @"MULTI"
                                                              ],
                                                      @"price": @"396.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:334016665],
                                                      @"variant_id": [NSNumber numberWithLong:809468817],
                                                      @"inventory": [NSNumber numberWithInt:50],
                                                      @"options": @[
                                                              @"30x45",
                                                              @"MULTI"
                                                              ],
                                                      @"price": @"585.00"
                                                      }
                                                  ]
                                          },
                                      @{
                                          @"id": [NSNumber numberWithLong:301546129],
                                          @"title": @"San Diego, California",
                                          @"vendor": @"City Prints",
                                          @"images": @[ @"http://cdn.shopify.com/s/files/1/0209/4636/products/HT_SD03.jpg?v=1398959187"],
                                          @"options": @[ @"Size", @"Color" ],
                                          @"variants": @[
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:301546129],
                                                      @"variant_id": [NSNumber numberWithLong:718132449],
                                                      @"inventory": [NSNumber numberWithInt:47],
                                                      @"options": @[
                                                              @"12 x 12",
                                                              @"Multi"
                                                              ],
                                                      @"price": @"39.99"
                                                      }
                                                  ]
                                          },
                                      @{
                                          @"id": [NSNumber numberWithLong:331093849],
                                          @"title": @"Green Earth",
                                          @"vendor": @"Marmont Hill",
                                          @"images": @[  @"http://cdn.shopify.com/s/files/1/0209/4636/products/MHMP-282-C_showroom_2.jpg?v=1402958760", ],
                                          @"options": @[ @"Size", @"Color" ],
                                          @"variants": @[
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:331093849],
                                                      @"variant_id": [NSNumber numberWithLong:799481537],
                                                      @"inventory": [NSNumber numberWithInt:100],
                                                      @"options": @[
                                                              @"24x2x24",
                                                              @"multi"
                                                              ],
                                                      @"price": @"330.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:331093849],
                                                      @"variant_id": [NSNumber numberWithLong:799481541],
                                                      @"inventory": [NSNumber numberWithInt:100],
                                                      @"options": @[
                                                              @"32x2x32",
                                                              @"multi"
                                                              ],
                                                      @"price": @"375.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:331093849],
                                                      @"variant_id": [NSNumber numberWithLong:799481545],
                                                      @"inventory": [NSNumber numberWithInt:100],
                                                      @"options": @[
                                                              @"40x2x40",
                                                              @"multi"
                                                              ],
                                                      @"price": @"479.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:331093849],
                                                      @"variant_id": [NSNumber numberWithLong:799481549],
                                                      @"inventory": [NSNumber numberWithInt:99],
                                                      @"options": @[
                                                              @"48x2x48",
                                                              @"multi"
                                                              ],
                                                      @"price": @"659.00"
                                                      }
                                                  ]
                                          },
                                      @{
                                          @"id": [NSNumber numberWithLong:316617637],
                                          @"title": @"Painted Clouds V by Caleb Troy",
                                          @"vendor": @"Deny Designs",
                                          @"images": @[ @"http://cdn.shopify.com/s/files/1/0209/4636/products/50050-frwamd_2.jpg?v=1400792668"],
                                          @"options": @[ @"Size", @"Color" ],
                                          @"variants": @[
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:316617637],
                                                      @"variant_id": [NSNumber numberWithLong:759363105],
                                                      @"inventory": [NSNumber numberWithInt:500],
                                                      @"options": @[
                                                              @"20 x 20 x 1",
                                                              @"Multi"
                                                              ],
                                                      @"price": @"99.00"
                                                      },
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:316617637],
                                                      @"variant_id": [NSNumber numberWithLong:759363109],
                                                      @"inventory": [NSNumber numberWithInt:500],
                                                      @"options": @[
                                                              @"30 x 30 x 1",
                                                              @"Multi"
                                                              ],
                                                      @"price": @"149.00"
                                                      }
                                                  ]
                                          },
                                      @{
                                          @"id": [NSNumber numberWithLong:314883725],
                                          @"title": @"Texas Flag on Reclaimed Wood",
                                          @"vendor": @"City Prints",
                                          @"images": @[ @"http://cdn.shopify.com/s/files/1/0209/4636/products/TexasFlag_2.jpg?v=1400524794" ],
                                          @"options": @[ @"Size", @"Color" ],
                                          @"variants": @[
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:314883725],
                                                      @"variant_id": [NSNumber numberWithLong:754976637],
                                                      @"inventory": [NSNumber numberWithInt:4],
                                                      @"options": @[
                                                              @"Approx 24\" x 24\"",
                                                              @"Multi"
                                                              ],
                                                      @"price": @"399.00"
                                                      }
                                                  ]
                                          },
                                      @{
                                          @"id": [NSNumber numberWithLong:204162749],
                                          @"title": @"66 Classics gloss",
                                          @"vendor": @"MEZE",
                                          @"images": @[@"http://cdn.shopify.com/s/files/1/0209/4636/products/66classics-gloss-001_-_new_cable.jpg?v=1388792825"],
                                          @"options": @[ @"Size", @"Color" ],
                                          @"variants": @[
                                                  @{
                                                      @"product_id": [NSNumber numberWithLong:204162749],
                                                      @"variant_id": [NSNumber numberWithLong:465453245],
                                                      @"inventory": [NSNumber numberWithInt:0],
                                                      @"options": @[
                                                              @"140 x 140 x 90 mm",
                                                              @"wood"
                                                              ],
                                                      @"price": @"150.00"
                                                      }
                                                  ]
                                          }
                                      
                                      ];
        
        // Transform an array of JSON into array of BLProductObjects
        _sharedProductsData = [BLProduct arrayWithJSON:productsJSON];
    });
    
    return _sharedProductsData;
}


// Return an array of BLCartItems shared by application
+ (NSMutableArray *)cartItemsData{
    static NSMutableArray *_sharedCartItems = nil;
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSArray *cartJSONItems =  @[@{
                                        @"product_id": [NSNumber numberWithLong:314883725],
                                        @"variant_id": [NSNumber numberWithLong:754976637],
                                        @"quantity": [NSNumber numberWithInt:2],
                                        @"inventory":  [NSNumber numberWithInt:4],
                                        @"title": @"Texas Flag on Reclaimed Wood",
                                        @"unit_price": @"399.00",
                                        @"image": @"http://s3tapcdn-a.akamaihd.net/images/50x50/bd/57/13/44/50191c7af6d71dd33f7a1ae7.jpg"
                                        },
                                    @{
                                        @"product_id": [NSNumber numberWithLong:196400877],
                                        @"variant_id": [NSNumber numberWithLong:448214221],
                                        @"quantity": [NSNumber numberWithInt:1],
                                        @"inventory": [NSNumber numberWithInt:16],
                                        @"title": @"Ivy Bracelet in Brown - 7 | Brown",
                                        @"unit_price": @"25.00",
                                        @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/17/20/59/6b/ae4dcab4d4faac7deb874f21.jpg"
                                        }
                                    //                             @{
                                    //                                 @"product_id": [NSNumber numberWithLong:334016665],
                                    //                                 @"variant_id": [NSNumber numberWithLong:809468789],
                                    //                                 @"quantity": [NSNumber numberWithInt:1],
                                    //                                 @"inventory": [NSNumber numberWithInt:50],
                                    //                                 @"title": @"America the Beautiful' Canvas Art - 16x24 | MULTI",
                                    //                                 @"unit_price": @"230.00",
                                    //                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/32/39/92/17/271466f69a86d6d52987f9b3.jpg"
                                    //                             },
                                    //                             @{
                                    //                                 @"product_id": [NSNumber numberWithLong:334016601],
                                    //                                 @"variant_id": [NSNumber numberWithLong:809468497],
                                    //                                 @"quantity": [NSNumber numberWithInt:1],
                                    //                                 @"inventory": [NSNumber numberWithInt:50],
                                    //                                 @"title": @"American Surfing Beauties' Canvas Art - 36x24 | MULTI",
                                    //                                 @"unit_price": @"230.00",
                                    //                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/fe/16/47/52/4e5fe6334d2fcc52b9e8bf2.jpg"
                                    //                             },
                                    //                             @{
                                    //                                 @"product_id": [NSNumber numberWithLong:334016637],
                                    //                                 @"variant_id": [NSNumber numberWithLong:809468633],
                                    //                                 @"quantity": [NSNumber numberWithInt:1],
                                    //                                 @"inventory": [NSNumber numberWithInt:50],
                                    //                                 @"title": @"Cozy Hamburgers' Canvas Art - 16x16 | MULTI",
                                    //                                 @"unit_price": @"180.00",
                                    //                                 @"image": @"http://s3tapcdn-a.akamaihd.net/images/55x55/5c/51/fd/70/b3cbad86bbe3356b2a7124d9.jpg"
                                    //                             }
                                    ];
        // Transform an array of JSON into array of BLCartItemObjects
        _sharedCartItems = [BLCartItem arrayWithJSON:cartJSONItems];
    });
    
    
    return _sharedCartItems;
    

    
    
}
@end
