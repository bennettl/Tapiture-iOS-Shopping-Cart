//
//  BLCartBarButtonItem.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/22/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

// BLCartBarButtonItem is a UIBartButtonItem on the top left of the screen

@interface BLCartBarButtonItem : UIBarButtonItem

@property (nonatomic, strong) UIButton *button;

// Refreshes the label to show the number of items currently in cart
- (void)refresh;

@end
