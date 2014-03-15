//
//  TLViewController.m
//  GeoManager
//
//  Created by shoujun xue on 2/21/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLViewController.h"
#import "TLGroupsTableViewDelegate.h"
#import "TLConstantClass.h"
#import "TLSubmitPageViewController.h"
#import "TLServiceRequest.h"
#import "TLGroupCell.h"
#import "TLAlertView.h"
#import "TLDataCenter.h"

#define NUMBER_LINE_BUTTON      3

@interface TLViewController ()
@property(strong, nonatomic)NSMutableArray *delegateArray;
@property(strong, nonatomic)NSArray *groupsArray;

@property(strong, nonatomic)NSMutableArray *groupRowsArray;// for reverse array
@property(strong, nonatomic)NSMutableArray *tableDataArray;

@property(retain, nonatomic)TLAlertView *alertLoading;

@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.labelTitle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_group_title"]];
    self.labelTitle.text = NSLocalizedString(@"groupTeamTitle", Nil);
    
    self.groupsArray = [NSArray new];
    self.tableDataArray = [NSMutableArray new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [TLServiceRequest shareInstance].startDelegate = self;
    [[TLServiceRequest shareInstance] groupRequest:nil];
    [self performSelector:@selector(showLoadingView) withObject:nil afterDelay:2];
}

-(void)showLoadingView
{
    _alertLoading = [[TLAlertView alloc] init];
    [_alertLoading showLoadingView];
}

/*
- (void)layoutButtonTableViewWithData:(NSArray *)groupsArray
{
    self.delegateArray = [[NSMutableArray alloc] init];
    CGFloat orginY = 10;
    CGFloat gapY = 100;
    for (int i = 0; i < groupsArray.count; i++) {
        NSDictionary *group = groupsArray[i];
        CGRect frame = CGRectMake(0, 0, 80, 824);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.transform = CGAffineTransformMakeRotation(0 - M_PI_2);
        orginY = orginY + gapY;
        tableView.center = CGPointMake(512, orginY);
        NSArray *teams = (NSArray *)group[K_TEAMS];
        //         id<UITableViewDataSource, UITableViewDelegate> tableViewDelegate = [[TLGroupsTableViewDelegate alloc] initWithData:teams];
        TLGroupsTableViewDelegate *tableViewDelegate = [[TLGroupsTableViewDelegate alloc] initWithData:teams ParentViewController:self];
        tableViewDelegate.title = group[K_NAME];
        [_delegateArray addObject:tableViewDelegate];
        tableView.dataSource = _delegateArray[i];
        tableView.delegate = _delegateArray[i];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        if (teams.count > 4) {
            tableView.scrollEnabled = YES;
            tableView.alwaysBounceHorizontal = NO;
        }else {
            tableView.scrollEnabled = NO;
            tableView.alwaysBounceVertical = NO;

        }
        [self.view addSubview:tableView];
    }
}
 */

#pragma mark - group request Delegate
-(void)groupResponse:(NSDictionary *)groupResponse
{
    if (_alertLoading) {
        [_alertLoading destroyLoadingView];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLoadingView) object:nil];
    }
     if ([K_REQUEST_RESULT_FAILURE isEqualToString:[groupResponse objectForKey:K_REQUEST_RESULT]]) {
         TLAlertView *alertView = [[TLAlertView alloc] init];
         [alertView showFadeoutViewWithMessage:[groupResponse objectForKey:K_REQUEST_RESULT_MESSAGE]];
         
     } else {
         _groupsArray = groupResponse[@"groups"];
         if (_groupsArray && [_groupsArray count] > 0) {
             [self convertGourpsDataToTableData];
             [_tableView reloadData];
         } else {
             NSDictionary *key_name = [[TLDataCenter shareInstance] infoNameInfoDict];
             TLAlertView *alertView = [[TLAlertView alloc] init];
             NSString *message = [NSString stringWithFormat:NSLocalizedString(@"alertConfigWrong", nil), key_name[K_GROUPS]];
             [alertView showFadeoutViewWithMessage:message];
         }
     }
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PresentLoginView"]) {
        TLLoginViewController * vc = [segue destinationViewController];
        if (_loginTeamDict == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请取消，重新尝试"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            vc.delegate = self;
            [vc setTeamDict:_loginTeamDict];
        }
    }else if ([segue.identifier isEqualToString:@"PushSubmitPage"]) {
        NSLog(@"PushSubmitPage");
        TLSubmitPageViewController *submitController = [segue destinationViewController];
        [submitController setConfigItemsDict:_configItermDict];
    }
}

#pragma mark - login view controller delegate
-(void)loginSucesse:(NSDictionary *)loginResp
{
    self.configItermDict = loginResp;
    if (_configItermDict) {
        [self performSegueWithIdentifier:@"PushSubmitPage" sender:nil];
    }
}
-(void)loginFailure:(NSDictionary *)failureResp
{
    TLAlertView *alertView = [[TLAlertView alloc] init];
    [alertView showFadeoutViewWithMessage:[failureResp objectForKey:K_REQUEST_RESULT_MESSAGE]];
}

#pragma mark - Table View DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNumber = 0;
    for (NSDictionary *group in _groupsArray) {
        NSArray *teams = group[K_TEAMS];
        rowNumber = rowNumber + (teams.count + NUMBER_LINE_BUTTON)/NUMBER_LINE_BUTTON;
    }
    NSLog(@"row number %d, data count %d", rowNumber, _tableDataArray.count);
    return _tableDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"GroupCell";
    TLGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TLGroupCell" owner:self options:nil] lastObject];
    }
    
    NSArray *rowArray = _tableDataArray[indexPath.row];
    for (int i = 0; i < rowArray.count ; i++) {
        NSString *titleName = rowArray[i][K_NAME];
        if (i == 0) {
            if (titleName!= Nil && titleName.length > 0) {
                cell.labelGroupName.hidden = NO;
                cell.labelGroupName.text = titleName;
            }else {
                cell.labelGroupName.hidden = YES;
            }
        }else {
            UIButton *buttonCell = [cell valueForKeyPath:[NSString stringWithFormat:@"buttonTeam_%d", i]];
            [buttonCell addTarget:self action:@selector(teamButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [buttonCell setTitle:titleName forState:UIControlStateNormal];
            [buttonCell setTag:indexPath.row*NUMBER_LINE_BUTTON+i];
            buttonCell.hidden = NO;
        }
    }
    return cell;
}

#pragma mark - Table View Delegate 
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
#pragma mark - self method
-(void) teamButtonAction:(UIButton *)button
{
    self.loginTeamDict = Nil;
    NSLog(@"i:%d,j:%d", button.tag/NUMBER_LINE_BUTTON, button.tag%NUMBER_LINE_BUTTON);
    self.loginTeamDict = _tableDataArray[button.tag/NUMBER_LINE_BUTTON][button.tag%NUMBER_LINE_BUTTON];
    [self performSegueWithIdentifier:@"PresentLoginView" sender:button];
    
}

- (void)convertGourpsDataToTableData
{
    for (NSDictionary *group in _groupsArray) {
        // data in one row
        self.groupRowsArray = [NSMutableArray new];
        NSDictionary *groupTitle = @{K_ID: group[K_ID], K_NAME: group[K_NAME]};
        NSArray *teams = group[K_TEAM_MEMBERS];
        [_groupRowsArray addObject:[self regressionConvertArray:teams GroupTitle:groupTitle]];
        // reverse array data
        [_tableDataArray addObjectsFromArray:[[_groupRowsArray reverseObjectEnumerator] allObjects]];
    }
    NSLog(@"table Array %@", _tableDataArray);
}

-(NSArray *)regressionConvertArray:(NSArray *)dataArray GroupTitle:(NSDictionary *)groupTitle
{
    int teamCount = 0;
    if (dataArray.count > NUMBER_LINE_BUTTON) {
        NSArray *subDataArray = [dataArray subarrayWithRange:NSMakeRange(NUMBER_LINE_BUTTON, dataArray.count- NUMBER_LINE_BUTTON)];
        NSArray *rowArray = [self regressionConvertArray:subDataArray GroupTitle:Nil];
        [_groupRowsArray addObject:rowArray];
        
        teamCount = NUMBER_LINE_BUTTON;
    } else {
        teamCount = dataArray.count;
    }
    NSMutableArray *rowNewArray = [NSMutableArray new];
    
    // add group title in row
    if (groupTitle) {
        [rowNewArray addObject:groupTitle];
    }else {
        NSDictionary *groupBlankTitle = @{K_ID: @"", K_NAME: @""};
        [rowNewArray addObject:groupBlankTitle];
    }
    
    for (int i = 0; i < teamCount; i++) {
        [rowNewArray addObject:dataArray[i]];
    }
    return rowNewArray;
}

#pragma mark - dealloc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
