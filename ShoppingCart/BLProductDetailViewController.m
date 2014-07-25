//
//  BLProductViewController.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/21/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLProductDetailViewController.h"
#import "BLVariant.h"
#import "BLOptionCategoryCell.h"
#import "BLOptionDetailViewController.h"
#import "BLCartBarButtonItem.h"
#import "BLCartViewController.h"

// Different tags for ProductActionButton (Notify/Add To Cart)
#define TAG_PRODUCT_ACTION_ADD_TO_CART  0
#define TAG_PRODUCT_ACTION_NOTIFY       1

@interface BLProductDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BLVariant *selectedVariant;

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UILabel *vendor;
@property (weak, nonatomic) IBOutlet UIView *priceViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UITableView *optionCategoryTableView;
@property (weak, nonatomic) IBOutlet UIButton *productActionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation BLProductDetailViewController

#pragma mark Initialization

// When view loaded
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Set product labels/images
    self.productTitle.text                  = self.product.title;
    self.vendor.text                        = self.product.vendor;
    self.price.text                         = [NSString stringWithFormat:@"$%@", ((BLVariant *)self.product.variants.firstObject).price];
    self.imgView.image                      = self.product.image;

    // Set the selected variant to the first variant that's NOT out of stock
    for (int i = 0 ; i < self.product.variants.count; i++) {
        BLVariant *variant = [self.product.variants objectAtIndex:i];
        if (variant.inventory > 0 ){
            self.selectedVariant  = variant;
            break;
        }
    }
    
    // If there's every variant is out of stock, select the first one
    if (self.selectedVariant == nil){
        self.selectedVariant = [self.product.variants objectAtIndex:0];
    }
    
    // Initialize top right cart icon
    self.navigationItem.rightBarButtonItem  = [[BLCartBarButtonItem alloc] init];
    [((BLCartBarButtonItem *)self.navigationItem.rightBarButtonItem).button addTarget:self action:@selector(cartNavigationItemBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

}

// Before the view appears, refresh the cart icon with the appropriate count
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [((BLCartBarButtonItem *)self.navigationItem.rightBarButtonItem) refresh];
}


#pragma mark Setters

// Customer setter. Setting the selected variant will reload the option category tableview and readjust the price
- (void)setSelectedVariant:(BLVariant *)variant{
    // Reload the option category tableview with the selected variant
    _selectedVariant = variant;
    [self.optionCategoryTableView reloadData];
    
    self.price.text                         = [NSString stringWithFormat:@"$%@", variant.price];
    
    // Change the product action button base on variant inventory
    if (self.selectedVariant.inventory > 0){
        self.productActionBtn.tag               = TAG_PRODUCT_ACTION_ADD_TO_CART;
        self.productActionBtn.backgroundColor   = [UIColor colorWithRed:1.0/255.0f green:166.0/255.0f blue:142.0/255.0f alpha:1.0f];
        [self.productActionBtn setTitle:@"Add to Cart" forState:UIControlStateNormal];
    } else{
        self.productActionBtn.tag               = TAG_PRODUCT_ACTION_NOTIFY;
        self.productActionBtn.backgroundColor = [UIColor colorWithRed:69.0/255.0f green:130.0/255.0f blue:219.0/255.0f alpha:1.0f];
        [self.productActionBtn setTitle:@"Notify Me When Back In Stock" forState:UIControlStateNormal];
    }
    
}

#pragma mark - Table view data source for options

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// Return the number of option categories
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.product.optionCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"optionCategoryCell";

    // Reuse cell if possible
    BLOptionCategoryCell *optionCategoryCell = [self.optionCategoryTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (optionCategoryCell == nil){
        optionCategoryCell = [[BLOptionCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    optionCategoryCell.categoryTitle.text = [self.product.optionCategories objectAtIndex:indexPath.row];
    optionCategoryCell.categoryValue.text = [self.selectedVariant.options objectAtIndex:indexPath.row];
    
    // Style cell
    optionCategoryCell.layer.borderColor      = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f].CGColor;
    optionCategoryCell.layer.borderWidth      = 1.0f;
    optionCategoryCell.layer.cornerRadius     = 5.0f;
    
    return optionCategoryCell;

}

// Deselect cell when its selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

#pragma mark Actions

// When the product action button is pressed
- (IBAction)productActionBtnPressed:(UIButton *)button {
    // Base on the tag of the production action button, either add to cart or notify user
    if (self.productActionBtn.tag == TAG_PRODUCT_ACTION_ADD_TO_CART){
        [self addToCart];
    } else if (self.productActionBtn.tag == TAG_PRODUCT_ACTION_NOTIFY){
        [self notifyOutOfStock];
    }
        
}

// Add item to cart and display notification
- (void)addToCart{
    BLCartItem *cartItem = [[BLCartItem alloc] initWithProduct:self.product andVariant:self.selectedVariant];
    [[BLCart sharedCart] addItem:cartItem];
    [((BLCartBarButtonItem *)self.navigationItem.rightBarButtonItem) refresh];
    UIAlertView *addToCartAlert = [[UIAlertView alloc] initWithTitle:@"Added"
                                                                message:[NSString stringWithFormat:@"\"%@\" added to cart!", cartItem.title]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
    [addToCartAlert show];
}

// Display alertview and  use Back In STock API to notify user when item is back in stock
- (void)notifyOutOfStock{
    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"Notify Me"
                                                                message:[NSString stringWithFormat:@"You will be notified immediately when \"%@\" is available!", self.product.title]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
    [notificationAlert show];
    
    // Back in stock API call, requires the following parameters: user email and variant id
    
    //        NSMutableDictionary *dict = @{
    //                                      @"shop": @"tapiture.myshopify.com",
    //                                      @"variant": @{
    //                                                @"variant_no"   : [NSNumber numberWithLong:self.selectedVariant.variantId]
    //                                               },
    //                                       @"notification": @{
    //                                               @"product_no"    : [NSNumber numberWithLong:self.product.productId],
    //                                               @"email"         : @"INSERT_EMAIL_HERE"
    //                                               }
    //                                      };
    
    //        var data = {
    //        shop: '',
    //        variant: {
    //        variant_no: variant_id
    //        },
    //        notification: {
    //        product_no: product_id,
    //        email: email
    //        }
    //        };
    //        // console.log(data);
    //
    //        // If user has no email
    //        if (email.length == 0) {
    //            _helper.showAlert('error', 'Please update your account with an email address where you want to recieve the notification.');
    //            return;
    //        }
    //
    //        // Hide submit button and show alert message
    //        document.getElementById('notify-me-submit').style.display = "none";
    //        _helper.showAlert('success', 'You will be notified when ' + variant_name + ' is back in stock!');
    //
    //        // Create AJAX call
    //        $.ajax({
    //        url: 'https://app.backinstock.org/stock_notification/create.json',
    //        jsonp: 'callback',
    //        dataType: "jsonp",
    //        data: data,
    //        success: function(data) {
    //            //console.log(data);
    //        }
    //        });

}

// When cartNavigationItemBtnPressed is pressed, push the cartViewController created from storyboard
- (void)cartNavigationItemBtnPressed: (UIButton *)button{
    BLCartViewController *bcvc = (BLCartViewController *) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartViewControllerIdentifier"];
    [self.navigationController pushViewController:bcvc animated:YES];
}


#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"optionSegue"]){
        BLOptionDetailViewController *ovc = (BLOptionDetailViewController *) [segue destinationViewController];
        
        ovc.productViewController = self; // set as delegate so data from BLOptionDetailViewController can be passed back to product view controller
        
        // Set BLOptionDetailViewController's optionCategoryIndex and optionCategoryName
        NSIndexPath *selectedPath   = [self.optionCategoryTableView indexPathForSelectedRow];
        ovc.optionCategoryIndex     = selectedPath.row; // use to loop through the option cels
        ovc.optionCategoryName      = [self.product.optionCategories objectAtIndex:selectedPath.row]; // use for title
        
        // Grab the list of every possible variant with the option combination not selected by the user (i.e. every possible size base on color blue and meterial silk)
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.product.optionCategories.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0]; // section 0, row i
            // Don't grab value of cell that has been selected
            if ([selectedPath isEqual:indexPath]){
                continue;
            }
            
            BLOptionCategoryCell *cell = (BLOptionCategoryCell *) [self.optionCategoryTableView cellForRowAtIndexPath:indexPath];
            [options addObject:cell.categoryValue.text];
        }
        
        // Set the variants
        ovc.variants = [self.product filteredVariants:options];
    }
}


@end






































