//
//  TLViewController.h
//  GeoManager
//
//  Created by shoujun xue on 2/21/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLLoginViewController.h"
#import "TLServiceRequestStartDelegate.h"
#import "TLBaseViewController.h"

@interface TLViewController : TLBaseViewController<UITableViewDataSource, UITableViewDelegate,
                                            TLLoginViewControllerDelegate,TLServiceRequestStartDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonRefresh;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *loginTeamDict;
@property (strong, nonatomic) NSDictionary *configItermDict;
@end
