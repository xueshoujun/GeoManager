//
//  TLAlertView.h
//  GeoManager
//
//  Created by shoujun xue on 3/6/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLAlertView : UIView
@property (retain, nonatomic)UIActivityIndicatorView *indicatior;
-(void)showLoadingView;
-(void)destroyLoadingView;

-(void)showFadeoutViewWithMessage:(NSString *)message;
@end
