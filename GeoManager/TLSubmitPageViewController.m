//
//  TLSubmitPageViewController.m
//  GeoManager
//
//  Created by shoujun xue on 2/24/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLSubmitPageViewController.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "TLDataCenter.h"
#import "TLConstantClass.h"
#import "NumberKeyboard.h"
#import "TLAlertView.h"
#import "TLServiceRequest.h"

#define PROPERTY_TITLE_NAME         @"titleName"
#define PROPERTY_DATA_SOURCE         @"dataSource"
#define PROPERTY_SELECTED         @"didSelectedAtIndex"
#define TABLE_VIEW_HEIGHT       200

@interface TLSubmitPageViewController ()
@property(strong, nonatomic)NumberKeyboard *keyboard;
@property(strong, nonatomic)UIPopoverController *popoverMenu;
@end

@implementation TLSubmitPageViewController

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

    // add observer remove add dealloc
    _tableHeight = TABLE_VIEW_HEIGHT;
    [self.tableViewCoalSeam addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior context:Nil];
    
    if (![self checkConfigIterm:K_WORKING_SUFACES]) {
        return;
    }
    
    UIImage* image3 = [UIImage imageNamed:@"button_menu"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width*0.8, image3.size.height*0.8);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(buttonMenuAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];

    _viewTitle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_submit_page_title"]];

    self.keyboard = [[NumberKeyboard alloc] initWithNibName:@"NumberKeyboard" bundle:nil];

    _textFieldTitle.delegate = self;
    _textFieldShift.delegate = self;
    _textFieldTunnel.delegate = self;
    _textFieldObserverPoint.delegate = self;
    _textfieldRoofAnchor.delegate = self;
    _textFieldAheadHole.delegate = self;
    _textFieldTunnelInfo.delegate = self;
    _textFieldReporter.delegate = self;
    
    _textFieldObsvMeter.delegate = self;
    _keyboard.textField = _textFieldObsvMeter;
    _keyboard.showsPeriod = YES;
    _textFieldObsvMeter.inputView = _keyboard.view;

    [self setDefaultValue];
    
    // coal seam
    _tableViewCoalSeam.delegate = self;
    _tableViewCoalSeam.dataSource = self;
    _tableViewCoalSeam.editing = YES;
    [_tableViewCoalSeam setContentInset:UIEdgeInsetsMake(0, 0, 110, 0)];
    _tableViewCoalSeam.backgroundColor = [UIColor clearColor];

    [_labelBarGraphTitle setTextColor:COLOR_BLUE_TEXT];
    
    [_textFieldShift setMinimumFontSize:3.0];
    [_textFieldShift setAdjustsFontSizeToFitWidth:YES];
    // Title init ==============
     /*
    _textFieldTitle.delegate = self;
   
    [_comboTableTitle initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return (NSInteger)[_configItemsDict[K_WORKING_SUFACES] count];
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:_configItemsDict[K_WORKING_SUFACES][indexPath.row][K_NAME]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        _textFieldTitle.text=cell.lb.text;
        [self endSelectedTable:tableView];
    }];
    [_comboTableTitle.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_comboTableTitle.layer setBorderWidth:2];
     */
    
    /*
    // Shift init =================
    _textFieldShift.delegate = self;
    
    [_comboTableShift initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return (NSInteger)[_configItemsDict[K_SHIFTS] count];;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:_configItemsDict[K_SHIFTS][indexPath.row][K_NAME]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        _textFieldShift.text=cell.lb.text;
        [self endSelectedTable:tableView];
    }];
    [_comboTableShift.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_comboTableShift.layer setBorderWidth:2];
     
     [self initTunnelView];
     [self initObserverView];
     [self initObserverInfos];
     [self initFooterView];
    */

}

-(void)viewWillAppear:(BOOL)animated
{
    [_tableViewCoalSeam reloadData];
    [self setBarGraphView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[TLDataCenter shareInstance] initCoalSeamData];
}
#pragma mark - self init method
-(void)linkageValueChangedTextField:(UITextField *)textField
{
    if (textField == _textFieldTitle) {
        _submitDict[K_SURFACE_ID] = (_selectedWorkingSuface[K_ID]==nil?@"":_selectedWorkingSuface[K_ID]);
        _textFieldTitle.text = _selectedWorkingSuface[K_NAME];
        
        // tunnels is null
        if (_selectedWorkingSuface[K_TUNNELS] == nil ||
            [_selectedWorkingSuface[K_TUNNELS] isEqual:[NSNull null]]) {
            if (_selectedWorkingSuface[K_NAME]==nil ||
                [_selectedWorkingSuface[K_NAME] length]==0) {
                _textFieldTitle.text = @"_____";
            }else {
                _textFieldTitle.text = _selectedWorkingSuface[K_NAME];
            }
            
            _textFieldTunnel.text = @"";
            _textFieldObserverPoint.text = @"";
            return;
        }
        
        self.selectedTunnel = _selectedWorkingSuface[K_TUNNELS][0];
        _textFieldTunnel.text = _selectedTunnel[K_NAME];
        _submitDict[K_TUNNEL_ID] = (_selectedTunnel[K_ID]==nil?@"":_selectedTunnel[K_ID]);
        
        // point info is null
        if (_selectedTunnel[K_OBSERVER_POINTS] == nil ||
            [_selectedTunnel[K_OBSERVER_POINTS] isEqual:[NSNull null]]) {
        
            _textFieldObserverPoint.text = @"";
            return;
        }

        self.selectedPoint = _selectedTunnel[K_OBSERVER_POINTS][0];
        _submitDict[K_POINT_ID] = (_selectedPoint[K_ID]==nil?@"":_selectedPoint[K_ID]);
        _textFieldObserverPoint.text = _selectedPoint[K_NAME];
    } else if (textField == _textFieldTunnel) {
        
        _submitDict[K_TUNNEL_ID] = (_selectedTunnel[K_ID]==nil?@"":_selectedTunnel[K_ID]);
        if (_selectedTunnel[K_OBSERVER_POINTS] == nil ||
            [_selectedTunnel[K_OBSERVER_POINTS] isEqual:[NSNull null]] ||
            [_selectedTunnel[K_OBSERVER_POINTS] count] == 0) {
            _textFieldTunnel.text = _selectedTunnel[K_NAME];
            _textFieldObserverPoint.text = @"";
            return;
        }
        self.selectedPoint = _selectedTunnel[K_OBSERVER_POINTS][0];
        _textFieldTunnel.text = _selectedTunnel[K_NAME];
        _textFieldObserverPoint.text = _selectedPoint[K_NAME];
    }
}

-(void)setDefaultValue
{
    // for reset
    self.submitDict = [NSMutableDictionary new];
    self.stratumSubmitDict = [NSMutableDictionary new];
    self.roofArray = [NSMutableArray new];
    self.tunnelArray = [NSMutableArray new];
    self.floorArray = [NSMutableArray new];
    
    [_stratumSubmitDict setObject:_roofArray forKey:K_ROOF_ARRAY];
    [_stratumSubmitDict setObject:_tunnelArray forKey:K_TUNNEL_ARRAY];
    [_stratumSubmitDict setObject:_floorArray forKey:K_FLOOR_ARRAY];
    [_submitDict setObject:_stratumSubmitDict forKey:K_STRATUM_ARRAY];

    // system time
    _labelDate.text = (_configItemsDict[K_SERVER_TIME]==Nil)?@"时间":_configItemsDict[K_SERVER_TIME];
    // shift
    if ([self checkConfigIterm:K_SHIFTS]) {
        [_textFieldShift setUserInteractionEnabled:YES];
        _textFieldShift.text = _configItemsDict[K_SHIFTS][0][K_NAME];
        _submitDict[K_SHIFT_ID] = _configItemsDict[K_SHIFTS][0][K_ID];
    } else {
        [_textFieldShift setUserInteractionEnabled:NO];
    }
    // WorkingSuface
    self.selectedWorkingSuface = _configItemsDict[K_WORKING_SUFACES][0];
    _textFieldTitle.text = _selectedWorkingSuface[K_NAME];
    _submitDict[K_SURFACE_ID] = _selectedWorkingSuface[K_ID];
    
    //
    if (_selectedWorkingSuface[K_TUNNELS] &&
        ![_selectedWorkingSuface[K_TUNNELS] isEqual:[NSNull null]] &&
        [_selectedWorkingSuface[K_TUNNELS] count] > 0) {
        [_textFieldTunnel setUserInteractionEnabled:YES];
        self.selectedTunnel = _selectedWorkingSuface[K_TUNNELS][0];
        _textFieldTunnel.text = _selectedTunnel[K_NAME];
        _submitDict[K_TUNNEL_ID] = _selectedTunnel[K_ID];
        
        if (_selectedTunnel[K_OBSERVER_POINTS] &&
            ![_selectedTunnel[K_OBSERVER_POINTS] isEqual:[NSNull null]] &&
            [_selectedTunnel[K_OBSERVER_POINTS] count] > 0) {
            [_textFieldObserverPoint setUserInteractionEnabled:YES];
            self.selectedPoint = _selectedTunnel[K_OBSERVER_POINTS][0];
            _textFieldObserverPoint.text = _selectedPoint[K_NAME];
            _submitDict[K_POINT_ID] = _selectedPoint[K_ID];
        } else {
            _textFieldObserverPoint.text = @"";
            [_textFieldObserverPoint setUserInteractionEnabled:NO];
            // 直接报错
            [self checkConfigIterm:K_OBSERVER_POINTS];
            
        }
    } else {
        _textFieldTunnel.text = @"";
        [_textFieldTunnel setUserInteractionEnabled:NO];
        // 直接报错
        [self checkConfigIterm:K_TUNNELS];
    }
    /*
    if ([self checkConfigIterm:K_TUNNELS]) {
        [_textFieldTunnel setUserInteractionEnabled:YES];
        self.selectedTunnel = _selectedWorkingSuface[K_TUNNELS][0];
        _textFieldTunnel.text = _selectedTunnel[K_NAME];
        _submitDict[K_TUNNEL_ID] = _selectedTunnel[K_ID];
    } else {
        _textFieldTunnel.text = @"";
        [_textFieldTunnel setUserInteractionEnabled:NO];
    }
     
    
    //
    if ([self checkConfigIterm:K_OBSERVER_POINTS]) {
        [_textFieldObserverPoint setUserInteractionEnabled:YES];
        self.selectedPoint = _selectedTunnel[K_OBSERVER_POINTS][0];
        _textFieldObserverPoint.text = _selectedPoint[K_NAME];
        _submitDict[K_POINT_ID] = _selectedPoint[K_ID];
    } else {
        _textFieldObserverPoint.text = @"";
        [_textFieldObserverPoint setUserInteractionEnabled:NO];
    }
     */

    // 观测点前 米
    _textFieldObsvMeter.text = @"";
    _submitDict[K_POINT_AHEAD] = @"";

    // coal seam
    [[TLDataCenter shareInstance] initCoalSeamData];
    if ([self checkConfigIterm:K_STRATUMS]) {
        [_tableViewCoalSeam setUserInteractionEnabled:YES];
        for (NSDictionary *stratum in _configItemsDict[K_STRATUMS]) {
            if ([NSLocalizedString(@"coalSeamName", Nil) isEqualToString:stratum[K_NAME]]) {
                [TLDataCenter shareInstance].coalSeamData[1][0][K_NAME] = stratum[K_NAME];
                [TLDataCenter shareInstance].coalSeamData[1][0][K_STRATUM_ID] = stratum[K_ID];
                [TLDataCenter shareInstance].coalSeamData[1][0][K_STRATUM_IMG] = stratum[K_STRATUM_IMG];
//                [TLDataCenter shareInstance].coalSeamData[1][0] = [stratum mutableCopy];
//                [_tunnelArray addObject:stratum];
            }
        }
    }else{
        [_tableViewCoalSeam setUserInteractionEnabled:NO];
    }
    [_tableViewCoalSeam reloadData];
    
    _textfieldRoofAnchor.text = @"";
    _textFieldAheadHole.text = @"";
    _textFieldTunnelInfo.text = @"";
    _textFieldReporter.text = @"";
    
    /*
    _textfieldRoofAnchor.text = _configItemsDict[K_OBSERVER_INFO][0][K_NAME];
    _submitDict[K_ROOF_ANCHOR] = _configItemsDict[K_OBSERVER_INFO][0][K_ID];
    _textFieldAheadHole.text = _configItemsDict[K_OBSERVER_INFO][0][K_NAME];
    _submitDict[K_AHEAD_HOLE] = _configItemsDict[K_OBSERVER_INFO][0][K_ID];
    _textFieldTunnelInfo.text = _configItemsDict[K_OBSERVER_INFO][0][K_NAME];
    _submitDict[K_TUNNEL_INFO] = _configItemsDict[K_OBSERVER_INFO][0][K_ID];
    _textFieldReporter.text = _configItemsDict[K_TEAM][K_TEAM_MEMBERS][0][K_NAME];
    _submitDict[K_REPORTER_ID] = _configItemsDict[K_TEAM][K_TEAM_MEMBERS][0][K_ID];
    */
    if ([self checkConfigIterm:K_TEAM]) {
        _lableTeamValue.text = _configItemsDict[K_TEAM][K_NAME];
        _submitDict[K_TEAM_ID] = _configItemsDict[K_TEAM][K_ID];
    } else {
        [_textFieldReporter setEnabled:NO];
    }
    
    [self drawBarGraph];
    
    [self.tableViewCoalSeam setContentSize:CGSizeMake(280, 185)];
    [self scrollToTopOrBottom:1];
}

-(BOOL)checkConfigIterm:(NSString *)iterm
{
    
    BOOL failed = NO;
    if (_configItemsDict[iterm] == Nil || [_configItemsDict[iterm] isEqual:[NSNull null]]) {
        failed = YES;
    }else {
        if ([_configItemsDict[iterm] isKindOfClass:[NSArray class]] &&
            [_configItemsDict[iterm] count] == 0) {
            failed = YES;
        }
    }
    if (failed) {
        NSString *itermName = [[TLDataCenter shareInstance] infoNameInfoDict][iterm];
        TLAlertView *alertView =  [[TLAlertView alloc] init];
        [alertView showFadeoutViewWithMessage:[NSString stringWithFormat:NSLocalizedString(@"alertConfigWrong", Nil), itermName]];
        return NO;
    }
    return YES;
}

-(BOOL)checkSubmit
{
    BOOL checkOK = YES;
    NSDictionary *infoNameDict = [[TLDataCenter shareInstance] infoNameInfoDict];
    // work surface
    if (_textFieldTitle.text == nil || _textFieldTitle.text.length == 0) {
        TLAlertView *alertView =  [[TLAlertView alloc] init];
        [alertView showFadeoutViewWithMessage:[NSString stringWithFormat:NSLocalizedString(@"submitInfoNull", Nil), infoNameDict[K_WORKING_SUFACES]]];
        checkOK = NO;
        return checkOK;
    }
    // tunnels
    if (_textFieldTunnel.text == nil || _textFieldTunnel.text.length == 0) {
        
        TLAlertView *alertView =  [[TLAlertView alloc] init];
        [alertView showFadeoutViewWithMessage:[NSString stringWithFormat:NSLocalizedString(@"submitInfoNull", Nil), infoNameDict[K_TUNNELS]]];
        checkOK = NO;
        return checkOK;
    }
    // observer point
    if (_textFieldObserverPoint.text == nil || _textFieldObserverPoint.text.length == 0) {
        
        TLAlertView *alertView =  [[TLAlertView alloc] init];
        [alertView showFadeoutViewWithMessage:[NSString stringWithFormat:NSLocalizedString(@"submitInfoNull", Nil),infoNameDict[K_OBSERVER_POINTS]]];
        checkOK = NO;
        return checkOK;
    }
    // observer meter
    if (_textFieldObsvMeter.text == nil || _textFieldObsvMeter.text.length == 0) {
        
        TLAlertView *alertView =  [[TLAlertView alloc] init];
        [alertView showFadeoutViewWithMessage:[NSString stringWithFormat:NSLocalizedString(@"submitInfoNull", Nil),infoNameDict[K_OBSERVER_POINTS]]];
        checkOK = NO;
        return checkOK;
    }
    
    // reporter
    if (_textFieldReporter.text == nil || _textFieldReporter.text.length == 0) {
        
        TLAlertView *alertView =  [[TLAlertView alloc] init];
        [alertView showFadeoutViewWithMessage:[NSString stringWithFormat:NSLocalizedString(@"submitInfoNull", Nil),infoNameDict[K_TEAM_MEMBERS]]];
        checkOK = NO;
        return checkOK;
    }

    // coal seam
    if ([TLDataCenter shareInstance].coalSeamData &&
        [TLDataCenter shareInstance].coalSeamData.count == 3) {
        [_roofArray setArray:[TLDataCenter shareInstance].coalSeamData[0]];
        [_tunnelArray setArray:[TLDataCenter shareInstance].coalSeamData[1]];
        [_floorArray setArray:[TLDataCenter shareInstance].coalSeamData[2]];
        
        checkOK = YES;
    }else {
        TLAlertView *alertView =  [[TLAlertView alloc] init];
        [alertView showFadeoutViewWithMessage:[NSString stringWithFormat:NSLocalizedString(@"submitInfoWrong", Nil), K_STRATUMS]];
        checkOK = NO;
    }
    return checkOK;
}
/*
- (IBAction)editCoalSeamTableAction:(id)sender {
    [self performSegueWithIdentifier:@"ShowCoalSeamTableView" sender:_tableViewCoalSeam];
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowCoalSeamTableView"]) {
        [segue.destinationViewController setValue:self forKey:@"delegate"];
    }else if ([segue.identifier isEqualToString:@"ShowSelectTableView"]) {
        NSDictionary *infoNameDict = [[TLDataCenter shareInstance] infoNameInfoDict];
        if (sender == _textFieldTitle) {
            [segue.destinationViewController setValue:_configItemsDict[K_WORKING_SUFACES] forKey:PROPERTY_DATA_SOURCE];
            [segue.destinationViewController setValue:infoNameDict[K_WORKING_SUFACES] forKey:PROPERTY_TITLE_NAME];
            [segue.destinationViewController setValue:^(NSIndexPath *indexPath){
                if (indexPath == nil) {
                    self.selectedWorkingSuface = [NSDictionary new];
                    [self linkageValueChangedTextField:sender];
                } else {
                    if (![_submitDict[K_SURFACE_ID] isEqual:_configItemsDict[K_WORKING_SUFACES][indexPath.row][K_ID]] ) {
                        self.selectedWorkingSuface = _configItemsDict[K_WORKING_SUFACES][indexPath.row];
                        [self linkageValueChangedTextField:sender];
                    }
                }
                
            } forKey:PROPERTY_SELECTED];
        }else if (sender == _textFieldShift){
            [segue.destinationViewController setValue:_configItemsDict[K_SHIFTS] forKey:PROPERTY_DATA_SOURCE];
            [segue.destinationViewController setValue:infoNameDict[K_SHIFTS] forKey:PROPERTY_TITLE_NAME];
            [segue.destinationViewController setValue:^(NSIndexPath *indexPath){
                if (indexPath == nil) {
                    _textFieldShift.text = @"____";
                    _submitDict[K_SHIFT_ID] = @"";
                }else {
                    if (![_submitDict[K_SHIFT_ID] isEqual:_configItemsDict[K_SHIFTS][indexPath.row][K_ID]] ) {
                        _textFieldShift.text = _configItemsDict[K_SHIFTS][indexPath.row][K_NAME];
                        _submitDict[K_SHIFT_ID] = _configItemsDict[K_SHIFTS][indexPath.row][K_ID];
                    }
                }
            } forKey:PROPERTY_SELECTED];
            
        }else if (sender == _textFieldTunnel){
            [segue.destinationViewController setValue:_selectedWorkingSuface[K_TUNNELS] forKey:PROPERTY_DATA_SOURCE];
            [segue.destinationViewController setValue:infoNameDict[K_TUNNELS] forKey:PROPERTY_TITLE_NAME];
            [segue.destinationViewController setValue:^(NSIndexPath *indexPath){
                if (indexPath == nil) {
                    self.selectedTunnel = [NSDictionary new];
                    [self linkageValueChangedTextField:sender];
                }else{
                    if (_selectedWorkingSuface[K_TUNNELS] == nil ||
                        [ _selectedWorkingSuface[K_TUNNELS] isEqual:[NSNull null]]) {
                        // tunnels is null
                        
                    } else  if (![_submitDict[K_TUNNEL_ID] isEqual:_selectedWorkingSuface[K_TUNNELS][indexPath.row][K_ID]] ) {
                        self.selectedTunnel = _selectedWorkingSuface[K_TUNNELS][indexPath.row];
                        [self linkageValueChangedTextField:sender];
                    }
                }
            } forKey:PROPERTY_SELECTED];
        }else if (sender == _textFieldObserverPoint){
            [segue.destinationViewController setValue:_selectedTunnel[K_OBSERVER_POINTS] forKey:PROPERTY_DATA_SOURCE];
            [segue.destinationViewController setValue:infoNameDict[K_OBSERVER_POINTS] forKey:PROPERTY_TITLE_NAME];
            [segue.destinationViewController setValue:^(NSIndexPath *indexPath){
                if (indexPath == nil) {
                    _textFieldObserverPoint.text = @"";
                    _submitDict[K_POINT_ID] = @"";
                } else {
                    if (![_submitDict[K_POINT_ID] isEqual:_selectedTunnel[K_OBSERVER_POINTS][indexPath.row][K_ID]] ) {
                        _textFieldObserverPoint.text = _selectedTunnel[K_OBSERVER_POINTS][indexPath.row][K_NAME];
                        _submitDict[K_POINT_ID] = _selectedTunnel[K_OBSERVER_POINTS][indexPath.row][K_ID];
                    }
                }
            } forKey:PROPERTY_SELECTED];
        }else if (sender == _textfieldRoofAnchor){
            [segue.destinationViewController setValue:_configItemsDict[K_ROOF_ANCHOR_INFO] forKey:PROPERTY_DATA_SOURCE];
            [segue.destinationViewController setValue:infoNameDict[K_ROOF_ANCHOR_INFO] forKey:PROPERTY_TITLE_NAME];
            [segue.destinationViewController setValue:^(NSIndexPath *indexPath){
                if (![_submitDict[K_ROOF_ANCHOR] isEqual:_configItemsDict[K_ROOF_ANCHOR_INFO][indexPath.row][K_ID]] ) {
                    _textfieldRoofAnchor.text = _configItemsDict[K_ROOF_ANCHOR_INFO][indexPath.row][K_NAME];
                    _submitDict[K_ROOF_ANCHOR] = _configItemsDict[K_ROOF_ANCHOR_INFO][indexPath.row][K_ID];
                    
                }
            } forKey:PROPERTY_SELECTED];
        }else if (sender == _textFieldAheadHole){
                [segue.destinationViewController setValue:_configItemsDict[K_AHEAD_HOLE_INFO] forKey:PROPERTY_DATA_SOURCE];
                [segue.destinationViewController setValue:infoNameDict[K_AHEAD_HOLE_INFO] forKey:PROPERTY_TITLE_NAME];
                [segue.destinationViewController setValue:^(NSIndexPath *indexPath){
                    if (![_submitDict[K_AHEAD_HOLE] isEqual:_configItemsDict[K_AHEAD_HOLE_INFO][indexPath.row][K_ID]] ) {
                        _textFieldAheadHole.text = _configItemsDict[K_AHEAD_HOLE_INFO][indexPath.row][K_NAME];
                        _submitDict[K_AHEAD_HOLE] = _configItemsDict[K_AHEAD_HOLE_INFO][indexPath.row][K_ID];
                        
                    }
                } forKey:PROPERTY_SELECTED];
        }else if (sender == _textFieldTunnelInfo){
            [segue.destinationViewController setValue:_configItemsDict[K_TUNNEL_INFO_INFO] forKey:PROPERTY_DATA_SOURCE];
            [segue.destinationViewController setValue:infoNameDict[K_TUNNEL_INFO_INFO] forKey:PROPERTY_TITLE_NAME];
            [segue.destinationViewController setValue:^(NSIndexPath *indexPath){
                if (![_submitDict[K_TUNNEL_INFO] isEqual:_configItemsDict[K_TUNNEL_INFO_INFO][indexPath.row][K_ID]] ) {
                    _textFieldTunnelInfo.text = _configItemsDict[K_TUNNEL_INFO_INFO][indexPath.row][K_NAME];
                    _submitDict[K_TUNNEL_INFO] = _configItemsDict[K_TUNNEL_INFO_INFO][indexPath.row][K_ID];
                    
                }
            } forKey:PROPERTY_SELECTED];
        }else if (sender == _textFieldReporter){
            [segue.destinationViewController setValue:_configItemsDict[K_TEAM][K_TEAM_MEMBERS] forKey:PROPERTY_DATA_SOURCE];
            [segue.destinationViewController setValue:infoNameDict[K_TEAM_MEMBERS] forKey:PROPERTY_TITLE_NAME];
            [segue.destinationViewController setValue:^(NSIndexPath *indexPath){
                if (![_submitDict[K_REPORTER_ID] isEqual:_configItemsDict[K_TEAM][K_TEAM_MEMBERS][indexPath.row][K_ID]] ) {
                    _textFieldReporter.text = _configItemsDict[K_TEAM][K_TEAM_MEMBERS][indexPath.row][K_NAME];
                    _submitDict[K_REPORTER_ID] = _configItemsDict[K_TEAM][K_TEAM_MEMBERS][indexPath.row][K_ID];
                    
                }
            } forKey:PROPERTY_SELECTED];
        }else if (sender == _textFieldCoalSeamCell){
            [segue.destinationViewController setValue:_configItemsDict[K_STRATUMS] forKey:PROPERTY_DATA_SOURCE];
            [segue.destinationViewController setValue:infoNameDict[K_STRATUMS] forKey:PROPERTY_TITLE_NAME];
            [segue.destinationViewController setValue:^(NSIndexPath *indexPath){
                if (indexPath == nil) {
                    _textFieldCoalSeamCell.text = @"";
                    [TLDataCenter shareInstance].coalSeamData[_selectedIndexPath.section][_selectedIndexPath.row][K_STRATUM_ID] = @"";
                    [TLDataCenter shareInstance].coalSeamData[_selectedIndexPath.section][_selectedIndexPath.row][K_NAME] = @"";
                    [TLDataCenter shareInstance].coalSeamData[_selectedIndexPath.section][_selectedIndexPath.row][K_VALUE] = @"";
                    
                    // draw graph
                    [self finishInputCoalSeamData];

                } else {
                    if (_textFieldCoalSeamCell !=nil && _selectedIndexPath !=nil) {
                        _textFieldCoalSeamCell.text = _configItemsDict[K_STRATUMS][indexPath.row][K_NAME];
                        [TLDataCenter shareInstance].coalSeamData[_selectedIndexPath.section][_selectedIndexPath.row][K_STRATUM_ID] = _configItemsDict[K_STRATUMS][indexPath.row][K_ID];
                        [TLDataCenter shareInstance].coalSeamData[_selectedIndexPath.section][_selectedIndexPath.row][K_STRATUM_IMG] = _configItemsDict[K_STRATUMS][indexPath.row][K_STRATUM_IMG];
                        [TLDataCenter shareInstance].coalSeamData[_selectedIndexPath.section][_selectedIndexPath.row][K_NAME] = _configItemsDict[K_STRATUMS][indexPath.row][K_NAME];
                        // draw graph
                        [self finishInputCoalSeamData];
                        // reset clean
                        self.textFieldCoalSeamCell = Nil;
                        self.selectedIndexPath = nil;
                    }
                }
            } forKey:PROPERTY_SELECTED];
        }
    } else if([segue.identifier isEqualToString:@"PopoverMenu"]) {
        UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
        self.popoverMenu = popoverSegue.popoverController;
        [popoverSegue.destinationViewController setValue:self forKey:@"delegate"];
    } else if ([segue.identifier isEqualToString:@"ShowNotification"])
    {
        [segue.destinationViewController setValue:URL_NOTIFICATION forKey:@"url"];
    } else if ([segue.identifier isEqualToString:@"ShowSearchView"]) {
        
    }
}
- (void)buttonMenuAction:(id)sender {
    [self performSegueWithIdentifier:@"PopoverMenu" sender:Nil];
    
}

- (IBAction)submitAction:(id)sender {

    NSLog(@"submit Dict %@", _submitDict);
    if (![self checkSubmit]) {
        return;
    }
    [TLServiceRequest shareInstance].submitDelegate = self;
    [[TLServiceRequest shareInstance] submitRequest:_submitDict];

}

#pragma mark - Submit request delegate
-(void)submitGeoInfoResponse:(NSDictionary *)response
{
    NSLog(@"submit dict : %@", _submitDict);
    if (response == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Nil
                                                        message:NSLocalizedString(@"submitSuccessful", Nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"reInsertCard", Nil)
                                              otherButtonTitles:NSLocalizedString(@"logout", Nil), nil];
        [alert show];
    } else {
        if (response[K_REQUEST_RESULT_MESSAGE]) {
            TLAlertView *alertView = [[TLAlertView alloc] init];
            [alertView showFadeoutViewWithMessage:response[K_REQUEST_RESULT_MESSAGE]];
        }
    }
    
    
}

#pragma mark - TLCoalSeam Delegate
-(void)finishInputCoalSeamData
{
    [_tableViewCoalSeam reloadData];
    [self drawBarGraph];
}
#pragma  mark PopoverMenu delegate
-(void)dismisPopoverMenuView:(int)actionID
{
    if (_popoverMenu) {
        [_popoverMenu dismissPopoverAnimated:YES];
    }
    switch (actionID) {
        case POPOVER_MAIN_VIEW:
            break;
        case POPOVER_SEARCH_VIEW:
        {
            [self performSegueWithIdentifier:@"ShowSearchView" sender:Nil];
            break;
        }
        case POPOVER_NOTIFICATION:
        {
            [self performSegueWithIdentifier:@"ShowNotification" sender:Nil];
            break;
        }
        case POPOVER_LOGOUT:
        {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            break;
        }
        default:
            break;
    }
}
#pragma mark - TextFieldDelegate 
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _textFieldObsvMeter) {
        return YES;
    }
    
    [self performSegueWithIdentifier:@"ShowSelectTableView" sender:textField];
    /*
    UITableView *comboTable = nil;
    if (textField == _textFieldTitle) {
        comboTable = _comboTableTitle;
        
    }else if (textField == _textFieldShift) {
        comboTable = _comboTableShift;
    }else if (textField == _textFieldTunnel) {
        comboTable = _combolTableTunnel;
    }else if (textField == _textFieldObserverPoint) {
        comboTable = _combolTableObsvPoint;
    }else if (textField == _textfieldRoofAnchor) {
        comboTable = _combolObserverInfos;
    }else if (textField == _textFieldReporter) {
        comboTable = _combolTableReporter;
    }
    
    if (!comboTable) {
        return YES;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=comboTable.frame;
        frame.size.height=200;
        [comboTable setFrame:frame];
        [self.view bringSubviewToFront:comboTable];
    } completion:^(BOOL finished){
    }];
     */
    return NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _textFieldObsvMeter) {
        _submitDict[K_POINT_AHEAD] = textField.text;
    }
    [textField resignFirstResponder];
    return YES;
}

/*
-(void)endSelectedTable:(UITableView *)tableViewb
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=tableViewb.frame;
        frame.size.height=1;
        [tableViewb setFrame:frame];
        
    } completion:^(BOOL finished){
    }];
}
*/

#pragma mark - TableView Delegate 
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array = [[TLDataCenter shareInstance] coalSeamLevelArray];
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    header.text = array[section];
    return header;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == COAL_SEAM_TOP || indexPath.section == COAL_SEAM_MIDDLE) {
        if ((indexPath.row+1) == [[TLDataCenter shareInstance].coalSeamData[indexPath.section] count]) {
            return UITableViewCellEditingStyleInsert;
        } else {
            return UITableViewCellEditingStyleDelete;
        }
    }else {
        if (indexPath.row == 0) {
            return UITableViewCellEditingStyleInsert;
        } else {
            return UITableViewCellEditingStyleDelete;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSMutableDictionary *addDict = [[NSMutableDictionary alloc] init];
        addDict[K_ID]=@"";
        addDict[K_NAME]=@"";
        addDict[K_VALUE]=@"";
        if (indexPath.section == COAL_SEAM_TOP || indexPath.section == COAL_SEAM_MIDDLE) {
            NSMutableArray *coalSeamArray = [TLDataCenter shareInstance].coalSeamData[indexPath.section];
            [coalSeamArray insertObject:addDict atIndex:0];
            [tableView beginUpdates];
            NSArray *rowArray = @[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            [tableView insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
        } else {
            [[TLDataCenter shareInstance].coalSeamData[indexPath.section] addObject:addDict];
            [tableView beginUpdates];
            NSArray *rowArray = @[[NSIndexPath indexPathForRow:[[TLDataCenter shareInstance].coalSeamData[indexPath.section] count]-1 inSection:indexPath.section]];
            [tableView insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
        }
        
    } else if(editingStyle == UITableViewCellEditingStyleDelete) {
        TLCoalSeamCell *cell = (TLCoalSeamCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell.textFieldThick resignFirstResponder];
        [[TLDataCenter shareInstance].coalSeamData[indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
        
        [self finishInputCoalSeamData];
    }
    // scroll
//    [self scrollToFixCoalTable];
}

//-(CGSize)preferredContentSize
//{
//    [_tableViewCoalSeam layoutIfNeeded];
//    return _tableViewCoalSeam.contentSize;
//}

#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [TLDataCenter shareInstance].coalSeamData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[TLDataCenter shareInstance].coalSeamData[section] count];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"TLSubmitCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    NSDictionary *rowData = [TLDataCenter shareInstance].coalSeamData[indexPath.section][indexPath.row];
//    cell.textLabel.font = [UIFont systemFontOfSize:16];
//    if (rowData[K_NAME] == nil || [rowData[K_NAME] length] == 0) {
//        cell.textLabel.text = @"";
//    }else {
//        cell.textLabel.text = [NSString stringWithFormat:@"  %@ 厚 %@ 米", rowData[K_NAME], rowData[K_VALUE]];
//    }
//    
//    return cell;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TLCoalSeamCell";
    TLCoalSeamCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TLCoalSeamCell" owner:self options:nil] lastObject];
    }
    NSDictionary *rowData = [TLDataCenter shareInstance].coalSeamData[indexPath.section][indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.textFieldCoalSeam.text = rowData[K_NAME];
    cell.textFieldThick.text = rowData[K_VALUE];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - TLCoalSeamCellDelegate
- (void)textField:(UITextField *)textField ShouldBeginEditingWithIndexPath:(NSIndexPath *)indexPath
{
    if (textField.tag == TAG_COAL_SEAM_TEXTFIELD) {
        self.selectedIndexPath = indexPath;
        self.textFieldCoalSeamCell = textField;
        [self performSegueWithIdentifier:@"ShowSelectTableView" sender:_textFieldCoalSeamCell];
        
    }else if (textField.tag == TAG_COAL_SEAM_VALUE_TEXTFIELD) {
        [_tableViewCoalSeam scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)textField:(UITextField *)textField DidEndEditingWithIndexPath:(NSIndexPath *)indexPath
{
    if (textField.tag == TAG_COAL_SEAM_VALUE_TEXTFIELD) {
        [TLDataCenter shareInstance].coalSeamData[indexPath.section][indexPath.row][K_VALUE] = textField.text;
        [self finishInputCoalSeamData];
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableViewCoalSeam scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        // 重新填写
        [self setDefaultValue];
    } else {
        // logout
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Bar Graph
#define MIN_METER_VALUE     20
#define HEIGHT_BAR_GRAPH    410
#define GAP_BAR_GRAPH_HEADER    10
-(void)drawBarGraph
{
    for (UIView *subview in _viewBarGraph.subviews) {
        [subview removeFromSuperview];
    }
    
    NSInteger rows = 0;
    NSMutableArray *totalCoalSeamAray = [NSMutableArray new];
    CGFloat sumMeter = 0;
    for (int i = 0; i < [TLDataCenter shareInstance].coalSeamData.count; i++) {
        NSArray *section =  [TLDataCenter shareInstance].coalSeamData[i];
        // total data array
        [totalCoalSeamAray addObjectsFromArray:section];
        // count rows
        rows = section.count + rows;
        for (NSMutableDictionary *dict in section) {
            CGFloat eachMeter = [(NSString *)dict[K_VALUE] floatValue];
            // count total height
            sumMeter = sumMeter + eachMeter;
        }
    }
    // stretch Bar Graph height by table rows
    CGRect frameBarGraph = _viewBarGraph.frame;
    frameBarGraph.size.height = HEIGHT_BAR_GRAPH + ((rows -3)*_tableViewCoalSeam.rowHeight*0.5);
    _viewBarGraph.frame = frameBarGraph;
    // height
    CGFloat totalHeight = frameBarGraph.size.height - 2*GAP_BAR_GRAPH_HEADER;
//    CGFloat totalHeight = HEIGHT_BAR_GRAPH;
    
    CGFloat heightUnit = [self filterMinUnitIterm:totalCoalSeamAray totalHeight:totalHeight sumMeter:sumMeter];
    NSLog(@"heightUnit %f", heightUnit);
    if (isinf(heightUnit)) {
        return;
    }
    // draw elements
    CGFloat sumY = GAP_BAR_GRAPH_HEADER;
    CGFloat xgap = 5;
    CGFloat subWidth = (_viewBarGraph.frame.size.width - 2*xgap)/3.f;
    
    CGFloat roofHeight = 0;
    CGFloat tunnelHeight = 0;
    CGFloat floorHeight = 0;
    
    for (int i = 0; i < [TLDataCenter shareInstance].coalSeamData.count; i++) {
        // section height
        CGFloat sectonHeight = 0;
        for (NSMutableDictionary *dict in [TLDataCenter shareInstance].coalSeamData[i]) {
            
            CGFloat height = [(NSString *)dict[K_VALUE] floatValue]*heightUnit;
            // min value count
            if (height > 0) {
                height = (height >= MIN_METER_VALUE?height:MIN_METER_VALUE);
            }
            CGRect frame = CGRectMake(xgap + subWidth, sumY, subWidth, height);
            NSString *imageName = dict[K_STRATUM_IMG];
            NSLog(@"IMAGE NAME %@", imageName);
            
//            if ([dict[K_STRATUM_ID] isKindOfClass:[NSString class]]) {
//                imageName = dict[K_STRATUM_ID];
//            }else {
//                imageName = [dict[K_STRATUM_ID] stringValue];
//            }
            
            UIImageView *imageCoal = [[UIImageView alloc] initWithFrame:frame];
            [imageCoal setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:imageName]]];
            // name label
            CGRect nameLabelFrame = CGRectMake(xgap + subWidth*2, sumY, subWidth, height);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
            nameLabel.text = dict[K_NAME];
            nameLabel.adjustsFontSizeToFitWidth = YES;
            // line label
            CGRect nameLineFrame = CGRectMake(0, height - 3, subWidth, 1);
            UILabel *nameLine = [[UILabel alloc] initWithFrame:nameLineFrame];
            [nameLine setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
            // TODO: add name line label
//            [nameLabel addSubview:nameLine];
            
            // meter label
            CGRect meterLabelFrame = CGRectMake(xgap + subWidth/2.f, sumY, subWidth/2.f, height);
            UILabel *meterLabel = [[UILabel alloc] initWithFrame:meterLabelFrame];
            meterLabel.numberOfLines = 2;
            meterLabel.adjustsFontSizeToFitWidth = YES;
            NSString *meterValue = [NSString stringWithFormat:@"%@\n米", dict[K_VALUE]];
            meterLabel.text = meterValue;
            meterLabel.textAlignment = NSTextAlignmentCenter;
            // brace image
            CGRect braceFrame = CGRectMake(subWidth*3/8, 0, subWidth/8, height);
            UIImageView *braceImageView = [[UIImageView alloc] initWithFrame:braceFrame];
            [braceImageView setImage:[UIImage imageNamed:@"brace"]];
            [meterLabel addSubview:braceImageView];
            
            [_viewBarGraph addSubview:meterLabel];
            [_viewBarGraph addSubview:imageCoal];
            [_viewBarGraph addSubview:nameLabel];
            sumY = sumY + height;
            sectonHeight = sectonHeight + height;
        }
        if (sectonHeight == 0) {
            continue;
        }
 
        switch (i) {
            case 0:
            {
                // roof view
                roofHeight = sectonHeight;
                // min value count
                if (roofHeight > 0) {
                    roofHeight = (roofHeight >= MIN_METER_VALUE?roofHeight:MIN_METER_VALUE);
                }
                CGRect roofFrame = CGRectMake(xgap, GAP_BAR_GRAPH_HEADER, subWidth/2.f, roofHeight);
                UILabel *roofLable = [[UILabel alloc] initWithFrame:roofFrame];
                roofLable.text = [TLDataCenter shareInstance].coalSeamLevelArray[0];
                
                CGRect roofLineFrame = CGRectMake(xgap, GAP_BAR_GRAPH_HEADER + roofHeight, subWidth*3.f, 2);
                UILabel *roofLine = [[UILabel alloc] initWithFrame:roofLineFrame];
                [roofLine setBackgroundColor:[UIColor grayColor]];
                [_viewBarGraph addSubview:roofLable];
                [_viewBarGraph addSubview:roofLine];
                break;

            }
            case 1:
            {
                tunnelHeight = sectonHeight;
                // min value count
                if (tunnelHeight > 0) {
                    tunnelHeight = (tunnelHeight >= MIN_METER_VALUE?tunnelHeight:MIN_METER_VALUE);
                }
                CGRect tunnelFrame = CGRectMake(xgap, GAP_BAR_GRAPH_HEADER + roofHeight, subWidth/2.f, tunnelHeight);
                UILabel *tunnelLable = [[UILabel alloc] initWithFrame:tunnelFrame];
                tunnelLable.text = [TLDataCenter shareInstance].coalSeamLevelArray[1];
                
                CGRect tunneLineFrame = CGRectMake(xgap, GAP_BAR_GRAPH_HEADER + roofHeight + tunnelHeight, subWidth*3.f, 2);
                UILabel *tunnelLine = [[UILabel alloc] initWithFrame:tunneLineFrame];
                [tunnelLine setBackgroundColor:[UIColor grayColor]];
                [_viewBarGraph addSubview:tunnelLable];
                [_viewBarGraph addSubview:tunnelLine];
                break;
            }
            case 2:
            {
                floorHeight = sectonHeight;
                // min value count
                if (floorHeight > 0) {
                    floorHeight = (floorHeight >= MIN_METER_VALUE?floorHeight:MIN_METER_VALUE);
                }
                CGRect floorFrame = CGRectMake(xgap, GAP_BAR_GRAPH_HEADER + roofHeight + tunnelHeight, subWidth/2.f, floorHeight);
                UILabel *floorLable = [[UILabel alloc] initWithFrame:floorFrame];
                floorLable.text = [TLDataCenter shareInstance].coalSeamLevelArray[2];
                [_viewBarGraph addSubview:floorLable];
                break;
            }
            default:
                break;
        }
    }
}
// filter minvalue
-(CGFloat)filterMinUnitIterm:(NSMutableArray *)iterms totalHeight:(CGFloat)totalHeight sumMeter:(CGFloat)sumMeter
{
    NSMutableArray *willRemoveArray = [NSMutableArray new];
    CGFloat heightUnit = totalHeight/sumMeter;
    for (NSMutableDictionary *dict in iterms) {
        CGFloat eachMeter = [(NSString *)dict[K_VALUE] floatValue];
        CGFloat eachHeight = eachMeter * heightUnit;
        if (eachHeight < MIN_METER_VALUE) {
            totalHeight = totalHeight - MIN_METER_VALUE;
            sumMeter = sumMeter - eachMeter;
            [willRemoveArray addObject:dict];
        }
    }
    if (willRemoveArray.count > 0) {
        NSLog(@"willRemoveArray %@", willRemoveArray);
        [iterms removeObjectsInArray:willRemoveArray];
        return [self filterMinUnitIterm:iterms totalHeight:totalHeight sumMeter:sumMeter];
    }else {
        return heightUnit;
    }
}

#pragma mark - self method
-(void)setBarGraphView
{
    for (UIView *subview in _viewBarGraph.subviews) {
        [subview removeFromSuperview];
    }
    CGFloat headerGap = 10;
    CGFloat xgap = 5;
    CGFloat subWidth = (_viewBarGraph.frame.size.width - 2*xgap)/3.f;
    CGFloat bargraphHeight = _viewBarGraph.frame.size.height - 2*headerGap;
    
    CGFloat roofSum = 0;
    CGFloat tunnelSum = 0;
    CGFloat floorfSum = 0;
    CGFloat bargraphSum = 0;
    for (int i = 0; i < [TLDataCenter shareInstance].coalSeamData.count; i++) {
        CGFloat sum = 0;
        for (NSMutableDictionary *dict in [TLDataCenter shareInstance].coalSeamData[i]) {
            sum = [(NSString *)dict[K_VALUE] floatValue] + sum;
        }
        switch (i) {
            case 0:
                roofSum = sum;
                break;
            case 1:
                tunnelSum = sum;
                break;
            case 2:
                floorfSum = sum;
                break;
            default:
                break;
        }
    }
    bargraphSum = roofSum + tunnelSum + floorfSum;
    
    if (bargraphSum == 0) {
        return;
    }
    
    CGFloat roofHeight = roofSum/bargraphSum * bargraphHeight;
    // min value count
    if (roofHeight > 0) {
        roofHeight = (roofHeight >= MIN_METER_VALUE?roofHeight:MIN_METER_VALUE);
    }
    CGRect roofFrame = CGRectMake(xgap, headerGap, subWidth/2.f, roofHeight);
    UILabel *roofLable = [[UILabel alloc] initWithFrame:roofFrame];
    roofLable.text = [TLDataCenter shareInstance].coalSeamLevelArray[0];
    
    CGRect roofLineFrame = CGRectMake(xgap, headerGap + roofHeight, subWidth*3.f, 2);
    UILabel *roofLine = [[UILabel alloc] initWithFrame:roofLineFrame];
    [roofLine setBackgroundColor:[UIColor grayColor]];
    
    CGFloat tunnelHeight = tunnelSum/bargraphSum * bargraphHeight;
    // min value count
    if (tunnelHeight > 0) {
        tunnelHeight = (tunnelHeight >= MIN_METER_VALUE?tunnelHeight:MIN_METER_VALUE);
    }
    CGRect tunnelFrame = CGRectMake(xgap, headerGap + roofHeight, subWidth/2.f, tunnelHeight);
    UILabel *tunnelLable = [[UILabel alloc] initWithFrame:tunnelFrame];
    tunnelLable.text = [TLDataCenter shareInstance].coalSeamLevelArray[1];

    CGRect tunneLineFrame = CGRectMake(xgap, headerGap + roofHeight + tunnelHeight, subWidth*3.f, 2);
    UILabel *tunnelLine = [[UILabel alloc] initWithFrame:tunneLineFrame];
    [tunnelLine setBackgroundColor:[UIColor grayColor]];

    
    CGFloat floorHeight = floorfSum/bargraphSum * bargraphHeight;
    // min value count
    if (floorHeight > 0) {
        floorHeight = (floorHeight >= MIN_METER_VALUE?floorHeight:MIN_METER_VALUE);
    }
    CGRect floorFrame = CGRectMake(xgap, headerGap + roofHeight + tunnelHeight, subWidth/2.f, floorHeight);
    UILabel *floorLable = [[UILabel alloc] initWithFrame:floorFrame];
    floorLable.text = [TLDataCenter shareInstance].coalSeamLevelArray[2];
    
    [_viewBarGraph addSubview:roofLable];
    [_viewBarGraph addSubview:roofLine];
    [_viewBarGraph addSubview:tunnelLable];
    [_viewBarGraph addSubview:tunnelLine];
    [_viewBarGraph addSubview:floorLable];
    
    CGFloat sumY = headerGap;
    
    for (int i = 0; i < [TLDataCenter shareInstance].coalSeamData.count; i++) {
        CGFloat heightUnit = 0;
        switch (i) {
            case 0:
                if (roofSum != 0) {
                    heightUnit = roofHeight/roofSum;
                }
                break;
            case 1:
                if (tunnelSum != 0) {
                    heightUnit = tunnelHeight/tunnelSum;
                }
                break;
            case 2:
                if (floorfSum != 0) {
                    heightUnit = floorHeight/floorfSum;
                }
                break;
            default:
                break;
        }
        
        
        for (NSMutableDictionary *dict in [TLDataCenter shareInstance].coalSeamData[i]) {
            
            CGFloat height = [(NSString *)dict[K_VALUE] floatValue]*heightUnit;
            // min value count
            if (height > 0) {
                height = (height >= MIN_METER_VALUE?height:MIN_METER_VALUE);
            }
            
            
            CGRect frame = CGRectMake(xgap + subWidth, sumY, subWidth, height);
            NSString *imageName = @"";
            if ([dict[K_STRATUM_ID] isKindOfClass:[NSString class]]) {
                imageName = dict[K_STRATUM_ID];
            }else {
                imageName = [dict[K_STRATUM_ID] stringValue];
            }
            UIImageView *imageCoal = [[UIImageView alloc] initWithFrame:frame];
            [imageCoal setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:imageName]]];
            // name label
            CGRect nameLabelFrame = CGRectMake(xgap + subWidth*2, sumY, subWidth, height);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
            nameLabel.text = dict[K_NAME];
            nameLabel.adjustsFontSizeToFitWidth = YES;
            
            // meter label
            CGRect meterLabelFrame = CGRectMake(xgap + subWidth/2.f, sumY, subWidth/2.f, height);
            UILabel *meterLabel = [[UILabel alloc] initWithFrame:meterLabelFrame];
            meterLabel.numberOfLines = 2;
            meterLabel.adjustsFontSizeToFitWidth = YES;
            NSString *meterValue = [NSString stringWithFormat:@"%@\n米", dict[K_VALUE]];
            meterLabel.text = meterValue;
            meterLabel.textAlignment = NSTextAlignmentCenter;
            CGRect braceFrame = CGRectMake(subWidth*3/8, 0, subWidth/8, height);
            UIImageView *braceImageView = [[UIImageView alloc] initWithFrame:braceFrame];
            [braceImageView setImage:[UIImage imageNamed:@"brace"]];
            [meterLabel addSubview:braceImageView];
            
            [_viewBarGraph addSubview:meterLabel];
            [_viewBarGraph addSubview:imageCoal];
            [_viewBarGraph addSubview:nameLabel];
            sumY = sumY + height;
            
        }
    }

}
/*
 
 NSString *roofName = [NSString stringWithFormat:@"%@\n%.2f米",
 [TLDataCenter shareInstance].coalSeamLevelArray[0],
 roofSum];
 roofLable.text = roofName;
 roofLable.numberOfLines = 2;
 roofLable.adjustsFontSizeToFitWidth = YES;

 
 CGRect braceFrame = CGRectMake(subWidth*3/4, 0, subWidth/4, roofHeight);
 UIImageView *braceImageView = [[UIImageView alloc] initWithFrame:braceFrame];
 [braceImageView setImage:[UIImage imageNamed:@"brace"]];
 [roofLable addSubview:braceImageView];
 */

// 1 top 0 bottom
- (void)scrollToTopOrBottom:(NSInteger)top
{
    CGPoint topPoint = CGPointMake(0, 0);
    if (!top) {
        topPoint = CGPointMake(0, _scrollViewBase.contentSize.height - _scrollViewBase.bounds.size.height);
    }
    [_scrollViewBase setContentOffset:topPoint animated:YES];
}

-(void)scrollToFixCoalTable
{
    NSLog(@"table contentsize %@" , NSStringFromCGSize(_tableViewCoalSeam.contentSize));
    CGSize csize = _tableViewCoalSeam.contentSize;
    if (csize.height == 0 || csize.height <= 180) {
        return;
    }
    CGFloat offset = _tableViewCoalSeam.contentSize.height - _tableHeight;
    
    if (offset > 0) {
        _tableHeight  = _tableViewCoalSeam.contentSize.height;
        
        CGRect vctframe =  _viewCoalSeam.frame;
        vctframe.size.height = _tableViewCoalSeam.contentSize.height + 50;
        _viewCoalSeam.frame = vctframe;
        
         CGRect tframe = _tableViewCoalSeam.frame;
        tframe.size.height = _tableViewCoalSeam.contentSize.height + 40;
        _tableViewCoalSeam.frame = tframe;
        [_tableViewCoalSeam setContentInset:UIEdgeInsetsMake(0, 0, _tableViewCoalSeam.contentSize.height - 50, 0)];
        
        CGRect vtframe = _viewTunnel.frame;
        vtframe.size.height = _tableViewCoalSeam.contentSize.height + 50;
        _viewTunnel.frame = vtframe;
        
        CGRect lcsframe = _labelCoalSeam.frame;
        lcsframe.size.height = _tableViewCoalSeam.contentSize.height + 50;
        _labelCoalSeam.frame = lcsframe;
        
//        CGRect vbgframe = _viewBarGraph.frame;
//        vbgframe.size.height = _tableViewCoalSeam.contentSize.height + 100;
//        _viewBarGraph.frame = vbgframe;
        
//        _viewBarGraph.center = CGPointMake(_viewBarGraph.center.x, _viewBarGraph.center.y + offset/2);
        
        _viewRoofAnchor.center = CGPointMake(_viewRoofAnchor.center.x, _viewRoofAnchor.center.y +offset);
        _viewAheadHole.center = CGPointMake(_viewAheadHole.center.x, _viewAheadHole.center.y +offset);
        _viewTunnelInfo.center = CGPointMake(_viewTunnelInfo.center.x, _viewTunnelInfo.center.y +offset);
        _viewFooter.center = CGPointMake(_viewFooter.center.x, _viewFooter.center.y +offset);
        _buttonSubmit.center = CGPointMake(_buttonSubmit.center.x, _buttonSubmit.center.y +offset);
        
        CGFloat scontentHeight = _buttonSubmit.frame.origin.y + 100;
        [_scrollViewBase setContentSize:CGSizeMake(_scrollViewBase.frame.size.width, scontentHeight)];
        
        // scroll to bottom
//        [self scrollToTopOrBottom:0];
        
    } else if(offset < -30){
        
        _tableHeight  = _tableViewCoalSeam.contentSize.height;
        /* */
        CGRect vctframe =  _viewCoalSeam.frame;
        CGFloat vctheight = _viewCoalSeam.frame.size.height + offset;
        vctframe.size.height = (vctheight < 252)?252:vctheight;
        _viewCoalSeam.frame = vctframe;
        
        CGRect tframe = _tableViewCoalSeam.frame;
        CGFloat tfheight = _tableViewCoalSeam.frame.size.height + offset;
        tframe.size.height = (tfheight < 252)?252:tfheight;
        _tableViewCoalSeam.frame = tframe;
        [_tableViewCoalSeam setContentInset:UIEdgeInsetsMake(0, 0, _tableViewCoalSeam.contentSize.height - 50, 0)];
        
        CGRect vtframe = _viewTunnel.frame;
        CGFloat vtHeiht = _viewTunnel.frame.size.height + offset + 10;
        vtframe.size.height = (vtHeiht < 252)?252:vtHeiht;
        _viewTunnel.frame = vtframe;
        
        CGRect lcsframe = _labelCoalSeam.frame;
        CGFloat lcsHeight = _labelCoalSeam.frame.size.height + offset;
        lcsframe.size.height = (lcsHeight < 252)?252:lcsHeight;
        _labelCoalSeam.frame = lcsframe;
        
        _viewRoofAnchor.center = CGPointMake(_viewRoofAnchor.center.x, _viewRoofAnchor.center.y +offset);
        _viewAheadHole.center = CGPointMake(_viewAheadHole.center.x, _viewAheadHole.center.y +offset);
        _viewTunnelInfo.center = CGPointMake(_viewTunnelInfo.center.x, _viewTunnelInfo.center.y +offset);
        _viewFooter.center = CGPointMake(_viewFooter.center.x, _viewFooter.center.y +offset);
        _buttonSubmit.center = CGPointMake(_buttonSubmit.center.x, _buttonSubmit.center.y +offset);
        
        CGFloat scontentHeight = _buttonSubmit.frame.origin.y + 100;
        [_scrollViewBase setContentSize:CGSizeMake(_scrollViewBase.frame.size.width, scontentHeight)];
        
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        // Do something
        [self scrollToFixCoalTable];
    }
}
-(void)dealloc
{
    [_tableViewCoalSeam removeObserver:self forKeyPath:@"contentSize"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
