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
#import "BLCartTotalCell.h"
#import "BLPickerView.h"
#import "BLCheckoutViewController.h"

@interface BLCartViewController () <UITableViewDelegate, UITableViewDataSource, BLPickerViewDelegate, UIScrollViewDelegate>

    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property (nonatomic, strong) BLPickerView *pickerView;
    @property (nonatomic, strong) BLCartTotalCell *totalCell;

@end

@implementation BLCartViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder: aDecoder];
    if (self) {
        _cart           = [[BLCart alloc] init];
        _pickerView     = [[BLPickerView alloc] init];
        _pickerView.delegate = self;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.view addSubview:self.pickerView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in each section.
    if (section == 0){
        return self.cart.items.count;
    } else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Section 0: Cart cells
    if (indexPath.section == 0){
        static NSString *cartCellIdentifier = @"cartCell";

        BLCartItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cartCellIdentifier];
        
        if (cell == nil) {
            cell = [[BLCartItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cartCellIdentifier];
//            [cell.removeBtn addTarget:self action:@selector(removeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.quantityBtn addTarget:self action:@selector(quantityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        // Grab the cart item from cart and set the cell properties
        BLCartItem *cartItem                    = [self.cart.items objectAtIndex:indexPath.row];
        cell.title.text                         = cartItem.title;
        [cell.quantityBtn setTitle:[NSString stringWithFormat:@"%i", cartItem.quantity] forState:UIControlStateNormal];
        cell.quantityBtn.backgroundColor        = [UIColor whiteColor];
        cell.quantityBtn.layer.borderColor      = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1.0f].CGColor;
        cell.quantityBtn.layer.borderWidth      = 1.0f;
        cell.quantityBtn.layer.cornerRadius     = 5.0f;
        
        cell.price.text                         = [NSString stringWithFormat:@"$ %.2f", [cartItem totalPrice]];
        NSData *image_data                      = [[NSData alloc] initWithContentsOfURL:cartItem.image];
        cell.imgView.image                      = [UIImage imageWithData:image_data];
        
        
        // Buttons will keep track of cell index
        cell.quantityBtn.tag                    = indexPath.row;
        
        return cell;

    } else if (indexPath.section == 1){
        // Section 1: Car total/Checkout Cell
        
        if (indexPath.row == 0){
            static NSString *cartTotalIdentifier = @"cartTotalCell";
            // Carttotal
            BLCartTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:cartTotalIdentifier];
            
            if (cell == nil) {
                cell = [[BLCartTotalCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cartTotalIdentifier];
            }
            
            // Set the total amount for cart
            cell.totalAmount.text = [NSString stringWithFormat:@"$ %.2f", [self.cart totalAmount]];
            
            self.totalCell = cell; // set the total cell's value
            
            return cell;

        } else{
            static NSString *cartCheckoutIdentifier = @"checkoutCell";

            // Checkout
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
   
    // Can't edit anything in "Summary" section
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

// Update quantity button has been pressed
- (IBAction)removeBtnPressed:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self removeItemAtIndexPath:indexPath];
}

// Update quantity button has been pressed
- (IBAction)quantityBtnPressed:(UIButton *)button {
    // Get the cells index path
    UITableViewCell* cell = (UITableViewCell*)button.superview.superview.superview;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    BLCartItem *cartItem = [self.cart.items objectAtIndex:indexPath.row];
    
    // Show picker with inventory count
    [self.pickerView showWithCartItem:cartItem cellIndex:indexPath.row];
}


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
    BLCartItem *cartItem = [self.cart.items objectAtIndex:index];
    BLCartItemCell *cartItemCell = (BLCartItemCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [cartItemCell.quantityBtn setTitle:[NSString stringWithFormat:@"%i", quantity] forState:UIControlStateNormal];
    cartItemCell.price.text = [NSString stringWithFormat:@"$ %.2f", [cartItem totalPrice]];
    [self reloadTotal];
    [self.cart saveToDisk];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Set BLCheckoutViewController's checkout url to shopify's url
    NSLog(@"prepare %@", [self.cart checkoutURL]);
    if ([segue.identifier isEqual: @"checkoutSegue"]){
        BLCheckoutViewController *bcvc = [segue destinationViewController];
        bcvc.url = [self.cart checkoutURL];
    }

}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
