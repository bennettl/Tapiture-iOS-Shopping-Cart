//
//  BLCartViewController.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/11/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLCartViewController.h"
#import "BLCartItem.h"
#import "BLCartItemCell.h"
#import "BLCartItemCountCell.h"
#import "BLCartTotalCell.h"
#import "BLPickerView.h"
#import "BLCheckoutViewController.h"

@interface BLCartViewController () <UITableViewDelegate, UITableViewDataSource, BLPickerViewDelegate, UIScrollViewDelegate>
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property (nonatomic, strong) BLPickerView *pickerView;
    @property (nonatomic, strong) BLCartTotalCell *totalCell;
@property (nonatomic, strong) NSMutableDictionary *cachedImages;
@end

@implementation BLCartViewController

#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder: aDecoder];
    if (self) {
        _cart                   = [BLCart sharedCart];
        _pickerView             = [[BLPickerView alloc] init];
        _pickerView.delegate    = self;
        _cachedImages           = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// When view is loaded
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.pickerView];
}

#pragma mark - Table view data source

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

// Return the number of rows in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return self.cart.items.count; // BLCartItemCells
    } else{
        return 3; // BLCartItemCountCell, BLCartTotalCell, and checkoutCell
    }
}

// Return cell at index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        // Section 0: Cart cells
        
        static NSString *cartCellIdentifier = @"cartCell";
        
        // Deque or instantiate a BLCartItemCell
        BLCartItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cartCellIdentifier];
        
        if (cell == nil) {
            cell = [[BLCartItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cartCellIdentifier];
        }
        
        // Grab the cart item from cart
        BLCartItem *cartItem                    = [self.cart.items objectAtIndex:indexPath.row];
        // Set the cell properties
        cell.title.text                         = cartItem.title;
        cell.price.text                         = [NSString stringWithFormat:@"$ %.2f", [cartItem totalPrice]];
        cell.quantityBtn.tag                    = indexPath.row; // quantityBtn keeps track on which cell it resides in via tag property
        [cell.quantityBtn setTitle:[NSString stringWithFormat:@"%i", cartItem.quantity] forState:UIControlStateNormal];
        // Styling for quantityBtn
        cell.quantityBtn.backgroundColor        = [UIColor whiteColor];
        cell.quantityBtn.layer.borderColor      = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1.0f].CGColor;
        cell.quantityBtn.layer.borderWidth      = 1.0f;
        cell.quantityBtn.layer.cornerRadius     = 5.0f;
        
        // Handle images. Get back from cache if image exist, else retrieve it from web
//        NSString *imageIdentifier = [NSString stringWithFormat:@"IMAGE_%@", cartItem.title];
        
//        if ([self.cachedImages objectForKey:imageIdentifier] != nil){
//            cell.imgView.image = [self.cachedImages valueForKey:imageIdentifier];
//        } else{
//            char const * s = [imageIdentifier UTF8String];
//            dispatch_queue_t queue = dispatch_queue_create(s, 0);
//
//            dispatch_async(queue, ^{
//                NSData *image_data  = [[NSData alloc] initWithContentsOfURL:cartItem.image];
//                UIImage *image  = [UIImage imageWithData:image_data];
//                
//                // Return back into main queue
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.cachedImages setValue:image forKey:imageIdentifier];
                    cell.imgView.image = cartItem.image;
//                });
//            });
//        }
        return cell;

    } else if (indexPath.section == 1){
        // Section 1: Car total/Checkout Cell
       
        if (indexPath.row == 0){
            // BLCartItemCountCell
            static NSString *cartItemCountIdentifier = @"cartItemCountCell";

            // Deque or instantiate a BLCartItemCountCell
            BLCartItemCountCell *cell =  [tableView dequeueReusableCellWithIdentifier:cartItemCountIdentifier];
            
            if (cell == nil) {
                cell = [[BLCartItemCountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cartItemCountIdentifier];
            }
            
            // Set cell property
            cell.count.text = [NSString stringWithFormat:@"%i", [self.cart totalItems]];
            
            return cell;
            
        } else if (indexPath.row == 1){
            // BLCartTotalCell
            static NSString *cartTotalIdentifier = @"cartTotalCell";
            
            // Deque or instantiate a BLCartTotalCell
            BLCartTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:cartTotalIdentifier];
            
            if (cell == nil) {
                cell = [[BLCartTotalCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cartTotalIdentifier];
            }
            
            // Set cell property
            cell.totalAmount.text = [NSString stringWithFormat:@"$ %.2f", [self.cart totalAmount]];
            
            self.totalCell = cell; // set the total cell's value
            
            return cell;

        } if (indexPath.row == 2){
            // CheckoutCell
            static NSString *cartCheckoutIdentifier = @"checkoutCell";

            // Deque or instantiate a checkoutCell
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cartCheckoutIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cartCheckoutIdentifier];
            }
            
            return cell;
        }
    }
    
    return nil;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   
    // Only allow editing in the first section
    return (indexPath.section == 0) ? YES : NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeItemAtIndexPath:indexPath];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Return height for cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section == 0) ? 105.0 : 55.0;
}

// Return title for sections
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return (section == 0) ? @"Items" : @"Summary";
}

// Deselect cell when it's selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

#pragma mark Actions

// Update quantity button has been pressed
- (IBAction)quantityBtnPressed:(UIButton *)button {
    // Get the cells index path
    UITableViewCell* cell = (UITableViewCell*)button.superview.superview.superview;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    BLCartItem *cartItem = [self.cart.items objectAtIndex:indexPath.row];
    
    // Show picker with inventory count
    [self.pickerView showWithCartItem:cartItem cellIndex:indexPath.row];
}

#pragma mark Instance Methods

// Re-calcuate subtotal of view
- (void)reloadTotal{
    // Set total if not total cell is not nil
    if (self.totalCell){
        self.totalCell.totalAmount.text = [NSString stringWithFormat:@"$ %.2f", [self.cart totalAmount]];
    }
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  //  NSLog(@"hey %i", scrollView.contentOffset.y);
    [self.pickerView hide];
}

#pragma mark - Picker view delegate

// Remove index path
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath{
    // Delete the row from the cart items
    [self.cart.items removeObjectAtIndex:indexPath.row];
    // Delete the row from view
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    // Update total
    [self reloadTotal];
    // Save cart changes to disk
    [self.cart saveToDisk];
}

// Update cart item and reload table data
- (void)updateCartItemAtIndex:(NSInteger)index withQuantity:(NSInteger)quantity{
    [self.cart updateItemAtIndex:index withQuantity:quantity];

    // Update the cell button with new quantity
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    // Update cart quantity, item total, and cart total
    BLCartItem *cartItem            = [self.cart.items objectAtIndex:index];
    BLCartItemCell *cartItemCell    = (BLCartItemCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [cartItemCell.quantityBtn setTitle:[NSString stringWithFormat:@"%li", (long)quantity] forState:UIControlStateNormal];
    cartItemCell.price.text         = [NSString stringWithFormat:@"$ %.2f", [cartItem totalPrice]];
    [self reloadTotal]; // reload total cell
    [self.cart saveToDisk]; // save cart to disk
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Set BLCheckoutViewController's checkout url to shopify's url
    if ([segue.identifier isEqual: @"checkoutSegue"]){
        BLCheckoutViewController *bcvc = [segue destinationViewController];
        bcvc.url = [self.cart checkoutURL];
    }
}

@end
