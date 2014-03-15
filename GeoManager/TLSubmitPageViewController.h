//
//  TLSubmitPageViewController.h
//  GeoManager
//
//  Created by shoujun xue on 2/24/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCoalSeamViewController.h"
#import "TLBaseViewController.h"
#import "TLCoalSeamCell.h"
#import "TLPopoverMenuDelegate.h"
#import "TLServiceRequestSubmitDelegate.h"

/*
 @class TableViewWithBlock;
 @property (weak, nonatomic) IBOutlet TableViewWithBlock *combolTableReporter;
 @property (weak, nonatomic) IBOutlet TableViewWithBlock *combolObserverInfos;
 @property (weak, nonatomic) IBOutlet TableViewWithBlock *comboTableTitle;
 @property (weak, nonatomic) IBOutlet TableViewWithBlock *comboTableShift;
 @property (weak, nonatomic) IBOutlet TableViewWithBlock *combolTableTunnel;
 @property (weak, nonatomic) IBOutlet TableViewWithBlock *combolTableObsvPoint;
 */
enum {
    COAL_SEAM_TOP = 0,
    COAL_SEAM_MIDDLE,
    COAL_SEAM_BOTTOM
};

@interface TLSubmitPageViewController : TLBaseViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,TLCoalSeamViewControllerDelegate, TLCoalSeamCellDelegate, TLPopoverMenuDelegate, TLServiceRequestSubmitDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBase;

//
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
//班次
@property (weak, nonatomic) IBOutlet UITextField *textFieldShift;
@property (weak, nonatomic) IBOutlet UILabel *labelShiftName;
//巷道
@property (weak, nonatomic) IBOutlet UIView *viewTunnel;
@property (weak, nonatomic) IBOutlet UILabel *labelTunnel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTunnel;
@property (weak, nonatomic) IBOutlet UILabel *labelBarGraphTitle;
//观测点前
@property (weak, nonatomic) IBOutlet UIView *viewObserver;
@property (weak, nonatomic) IBOutlet UILabel *labelObserver;
@property (weak, nonatomic) IBOutlet UITextField *textFieldObserverPoint;
@property (weak, nonatomic) IBOutlet UILabel *labelObsvPoint;
@property (weak, nonatomic) IBOutlet UITextField *textFieldObsvMeter;
@property (weak, nonatomic) IBOutlet UILabel *labelObsvMeter;
//煤岩层厚度
@property (weak, nonatomic) IBOutlet UIView *viewCoalSeam;
@property (weak, nonatomic) IBOutlet UILabel *labelCoalSeam;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCoalSeam;
@property (weak, nonatomic) IBOutlet UIView *viewBarGraph;
//顶板锚杆及锚素施工情况选项
@property (weak, nonatomic) IBOutlet UIView *viewRoofAnchor;
@property (weak, nonatomic) IBOutlet UILabel *labelRoofAnchor;
@property (weak, nonatomic) IBOutlet UITextField *textfieldRoofAnchor;

//超前探眼情况
@property (weak, nonatomic) IBOutlet UIView *viewAheadHole;
@property (weak, nonatomic) IBOutlet UILabel *labelAheadHole;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAheadHole;
//掌子面煤岩层、瓦斯、涌水有无变化
@property (weak, nonatomic) IBOutlet UIView *viewTunnelInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelTunnelInfo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTunnelInfo;
// foot view
@property (weak, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UILabel *labelReporter;
@property (weak, nonatomic) IBOutlet UITextField *textFieldReporter;
@property (weak, nonatomic) IBOutlet UILabel *labelTeamName;
@property (weak, nonatomic) IBOutlet UILabel *lableTeamValue;

@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;

@property (strong, nonatomic) NSDictionary *configItemsDict;
@property (strong, nonatomic) NSDictionary *selectedWorkingSuface;
@property (strong, nonatomic) NSDictionary *selectedTunnel;
@property (strong, nonatomic) NSDictionary *selectedPoint;
@property (strong, nonatomic) NSMutableArray *roofArray;
@property (strong, nonatomic) NSMutableArray *tunnelArray;
@property (strong, nonatomic) NSMutableArray *floorArray;
@property (strong, nonatomic) NSMutableDictionary *stratumSubmitDict;
@property (strong, nonatomic) NSMutableDictionary *submitDict;

// Coal Seam
@property (strong, nonatomic) UITextField *textFieldCoalSeamCell;
@property (strong, nonatomic)NSIndexPath *selectedIndexPath;

@property (nonatomic)CGFloat tableHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonMenu;


@end
