//
//  BLOptionViewController.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/21/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLOptionDetailViewController.h"
#import "BLOptionDetailCell.h"

@interface BLOptionDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BLOptionDetailViewController

#pragma mark Initialization

- (void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - Table view data source

// Return header title for section 0
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Select A %@", self.optionCategoryName];
}

// Return height of tableviewcells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 97;
}

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.variants.count;
}

// When an index cell is selected, pass information back to BLProductViewController and pop the current view controller
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // If variant inventory is greater than 0, pass information back to BLProductViewController on selected variant i, else notify user
    BLVariant *variant = [self.variants objectAtIndex:indexPath.row];
    if (variant.inventory > 0){
        [self.productViewController setSelectedVariant:variant];
    } else{
        [self.productViewController notifyOutOfStock];
    }
    // Pop view controller
    [self.navigationController popViewControllerAnimated:YES];
}

// Return the cell at index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"optionDetailCell";
    BLOptionDetailCell *detailCell  = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (detailCell == nil){
        detailCell = [[BLOptionDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Grab variant information
    BLVariant *variant              = [self.variants objectAtIndex:indexPath.row];
    // Set cell properties
    detailCell.optionTitle.text     = [variant.options objectAtIndex:self.optionCategoryIndex];
    detailCell.price.text           = [NSString stringWithFormat:@"$%@", variant.price];
    // If out of stock, display different text
    detailCell.inventory.text       = (variant.inventory > 0 ) ? [NSString stringWithFormat:@"Only %i left in stock", variant.inventory] : @"Notify Me When Back In Stock";
    
    return detailCell;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
