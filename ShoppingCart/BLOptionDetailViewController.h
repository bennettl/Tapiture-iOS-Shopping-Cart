//
//  BLOptionViewController.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/21/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLVariant.h"
#import "BLProductDetailViewController.h"


@interface BLOptionDetailViewController : UITableViewController

@property (nonatomic, strong) NSString *optionCategoryName;
@property (nonatomic, strong) NSArray *variants;
@property int optionCategoryIndex; // which option index to focus on
@property (nonatomic, strong) BLProductDetailViewController *productViewController;

@end
