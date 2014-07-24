//
//  BLOptionDetailCell.h
//  ShoppingCart
//
//  Created by Bennett Lee on 7/21/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLOptionDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *optionTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *inventory;

@end
