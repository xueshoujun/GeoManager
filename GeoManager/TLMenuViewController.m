//
//  TLMenuViewController.m
//  GeoManager
//
//  Created by shoujun xue on 3/6/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLMenuViewController.h"
#import "TLConstantClass.h"

@interface TLMenuViewController ()
@property(strong, nonatomic)NSMutableArray *dataSource;
@property(strong, nonatomic)NSMutableArray *iconViews;
@end

@implementation TLMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setScrollEnabled:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initTableData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_menu_repeat"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initTableData
{
    self.dataSource = [[NSMutableArray alloc] init];
    NSDictionary *backToMainViewDict = @{K_NAME:@"主页面",
                                         K_VALUE:(^(){
                                             if (_delegate && [_delegate respondsToSelector:@selector(dismisPopoverMenuView:)]) {
                                                 [_delegate dismisPopoverMenuView:POPOVER_MAIN_VIEW];
                                             }
                                         })};
    NSDictionary *searchRowDict = @{K_NAME:@"搜索",
                                         K_VALUE:(^(){
                                             if (_delegate && [_delegate respondsToSelector:@selector(dismisPopoverMenuView:)]) {
                                                 [_delegate dismisPopoverMenuView:POPOVER_SEARCH_VIEW];
                                             }
                                         })};
    NSDictionary *notificationRowDict = @{K_NAME: NSLocalizedString(@"notification", Nil),
                                         K_VALUE:(^(){
                                             if (_delegate && [_delegate respondsToSelector:@selector(dismisPopoverMenuView:)]) {
                                                 [_delegate dismisPopoverMenuView:POPOVER_NOTIFICATION];
                                             }
                                         })};
    NSDictionary *logoutRowDict = @{K_NAME:@"退出",
                                          K_VALUE:(^(){
                                              if (_delegate && [_delegate respondsToSelector:@selector(dismisPopoverMenuView:)]) {
                                                  [_delegate dismisPopoverMenuView:POPOVER_LOGOUT];
                                              }
                                          })};
    [_dataSource addObject:backToMainViewDict];
    [_dataSource addObject:searchRowDict];
    [_dataSource addObject:notificationRowDict];
    [_dataSource addObject:logoutRowDict];
    
    self.iconViews = [NSMutableArray new];
    CGRect iconFrame = CGRectMake(70, 10, 40, 40);
    UIImageView *homePageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_homepage"]];
    homePageIcon.frame = iconFrame;
    UIImageView *notificationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_notification"]];
    notificationIcon.frame = iconFrame;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
    searchIcon.frame = iconFrame;
    [_iconViews addObject:homePageIcon];
    [_iconViews addObject:notificationIcon];
    [_iconViews addObject:searchIcon];
}
#pragma mark - self action
-(void)backAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(dismisPopoverMenuView:)]) {
        [_delegate dismisPopoverMenuView:POPOVER_MAIN_VIEW];
    }
}

-(void)logoutAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(dismisPopoverMenuView:)]) {
        [_delegate dismisPopoverMenuView:POPOVER_LOGOUT];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == _dataSource.count -1) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:24];
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _dataSource[indexPath.row][K_NAME];
    if (indexPath.row < _dataSource.count -1) {
        [cell addSubview:_iconViews[indexPath.row]];
    }else {
        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutButton setImage:[UIImage imageNamed:@"logoutButton"] forState:UIControlStateNormal];
        logoutButton.frame = CGRectMake(20, 120, 270, 40);
        [logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:logoutButton];
        cell.textLabel.text = @"";
    }
    
    return cell;
}
#pragma mark Table view delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80)];
    header.text = @"功能菜单";
    header.font = [UIFont systemFontOfSize:24];
    header.textColor = COLOR_BLUE_TEXT;
    header.textAlignment = NSTextAlignmentCenter;
    header.backgroundColor = [UIColor clearColor];//COLOR_BLUE_BG;//[UIColor grayColor];
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect backButtonFrame = CGRectMake(20, 18, 72, 44);
    [buttonBack setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    buttonBack.frame = backButtonFrame;
    [buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:buttonBack];
    [header setUserInteractionEnabled:YES];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataSource.count -1) {
        return 60;
    }else {
        return 200;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    void(^selectRow)() = _dataSource[indexPath.row][K_VALUE];
    selectRow();
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
