//
//  BLCartBarButtonItem.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/22/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLCartBarButtonItem.h"
#import "BLCart.h"

@implementation BLCartBarButtonItem

#pragma mark Initialization
- (id)init{

    if (self = [super init]){
        // Create the button
        _button = [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, 34, 36)];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:9.0];
        [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        int count = [[BLCart sharedCart] totalItems];

        // Change icon/title insets base on count
        if (count == 0){
            // No count
            [_button setBackgroundImage:[UIImage imageNamed:@"CartNavigationItem"] forState:UIControlStateNormal]; // no red circle
            [_button setTitle:@"" forState:UIControlStateNormal]; // empty string
        } else if (count < 10){
            // Single digit
            [_button setBackgroundImage:[UIImage imageNamed:@"CartNavigationItemNoti"] forState:UIControlStateNormal]; // with red circle
            [_button setTitleEdgeInsets:UIEdgeInsetsMake(-19, 0, 0, 6)];
            [_button setTitle:[NSString stringWithFormat:@"%i", count] forState:UIControlStateNormal];
        } else{
            // Double digits
            [_button setBackgroundImage:[UIImage imageNamed:@"CartNavigationItemNoti"] forState:UIControlStateNormal]; // with red circle
            [_button setTitleEdgeInsets:UIEdgeInsetsMake(-19, 0, 0, 3)];
            [_button setTitle:[NSString stringWithFormat:@"%i", count] forState:UIControlStateNormal];

        }
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self setCustomView:_button];
    }
    
    return self;
    
}

// Refreshes the label to show the number of items currently in cart
- (void)refresh{
    int count = [[BLCart sharedCart] totalItems];
    [self.button setTitle:[NSString stringWithFormat:@"%i", count] forState:UIControlStateNormal];
}

@end
