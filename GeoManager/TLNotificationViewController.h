//
//  TLNotificationViewController.h
//  GeoManager
//
//  Created by shoujun xue on 3/6/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLNotificationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webViewContent;
@property (strong, nonatomic)NSString *url;
@end
