//
//  TLPopoverMenuDelegate.h
//  GeoManager
//
//  Created by shoujun xue on 3/6/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <Foundation/Foundation.h>
enum {
    POPOVER_MAIN_VIEW = 1,
    POPOVER_SEARCH_VIEW,
    POPOVER_NOTIFICATION,
    POPOVER_LOGOUT
};
@protocol TLPopoverMenuDelegate <NSObject>
-(void)dismisPopoverMenuView:(int)actionID;
@end
