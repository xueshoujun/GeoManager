//
//  TLLoginViewController.h
//  GeoManager
//
//  Created by shoujun xue on 2/25/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLServiceRequestLoginDelegate.h"

@protocol TLLoginViewControllerDelegate<NSObject>
-(void)loginSucesse:(NSDictionary *)loginResp;
-(void)loginFailure:(NSDictionary *)failureResp;
@end

@interface TLLoginViewController : UIViewController<UITextFieldDelegate, TLServiceRequestLoginDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTeamName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

@property (weak, nonatomic)id<TLLoginViewControllerDelegate> delegate;
@property (strong, nonatomic) NSDictionary *teamDict;
@property (strong, nonatomic) NSDictionary *loginRespDict;
@end
