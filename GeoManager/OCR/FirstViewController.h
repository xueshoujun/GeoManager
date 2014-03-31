//
//  FirstViewController.h
//  Hello_OCR
//
//  Created by imoyo on 14-3-11.
//  Copyright (c) 2014年 guimingsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MocrEngine.h>
#import "RecognitionService.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCropperView.h"

@interface FirstViewController : UIViewController <IRecognitionOperationCallback,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
CMocrEngine* _mocrEngine;
CMocrRecognitionConfiguration* _ocrConfiguration;
NSString* _pathToData;
CRecognitionService* _recognitionService;
    CMocrRecognitionConfiguration* _bcrConfiguration;

	BOOL _needToStopRecognition;
}

//- (void) setProgress:(NSNumber*)progress;
- (void) processRecognitionOperation:(CRecognitionOperation*)operation;

+(FirstViewController *)firstController;

@end

