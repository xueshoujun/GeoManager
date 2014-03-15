//
//  TLBaseViewController.m
//  GeoManager
//
//  Created by shoujun xue on 3/4/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLBaseViewController.h"

@interface TLBaseViewController ()

@end

@implementation TLBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
    } else {
        self.wantsFullScreenLayout = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
    }

}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
    } else {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = 15;//self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * 1;
        self.view.bounds = viewBounds;
    }
    /*     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
