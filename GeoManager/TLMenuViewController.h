//
//  TLMenuViewController.h
//  GeoManager
//
//  Created by shoujun xue on 3/6/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPopoverMenuDelegate.h"
@interface TLMenuViewController : UITableViewController
@property(assign,nonatomic)id<TLPopoverMenuDelegate>delegate;

@end
