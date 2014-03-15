//
//  TLAlertView.m
//  GeoManager
//
//  Created by shoujun xue on 3/6/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLAlertView.h"

@implementation TLAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

-(void)showLoadingView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window == Nil) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        self.frame = window.frame;
        // landscape
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [window addSubview:self];

        // indicator
        UIImage *bgImage = [UIImage imageNamed:@"bg_alert"];
        _indicatior = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatior.frame  = CGRectMake(350, 25, 25, 25);
        [_indicatior setHidesWhenStopped:YES];
        [_indicatior startAnimating];
        
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
        alertLabel.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        alertLabel.text = NSLocalizedString(@"alertLoading", nil);
        alertLabel.font = [UIFont systemFontOfSize:18];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.center = self.center;
        [alertLabel addSubview:_indicatior];
        
        [self addSubview:alertLabel];
    
    });
}

-(void)destroyLoadingView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_indicatior && [_indicatior isAnimating]) {
            [_indicatior setHidden:YES];
            [self removeFromSuperview];
        }
    });
}

-(void)showFadeoutViewWithMessage:(NSString *)message
{
    self.alpha = 0;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window == Nil) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    /* fix not landscape, but can not fix model view
    UIView *backGroundView = [[window subviews] objectAtIndex:0];
    self.frame = backGroundView.frame;
     [backGroundView addSubview:self];
     */
    self.frame = window.frame;
    // landscape
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [window addSubview:self];
    
    [self transformForLandscape];
    UIImage *bgImage = [UIImage imageNamed:@"bg_alert"];
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    alertLabel.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    alertLabel.text = message;
    alertLabel.font = [UIFont systemFontOfSize:18];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.center = self.center;
    [self addSubview:alertLabel];

    [UIView animateWithDuration:1 animations:^{
        self.alpha = 1.0;
    }];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0.0;
        }];
    });
    
    double delayInSeconds_2 = 3.0;
    dispatch_time_t popTime_2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds_2 * NSEC_PER_SEC));
    dispatch_after(popTime_2, dispatch_get_main_queue(), ^(void){
        [self removeFromSuperview];
    });
}

-(void) transformForLandscape
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat angle;
    
    switch (statusBarOrientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
    // landscape
    self.transform = CGAffineTransformMakeRotation(angle);
}


- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification
{
    /*
     This notification is most likely triggered inside an animation block,
     therefore no animation is needed to perform this nice transition.
     */
    [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
}

- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientations
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat angle = UIInterfaceOrientationAngleOfOrientation(statusBarOrientation);
    CGFloat statusBarHeight = [[self class] getStatusBarHeight];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    CGRect frame = [[self class] rectInWindowBounds:self.window.bounds statusBarOrientation:statusBarOrientation statusBarHeight:statusBarHeight];
    
    [self setIfNotEqualTransform:transform frame:frame];
}

- (void)setIfNotEqualTransform:(CGAffineTransform)transform frame:(CGRect)frame
{
    if(!CGAffineTransformEqualToTransform(self.transform, transform))
    {
        self.transform = transform;
    }
    if(!CGRectEqualToRect(self.frame, frame))
    {
        self.frame = frame;
    }
}

+ (CGFloat)getStatusBarHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        return [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    else
    {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (CGRect)rectInWindowBounds:(CGRect)windowBounds statusBarOrientation:(UIInterfaceOrientation)statusBarOrientation statusBarHeight:(CGFloat)statusBarHeight
{
    CGRect frame = windowBounds;
    frame.origin.x += statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? statusBarHeight : 0;
    frame.origin.y += statusBarOrientation == UIInterfaceOrientationPortrait ? statusBarHeight : 0;
    frame.size.width -= UIInterfaceOrientationIsLandscape(statusBarOrientation) ? statusBarHeight : 0;
    frame.size.height -= UIInterfaceOrientationIsPortrait(statusBarOrientation) ? statusBarHeight : 0;
    return frame;
}

CGFloat UIInterfaceOrientationAngleOfOrientation(UIInterfaceOrientation orientation)
{
    CGFloat angle;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
    
    return angle;
}

UIInterfaceOrientationMask UIInterfaceOrientationMaskFromOrientation(UIInterfaceOrientation orientation)
{
    return 1 << orientation;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
