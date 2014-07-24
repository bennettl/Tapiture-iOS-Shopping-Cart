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

@interface BLWaterfallViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *products;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation BLWaterfallViewController

#pragma mark Initialization

- (void)viewDidLoad{
    [super viewDidLoad];

    // Grab list of products from BLSampleData
    self.products = [BLSampleData productsData];
    
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
    // Handle images. Get back from cache if image exist, else retrieve it from web
//    NSString *imageIdentifier = [NSString stringWithFormat:@"IMAGE_%@", product.title];
    
    // If product image doesn't exist, download it asynchronously
    if (product.image != nil){
        cell.imgView.image = product.image;
    } else{
        cell.imgView.image = nil;
        //  Download images asynchronously to advoid blocking the main queue
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *image_data  = [[NSData alloc] initWithContentsOfURL:product.imageURL];
            UIImage *image      = [UIImage imageWithData:image_data];
    
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.cachedImages setValue:image forKey:imageIdentifier];
                product.image = image;
                cell.imgView.image = image;
                [self.spinner stopAnimating]; // stop animating spinner once an image is loaded
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


@end

































