//
//  TLSelectTableView.m
//  GeoManager
//
//  Created by shoujun xue on 3/4/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLSelectTableView.h"
#import "TLConstantClass.h"
#import "TLDataCenter.h"

@interface TLSelectTableView ()

@end

@implementation TLSelectTableView

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - self method
-(void)setDataSource:(NSArray *)dataSource DidSelected:(void(^)(NSIndexPath *indexPath))didSelected
{
    self.didSelectedAtIndex = [didSelected copy];
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
     NSDictionary *infoNameDict = [[TLDataCenter shareInstance] infoNameInfoDict];
    if ([infoNameDict[K_STRATUMS] isEqualToString: _titleName] ) {
        return (_dataSource == Nil)?0:_dataSource.count+1;
    }
    return (_dataSource == Nil)?0:_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row < _dataSource.count) {
        // Configure the cell...
        if ([_dataSource[indexPath.row][K_NAME] isEqual:[NSNull null]]) {
            cell.textLabel.text = @"";
        } else {
            cell.textLabel.text = _dataSource[indexPath.row][K_NAME];
        }
    } else {
        cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        cell.textLabel.text = @"空值";
    }
    
    return cell;
}

#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataSource.count) {
        NSLog(@"selected row %@", _dataSource[indexPath.row]);
        if (_didSelectedAtIndex) {
            _didSelectedAtIndex(indexPath);
        }
    } else {
        if (_didSelectedAtIndex) {
            _didSelectedAtIndex(nil);
        }
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    header.text = _titleName;
    header.font = [UIFont systemFontOfSize:20];
    header.textAlignment = NSTextAlignmentCenter;
    header.backgroundColor = COLOR_BLUE_BG;//[UIColor colorWithRed:0 green:0 blue:0.8 alpha:0.5];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"button_login"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(self.tableView.frame.size.width - 121, 10, 111, 40);
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"取消" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:closeButton];
    [header setUserInteractionEnabled:YES];
    return header;
}
#pragma mark - close
-(void)closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
