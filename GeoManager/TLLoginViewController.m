//
//  TLLoginViewController.m
//  GeoManager
//
//  Created by shoujun xue on 2/25/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLLoginViewController.h"
#import "TLConstantClass.h"
#import "TLServiceRequest.h"
#import "TLAlertView.h"

@interface TLLoginViewController ()
@property(retain, nonatomic)TLAlertView *alertLoading;
@end

@implementation TLLoginViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_loginView"]];

    self.labelTeamName.text = _teamDict[K_NAME];
    _textFieldPassword.delegate = self;
//    [_textFieldPassword becomeFirstResponder];
}

// 修改modalview size 的方法
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.layer.cornerRadius = 10.0f;
    self.view.superview.layer.masksToBounds = YES;
    self.view.superview.bounds = CGRectMake(0, 0, 396, 165);
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)LoginAction:(id)sender {
    
    NSMutableDictionary *requestDict = [_teamDict mutableCopy];
    if (_textFieldPassword.text == Nil || _textFieldPassword.text.length == 0) {
        TLAlertView *alertView = [[TLAlertView alloc] init];
        [alertView showFadeoutViewWithMessage:NSLocalizedString(@"alertNotInputPassword", nil)];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_textFieldPassword becomeFirstResponder];
        });
        
        return;
    }
    [requestDict setObject:_textFieldPassword.text forKey:K_PASSWORD];
    [TLServiceRequest shareInstance].loginDelegate = self;
    [[TLServiceRequest shareInstance] loginRequest:requestDict];
    
    [_textFieldPassword resignFirstResponder];
    
    [self performSelector:@selector(showLoadingView) withObject:nil afterDelay:2];
    
}
-(void)showLoadingView
{
    _alertLoading = [[TLAlertView alloc] init];
    [_alertLoading showLoadingView];
}

#pragma mark - TLServiceRequestLoginDelegate
-(void)loginResponse:(NSDictionary *)response
{
    if (_alertLoading) {
        [_alertLoading destroyLoadingView];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLoadingView) object:nil];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([K_REQUEST_RESULT_FAILURE isEqualToString:[response objectForKey:K_REQUEST_RESULT]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(loginFailure:)]) {
            [_delegate loginFailure:response];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(loginSucesse:)]) {
            [_delegate loginSucesse:response];
        }

    }
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self LoginAction:nil];
    return YES;
}

-(BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
