//
//  TLSelectTableView.h
//  GeoManager
//
//  Created by shoujun xue on 3/4/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLSelectTableView : UITableViewController
@property(strong, nonatomic)NSArray *dataSource;
@property(strong, nonatomic)NSString *titleName;
@property(strong, nonatomic)void(^didSelectedAtIndex)(NSIndexPath *index);
@end
