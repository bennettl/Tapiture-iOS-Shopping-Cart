//
//  BLProductViewController.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/21/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLProduct.h"
#import "BLVariant.h"

@interface BLProductDetailViewController : UIViewController

@property (nonatomic, strong) BLProduct *product;

// Setting the selected variant will reload the option category tableview and readjust the price
- (void)setSelectedVariant:(BLVariant *)variant;
// Display alertview and  use Back In STock API to notify user when item is back in stock
- (void)notifyOutOfStock;
    
@end
