//
//  BLProductViewController.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/22/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLWaterfallViewController.h"
#import "BLSampleData.h"
#import "BLProduct.h"
#import "BLProductCell.h"
#import "BLProductDetailViewController.h"
#import "BLCartBarButtonItem.h"
#import "BLCartViewController.h"
#import "BLImageCache.h"
#import "BLShopifyMutipass.h"
#import <AFNetworking/AFNetworking.h>

@interface BLWaterfallViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *products;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) BLImageCache *imageCache;
@property int loadedCells; // use for spinner (when enough cells loaded, stop animating

@end

@implementation BLWaterfallViewController

#pragma mark Initialization

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSMutableDictionary *customerData = [@{ @"email": @"bennettl@usc.edu" } mutableCopy];
    
    // BLShopifyMutipass
    BLShopifyMutipass *mp   = [[BLShopifyMutipass alloc] init];
    NSString *token         =  [mp generateToken:customerData];
    
    NSLog(@"token is %@", token);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token": token};
    [manager POST:@"http://tapiture.myshopify.com/account/login/multipass"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    // BLShopifyMutipass

    // Grab list of products from BLSampleData
    self.products = [BLSampleData productsData];
    // Set the cache
    self.imageCache = [BLImageCache sharedCache];
    
    self.loadedCells = 0; // no cells are loaded yet
    
    // Setup spinner
    self.spinner                            = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame                            = self.spinner.frame;
    frame.origin.x                          = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y                          = self.view.frame.size.height / 2 - (frame.size.height / 2) - 80;
    self.spinner.frame                      = frame;
    self.spinner.hidesWhenStopped           = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    // Initialize top right cart icon
    self.navigationItem.rightBarButtonItem  = [[BLCartBarButtonItem alloc] init];
    [((BLCartBarButtonItem *)self.navigationItem.rightBarButtonItem).button addTarget:self action:@selector(cartNavigationItemBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

// Before the view appears, refresh the cart icon with the appropriate count
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [((BLCartBarButtonItem *)self.navigationItem.rightBarButtonItem) refresh];
}

#pragma mark UICollectionView Datasource

// Number of views in section
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.products.count;
}

// Number of sections
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// Return cell for given indexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLProductCell *cell     = [cv dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];

    cell.backgroundColor    = [UIColor whiteColor];
    
    BLProduct *product = [self.products objectAtIndex:indexPath.row];

    // Handles loading images
    if (product.image != nil){
        // If BLProduct already has an image, use it
        cell.imgView.image = product.image;
        [self.spinner stopAnimating];
    }  else if ([self.imageCache imageExistForProductWithID:product.productId]){
        // Image exist in cache, use it
       // NSLog(@"image EXIST for product with product ID %s" , __PRETTY_FUNCTION__ );
        UIImage *image      =  [self.imageCache imageForProductWithID:product.productId];
        cell.imgView.image  = image;
        product.image       = image;
        [self stopSpinner]; // stop spinner if enough cells have loaded
    } else{
        // Image doesn't exist in cache, need to download it asychronously
       // NSLog(@"image doesnt exist, downloading them now %s" , __PRETTY_FUNCTION__ );

        cell.imgView.image = nil;
        
        //  Download images asynchronously to advoid blocking the main queue
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *image_data  = [[NSData alloc] initWithContentsOfURL:product.imageURL];
            UIImage *image      = [UIImage imageWithData:image_data];
            NSData *imageJPG = UIImageJPEGRepresentation(image, 0.8f);
            
            // Save the image to cache and set it as a property of product image
            [self.imageCache saveImage:imageJPG withProductID:product.productId];
            product.image       = image;

            // Go back to the main thread to set the images
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imgView.image  = image;
                [self stopSpinner]; // stop spinner if enough cells have loaded
            });
        });
        
    }
    return cell;
}

// When cartNavigationItemBtnPressed is pressed, push the cartViewController created from storyboard
- (void)cartNavigationItemBtnPressed: (UIButton *)button{
    BLCartViewController *bcvc = (BLCartViewController *) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartViewControllerIdentifier"];
    [self.navigationController pushViewController:bcvc animated:YES];
}

#pragma mark UICollectionView Delegate

// When a cell is selected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // Perform the segue and pass the selected BLProduct as sender
    BLProduct *product = [self.products objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"productSegue" sender:product];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
// When a cell is deselected
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// Size of items at index path
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake(150, 160);
}

// Spacing between the cells, headers, and footers.
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - Segue

// Prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Product segue
    if ([segue.identifier isEqualToString:@"productSegue"]){
        BLProductDetailViewController *pdvc = (BLProductDetailViewController *) segue.destinationViewController;
        pdvc.product = (BLProduct *)sender;
    }
}

#pragma mark UIHelper
- (void)stopSpinner{
    // Cell is fully loaded, increment the count
    self.loadedCells++;
    
    // If more than 5 cells have loaded, we can stop the spinner
    if (self.loadedCells > 5){
        [self.spinner stopAnimating];
    }

}


@end

































