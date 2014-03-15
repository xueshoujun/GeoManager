//
//  TLGroupsTableViewDelegate.m
//  GeoManager
//
//  Created by shoujun xue on 2/24/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLGroupsTableViewDelegate.h"
#import "TLConstantClass.h"
#import "TLLoginViewController.h"

#define K_SELECTED_TEAM     @"Selected_Team"

@implementation TLGroupsTableViewDelegate

-(id)initWithData:(NSArray *)dataSourceIn ParentViewController:(UIViewController *)parentVC
{
    self = [super init];
    if (self) {
        self.dataSource = dataSourceIn;
        self.parentViewController = parentVC;
    }
    return self;
}

-(void)teamButtonAction:(id)sender
{
    UIButton *teamButton = (UIButton *)sender;
    if (_parentViewController) {
        NSDictionary *selectedTeamDict = _dataSource[teamButton.tag];
        [_parentViewController setValue:selectedTeamDict forKey:@"loginTeamDict"];
        _parentViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [_parentViewController performSegueWithIdentifier:@"PresentLoginView" sender:teamButton];
        
//        UIStoryboard *sbMain = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//        UIViewController *loginview = [sbMain instantiateViewControllerWithIdentifier:@"TLLoginViewController"];
//        loginview.view.backgroundColor = [UIColor clearColor];
//        [_parentViewController presentViewController:loginview animated:YES completion:nil];
        
    }
    NSLog(@"button tag %d",teamButton.tag);
}

#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(10, 5, 130, 70);
        [button setTitle:_dataSource[indexPath.row][K_NAME] forState:UIControlStateNormal];
        button.tag = indexPath.row;//[_dataSource[indexPath.row][K_ID] integerValue];
        [button addTarget:self action:@selector(teamButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [UILabel new];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.frame = CGRectMake(10, 5, 130, 70);
    headerLabel.font = [UIFont systemFontOfSize:20];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = self.title;
    headerLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}
@end
