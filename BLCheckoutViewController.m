//
//  BLCheckoutViewController.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/14/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLCheckoutViewController.h"

@interface BLCheckoutViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BLCheckoutViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder: aDecoder];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.webView.delegate = self;

    [self.spinner startAnimating];
    
    // Load webview
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
	// Do any additional setup after loading the view.
    
}

#pragma mark - UIWebViewDelegate

// Stop animation after web view loaded
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.spinner stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error %@", error);
}
@end
