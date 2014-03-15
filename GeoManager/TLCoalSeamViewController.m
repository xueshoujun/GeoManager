//
//  TLCoalSeamViewController.m
//  GeoManager
//
//  Created by shoujun xue on 2/27/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLCoalSeamViewController.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "TLConstantClass.h"
#import "TLDataCenter.h"

@interface TLCoalSeamViewController ()

@end

@implementation TLCoalSeamViewController

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
	// Do any additional setup after loading the view.
    
    /*
    if (_dataArrayRoof == nil) {
        _dataArrayRoof = [[NSMutableArray alloc] init];
        // TODO:mock data
        NSDictionary *data_t = @{K_ID:@"", K_NAME: @"", K_VALUE:@""};
        NSMutableDictionary *data = [data_t mutableCopy];
        [_dataArrayRoof addObject:data];
    }
    if (_dataArrayTunnel == nil) {
        // TODO:mock data
        _dataArrayTunnel = [[NSMutableArray alloc] init];
        NSDictionary *data_t = @{K_ID:@"", K_NAME: @"", K_VALUE:@""};
        NSMutableDictionary *data = [data_t mutableCopy];
        [_dataArrayTunnel addObject:data];
    }
    if (_dataArrayFloor == nil) {
        _dataArrayFloor = [[NSMutableArray alloc] init];
        // TODO:mock data
        NSDictionary *data_t = @{K_ID:@"", K_NAME: @"", K_VALUE:@""};
        NSMutableDictionary *data = [data_t mutableCopy];
        [_dataArrayFloor addObject:data];
        
    }
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc] init];
        [self.dataArray addObject:_dataArrayRoof];
        [self.dataArray addObject:_dataArrayTunnel];
        [self.dataArray addObject:_dataArrayFloor];
    }
    */
    _tableViewCoalSeam.delegate = self;
    _tableViewCoalSeam.dataSource = self;
    _tableViewCoalSeam.editing = YES;
    [_tableViewCoalSeam setContentInset:UIEdgeInsetsMake(0, 0, 200, 0)];
    
    __block NSArray *selectArray = @[@{K_ID: @"1", K_NAME:@"煤层"},
                             @{K_ID: @"2", K_NAME:@"泥层"},
                             @{K_ID: @"3", K_NAME:@"灰层"},
                             @{K_ID: @"4", K_NAME:@"煤岩层"},
                             @{K_ID: @"5", K_NAME:@"灰岩层"}];
    [_tableSelectCoalSeam initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return (NSInteger)selectArray.count;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:selectArray[indexPath.row][K_NAME]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (_textFieldCell != nil && _selectedIndexPath !=nil) {
            _textFieldCell.text=cell.lb.text;
            [TLDataCenter shareInstance].coalSeamData[_selectedIndexPath.section][_selectedIndexPath.row][K_ID] = selectArray[indexPath.row][K_ID];
            [TLDataCenter shareInstance].coalSeamData[_selectedIndexPath.section][_selectedIndexPath.row][K_NAME] = selectArray[indexPath.row][K_NAME];
            
            self.selectedIndexPath = nil;
        }
        
        [self endSelectedTable:tableView];
    }];
    [_tableSelectCoalSeam.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tableSelectCoalSeam.layer setBorderWidth:2];
}

- (IBAction)submitAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(finishInputCoalSeamData)]) {
        [_delegate finishInputCoalSeamData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancleAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Delegate 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *addDict = [[NSMutableDictionary alloc] init];
    addDict[K_ID]=@"";
    addDict[K_NAME]=@"";
    addDict[K_VALUE]=@"";
    [[TLDataCenter shareInstance].coalSeamData[indexPath.section] addObject:addDict];
    [tableView beginUpdates];
    NSArray *rowArray = @[[NSIndexPath indexPathForRow:[[TLDataCenter shareInstance].coalSeamData[indexPath.section] count]-1 inSection:indexPath.section]];
    [tableView insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationTop];
    [tableView endUpdates];

}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[TLDataCenter shareInstance].coalSeamData[section] count];
}

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[TLDataCenter shareInstance].coalSeamData count];
}
#pragma mark - TLCoalSeamCellDelegate
- (void)textField:(UITextField *)textField ShouldBeginEditingWithIndexPath:(NSIndexPath *)indexPath
{
    if (textField.tag == TAG_COAL_SEAM_TEXTFIELD) {
        self.selectedIndexPath = indexPath;
        self.textFieldCell = textField;
        CGRect _frame = [textField convertRect:textField.frame toView:self.view];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=_tableSelectCoalSeam.frame;
            frame.origin.x = _frame.origin.x - 6;
            frame.origin.y = _frame.origin.y + _frame.size.height - 6;
            frame.size.width = _frame.size.width;
            frame.size.height=200;
            [_tableSelectCoalSeam setFrame:frame];
            [_tableViewCoalSeam setUserInteractionEnabled:NO];
        } completion:^(BOOL finished){
        }];
    }else if (textField.tag == TAG_COAL_SEAM_VALUE_TEXTFIELD) {
        [_tableViewCoalSeam scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)textField:(UITextField *)textField DidEndEditingWithIndexPath:(NSIndexPath *)indexPath
{
    if (textField.tag == TAG_COAL_SEAM_VALUE_TEXTFIELD) {
        [TLDataCenter shareInstance].coalSeamData[indexPath.section][indexPath.row][K_VALUE] = textField.text;
    }
}

/*
#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == TAG_COAL_SEAM_TEXTFIELD) {
        self.textFieldCell = textField;
        CGRect _frame = [textField convertRect:textField.frame toView:self.view];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=_tableSelectCoalSeam.frame;
            frame.origin.x = _frame.origin.x - 6;
            frame.origin.y = _frame.origin.y + _frame.size.height - 6;
            frame.size.width = _frame.size.width;
            frame.size.height=200;
            [_tableSelectCoalSeam setFrame:frame];
            [_tableViewCoalSeam setUserInteractionEnabled:NO];
        } completion:^(BOOL finished){
        }];
    }
    return NO;
}
*/
-(void)endSelectedTable:(UITableView *)tableViewb
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=tableViewb.frame;
        frame.size.height=0;
        [tableViewb setFrame:frame];
        _textFieldCell = nil;
        _selectedIndexPath = nil;
        [self.tableViewCoalSeam setUserInteractionEnabled:YES];
    } completion:^(BOOL finished){
    }];
}

// Modal Dialog Does Not Dismiss Keyboard
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;// [self.topViewController disablesAutomaticKeyboardDismissal];
}
#pragma mark - dealloc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
