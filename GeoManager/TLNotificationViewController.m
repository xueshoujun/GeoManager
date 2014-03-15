//
//  TLNotificationViewController.m
//  GeoManager
//
//  Created by shoujun xue on 3/6/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLNotificationViewController.h"
#import "TLConstantClass.h"

@interface TLNotificationViewController ()

@end

@implementation TLNotificationViewController

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
//    self.url = URL_NOTIFICATION;
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webViewContent loadRequest:request];;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
