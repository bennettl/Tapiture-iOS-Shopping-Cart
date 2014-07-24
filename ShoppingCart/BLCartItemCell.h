//
//  BLCartCell.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/14/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCartItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *quantityBtn;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
