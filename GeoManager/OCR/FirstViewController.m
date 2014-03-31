//
//  FirstViewController.m
//  Hello_OCR
//
//  Created by imoyo on 14-3-11.
//  Copyright (c) 2014年 guimingsu. All rights reserved.
//

#import "FirstViewController.h"
#import "ImageUtils.h"
#import "MBProgressHUD.h"
#import "ResultViewController.h"
int const maxImagePixelsAmount = 3200000; // 3.2 MP

@implementation FirstViewController{
    int width,height;
    UIImagePickerController *cameraController ;
    UIImagePickerController* camera ;
     UIImageView *resultImgView;
    UIImageView* img;//背景图片
    UIImageView* backImg;
    ImageCropperView *cropper;
    NSObject<IMocrRecognitionManager>* recognitionManager;
     MBProgressHUD *HUD;
    int type2;
    UIImage *image2;
}



static FirstViewController *firstController = nil;
+(FirstViewController *)firstController{
    @synchronized(self){
        if(firstController == nil){
            firstController = [[self alloc] init];
        }
    }
    return firstController;
}
+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (firstController == nil) {
            firstController = [super allocWithZone:zone];
            return  firstController;
        }
    }
    return nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _pathToData = nil;
        [self initializeRecognitionEngine];
        
    }
    return self;
}


- (void) initializeRecognitionEngine
{
	// Load the license data from file.
	NSString* licenseDataFilePath = [[self pathToData] stringByAppendingPathComponent:@"license"];
	NSFileHandle* licenseDataFile = [NSFileHandle fileHandleForReadingAtPath:licenseDataFilePath];
	NSData* licenseData = [licenseDataFile readDataToEndOfFile];
	
	// Intialize MobileOCR engine
	NSArray* dataSources = [NSArray arrayWithObject:[CMocrDirectoryDataSource dataSourceWithDirectoryPath:[self pathToData]]];
	CMocrLicense* license = [CMocrLicense licenseWithLicenseData:licenseData applicationId:@"iOS_ID"];
	_mocrEngine = [CMocrEngine createSharedEngineWithDataSources:dataSources license:license];
	if( _mocrEngine == nil ) {
		// Failed to create singleton instance of the CMocrEngine class.
		TMocrErrorCode errorCode;
		NSString* errorMessage;
		[CMocrEngine getLastError:&errorCode message:&errorMessage];
		//NSLog(@"Error code: %@. Error message: %@", [CRecognitionViewController stringFromMocrErrorCode:errorCode], errorMessage);
	}
	
	_ocrConfiguration = nil;
    _bcrConfiguration = nil;
    
    _recognitionService = [[CRecognitionService alloc] init];

}

- (NSString*) pathToData
{
	if( _pathToData == nil ) {
		NSBundle* mainBundle = [NSBundle mainBundle];
		if( mainBundle != nil ) {
			NSString* bundlePath = [mainBundle bundlePath];
			_pathToData = [bundlePath copy];
		} else {
			_pathToData = @"./";
		}
	
	}
	return _pathToData;
}


- (CMocrRecognitionConfiguration*) ocrConfiguration
{
	if( _ocrConfiguration == nil ) {
		NSSet* recognitionLanguages = [NSSet setWithObjects:@"English", nil];
		_ocrConfiguration = [[CMocrRecognitionConfiguration alloc]
                             initWithImageResolution:300
                             imageProcessingOptions:0
                             recognitionMode:MRM_Full
                             recognitionConfidenceLevel:MRCL_Level3
                             barcodeTypes:MBT_ANY1D | MBT_SQUARE2D
                             defaultCodePage:MSCP_Utf8
                             unknownLetter:L'^'
                             recognitionLanguages:recognitionLanguages];
	}
	return _ocrConfiguration;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor redColor];
    
 
    camera = [[UIImagePickerController alloc]init];
    camera.sourceType=UIImagePickerControllerSourceTypeCamera;
    camera.delegate=self;
    camera.showsCameraControls=NO;
    camera.editing=YES;
    [self.view addSubview:camera.view];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    width = self.view.frame.size.height;
    height = self.view.frame.size.width;
    
    backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
    backImg.transform=CGAffineTransformMakeRotation(M_PI/2);
    [self.view addSubview:backImg];
    
    img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background2"]];
    img.userInteractionEnabled=YES;
    img.transform=CGAffineTransformMakeRotation(M_PI/2);
    img.frame=CGRectMake(0, 0, 320, 480);
    [self.view addSubview:img ];
    
    UIButton* backBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 33)];
    [backBt setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [img addSubview:backBt ];
    
    UIButton* helpBt = [[UIButton alloc]initWithFrame:CGRectMake(width-45, 10, 35, 35)];
    [helpBt setBackgroundImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    // [helpBt addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    //[img addSubview:helpBt ];
    
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, width, 30)];
    lable.text = @"将图片中数字移动或缩放到选图框中适当位置，点击按钮截取数字";
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor=[UIColor whiteColor];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment=NSTextAlignmentCenter;
    [img addSubview:lable ];
    
    
    UIButton* submitBt = [[UIButton alloc]initWithFrame:CGRectMake((width-60)/2, 190, 60, 60)];
    [submitBt setBackgroundImage:[UIImage imageNamed:@"submit2"] forState:UIControlStateNormal];
    [submitBt addTarget:self action:@selector(buttonTap) forControlEvents:UIControlEventTouchUpInside];
    [img addSubview:submitBt ];
    
    UIButton* photoBt = [[UIButton alloc]initWithFrame:CGRectMake(width-45, 205, 35, 35)];
    [photoBt setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    //[photoBt addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
    //[img addSubview:photoBt ];
    
    
    NSArray* nameArray = @[@"身份证",@"行驶证",@"护照",@"车架号",@"组织机构代码证"];
    
    for (int i=0; i<5; i++) {
        UIButton* bt = [[UIButton alloc]initWithFrame:CGRectMake(0+width/5*i, 270, width/5, 50)];
        [bt setTitle:nameArray[i] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:13];
        bt.tag=i+1;
        if (i==0) {
            bt.selected=YES;
        }
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [bt setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [bt addTarget:self action:@selector(btTap:) forControlEvents:UIControlEventTouchUpInside];
        [img addSubview:bt ];
        if (i%2==0) {
            [bt setBackgroundImage:[UIImage imageNamed:@"bt1"] forState:UIControlStateNormal];
        }else{
            [bt setBackgroundImage:[UIImage imageNamed:@"bt2"] forState:UIControlStateNormal];
        }
    }

    cropper = [[ImageCropperView alloc]initWithFrame:CGRectMake(0,0,480, 50)];
    
    recognitionManager =[_mocrEngine newRecognitionManagerWithConfiguration:[self bcrConfiguration]];
    type2=1;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return UIInterfaceOrientationLandscapeRight;
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)btTap:(UIButton*)button {
     backImg.image=nil;
    for (int i=1; i<6; i++) {
        UIButton* bt =(UIButton*)[self.view viewWithTag:i];
        bt.selected=NO;
    }
    button.selected=YES;
     type2=button.tag;

}
-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidDisappear:(BOOL)animated{

    backImg.image=nil;

}

- (CMocrRecognitionConfiguration*) bcrConfiguration
{
	if( _bcrConfiguration == nil ) {
		NSSet* recognitionLanguages = [NSSet setWithObjects:@"English", nil];
		_bcrConfiguration = [[CMocrRecognitionConfiguration alloc]
                             initWithImageResolution:0
							 imageProcessingOptions:0
                             recognitionMode:MRM_Full
                             recognitionConfidenceLevel:MRCL_Level3
                             barcodeTypes:0
                             defaultCodePage:MSCP_Utf8
                             unknownLetter:L'^'
                             recognitionLanguages:recognitionLanguages];
	}
	return _bcrConfiguration;
}


-(void)buttonTap{
    backImg.image=nil;
    [camera takePicture];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    image2 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [backImg setFrame:CGRectMake(0, 0, 320, 480)];
    [backImg setImage:image2];
    [self showHudOnWindowWithMessage:@"读取中"];
    
   [cropper setFuckImg:backImg.image];

  //	[self processRecognitionOperation:[CRecognizeBusinessCardOnImageOperation operationWithRecognitionManager:recognitionManager imageToRecognize:[UIImage imageNamed:@"test.png"] callbackObject:self]];

    [self processRecognitionOperation:[CRecognizeBusinessCardOnImageOperation operationWithRecognitionManager:recognitionManager imageToRecognize:cropper.croppedImage callbackObject:self]];
    
    
    cropper.croppedImage=nil;

}

- (BOOL) calledWithProgress:(int)progress warningCode:(TMocrWarningCode)warningCode
{
    return NO;
}
- (void) processRecognitionOperation:(CRecognitionOperation*)operation
{

	[_recognitionService addOperation:operation];
}

- (void) onRecognizeBusinessCardOnImageSucceedWithBusinessCard:(CMocrBusinessCard*)businessCard
												  rotationType:(CMocrRotationType*)rotationType
{
    
    [cropper setFuckImg:nil];
    cropper.croppedImage=nil;
    
    if (businessCard.fields.count>0) {
        CMocrBusinessCardField*f=	businessCard.fields[0];
        if (f.lines.count>0) {
            CMocrTextLine* l=[f.lines objectAtIndex:0];
            NSLog(@"%@",l.copyString);
            sleep(2);
            ResultViewController* result = [[ResultViewController alloc]init];
            result.type=type2;
            result.content=l.copyString;
            [self presentModalViewController:result animated:YES];
            [self hideHud:YES afterDelay:0.3];
            return;
        }
    }
    
    HUD.labelText=@"读取失败";
    [self hideHud:YES afterDelay:1];
    image2=nil;
    

}
#pragma  mark -HUD

- (void)showHudOnWindowWithMessage:(NSString *)message
{
    UIWindow * kewindow = [[UIApplication sharedApplication]keyWindow];
    if (kewindow) {
        HUD = [[MBProgressHUD alloc] initWithView:kewindow];
       HUD.transform=CGAffineTransformMakeRotation(M_PI/2);
    }
    else
    {
        return;
    }
	[kewindow addSubview:HUD];
	//HUD.dimBackground = YES;
    HUD.labelText = message;
    [HUD show:YES];
    image2=nil;
}

- (void)hideHud:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    [HUD hide:animated afterDelay:delay];
}
- (void) onRecognitionFailedWithErrorCode:(CMocrErrorCode*)errorCode errorMessage:(NSString*)errorMessage{
    NSLog(@"%@",errorMessage);
    
    HUD.labelText=@"读取失败 ";
    [self hideHud:YES afterDelay:1];
    [cropper setFuckImg:nil];
    cropper.croppedImage=nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
