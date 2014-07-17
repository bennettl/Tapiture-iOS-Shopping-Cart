//
//  BLPickerView.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/16/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCartItem.h"

@protocol BLPickerViewDelegate

- (void)updateCartItemAtIndex:(NSInteger)index withQuantity:(NSInteger)quantity;

@end

@interface BLPickerView : UIView

// Picker View
@property (nonatomic, strong) UIPickerView *picker;
// Delegate
@property (nonatomic, strong) id <BLPickerViewDelegate> delegate;

// Show the picker view with inventory and current quantity
- (void)showWithCartItem:(BLCartItem *)cartItem cellIndex:(NSInteger)index;
- (void) hide;

@end
