//
//  BLPickerView.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/16/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLPickerView.h"

#define VIEW_HEIGHT 205.0f
#define HEADER_HEIGHT 70.0f

@interface BLPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

    // Data for picker view
    @property (nonatomic, strong) NSMutableArray *data;

    // Frame for entire UIView on show/hidden states
    @property CGRect hiddenFrame;
    @property CGRect showFrame;

    // UIButton
    @property (nonatomic, strong) UIButton *doneButton;

    // Hide picker view
    - (void) hide;

@end

@implementation BLPickerView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Create another ui view
        //
           }
    return self;
}

- (id)init{
    
    if (self = [super init]){
        
        _data = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 15; i++){
            [_data addObject:[NSString stringWithFormat:@"%i", i]];
        }
        
        CGRect screenRect                   = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight                = screenRect.size.height;
        CGFloat screenWidth                 = screenRect.size.width;

        // Set the show/hidden frames
        _showFrame                          = CGRectMake(0, screenHeight - HEADER_HEIGHT - VIEW_HEIGHT, screenWidth, VIEW_HEIGHT + HEADER_HEIGHT); //y offset = height is height of screen - height of header - height of view
        _hiddenFrame                        = CGRectOffset(_showFrame, 0, _showFrame.size.height);

        // Set view containre frame
        self.frame                          = _hiddenFrame;
        self.backgroundColor                = [UIColor whiteColor];

        // Toolbar
        UIView *toolbar                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 43.0f)];
        toolbar.backgroundColor             = [UIColor colorWithRed: 238.0/255.0f green: 238.0/255.0f blue: 238.0/255.0f alpha:1];
        _doneButton                         = [[UIButton alloc] initWithFrame:CGRectMake(240.0f, 0, 80.0f, 46.0f)];
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [_doneButton setTitleColor: [UIColor colorWithRed:92.0/255.0f green:92.0/255.0f blue:92.0/255.0f alpha:1] forState:UIControlStateNormal];
        [_doneButton setTitleColor: [UIColor colorWithRed:92.0/255.0f green:92.0/255.0f blue:92.0/255.0f alpha:1] forState:UIControlStateSelected];
        _doneButton.titleLabel.font         = [UIFont systemFontOfSize:15.0f];
        _doneButton.titleLabel.textColor    =  [UIColor colorWithRed:92.0/255.0f green:92.0/255.0f blue:92.0/255.0f alpha:1];
//        _doneButton.backgroundColor = [UIColor blueColor];
        // Listen for when done button is pressed
        [_doneButton addTarget:self action:@selector(doneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        // Add top and bottom border to toolbar
        toolbar.layer.borderColor = [UIColor colorWithRed:227.0/255.0f green:227.0/255.0f blue:227.0/255.0f alpha:1.0f].CGColor;
        toolbar.layer.borderWidth = 1;
        
        
        // Pickerview
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43.0f, screenWidth, 162.0f)];
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.delegate = self;
        
        // Add subviews 
       
        [toolbar addSubview:_doneButton];
        [self addSubview:toolbar];
        [self addSubview:_picker];
    }
    
    return self;
}

// When done button is pressed
- (void)doneBtnPressed:(UIButton *)button{
    // Hide the entire view
    [self hide];
    
    // Get quantity for picker view, button tag will have the index
    NSInteger quantity = [[self pickerView:self.picker
                         titleForRow:[self.picker selectedRowInComponent:0]
                        forComponent:0] integerValue];

    // BLCartViewController will be the delgate to recieve this call
    [self.delegate updateCartItemAtIndex:button.tag withQuantity:quantity];
}

// Show the scrollview
- (void) show{
    self.frame = self.showFrame;
}

// Show the picker by providing inventory count and current quantity
- (void)showWithCartItem:(BLCartItem *)cartItem cellIndex:(NSInteger)index{
    
    NSLog(@"showing with cart item %@ and inventory %i", cartItem.title, cartItem.inventory);
    
    // Keeps track of the row index
    self.doneButton.tag =  index;

    // Refresh data with new elements
    [self.data removeAllObjects];
    for (int i = 1; i < cartItem.inventory + 1; i++){
        [self.data addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    // Selected value of the picker will be quantity
    [self.picker selectRow:cartItem.quantity - 1 inComponent:0 animated:NO];
    
    // Reload picker
    [self.picker reloadAllComponents];
    
    // Show picker
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = self.showFrame;
    }];
}

// Hide picker view
- (void) hide{
  //  NSLog(@"hidding frame");
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = self.hiddenFrame;
    }];
}

#pragma mark - Pick View data source

// Return number of columns in picker view
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Return number items in count
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.data.count;
}

// Return item for picker in array
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.data objectAtIndex:row];
}


@end