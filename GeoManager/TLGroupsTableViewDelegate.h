//
//  TLGroupsTableViewDelegate.h
//  GeoManager
//
//  Created by shoujun xue on 2/24/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLGroupsTableViewDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic)NSArray *dataSource;
@property(strong, nonatomic)UIViewController *parentViewController;
@property(strong, nonatomic)NSString *title;
@property(strong, nonatomic)NSDictionary *selectedTeamDict;
-(id)initWithData:(NSArray *)dataSourceIn ParentViewController:(UIViewController *)parentVC;
@end
