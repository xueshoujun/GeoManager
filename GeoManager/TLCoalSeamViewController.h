//
//  TLCoalSeamViewController.h
//  GeoManager
//
//  Created by shoujun xue on 2/27/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCoalSeamCell.h"

@class TableViewWithBlock;

@protocol TLCoalSeamViewControllerDelegate <NSObject>
-(void)finishInputCoalSeamData;
@end

@interface TLCoalSeamViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TLCoalSeamCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancle;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCoalSeam;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *tableSelectCoalSeam;
@property (strong, nonatomic) UITextField *textFieldCell;
@property (strong, nonatomic)NSIndexPath *selectedIndexPath;

@property (assign, nonatomic)id<TLCoalSeamViewControllerDelegate>delegate;
/*
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *dataArrayRoof;
@property (strong, nonatomic) NSMutableArray *dataArrayTunnel;
@property (strong, nonatomic) NSMutableArray *dataArrayFloor;
 */
@end
