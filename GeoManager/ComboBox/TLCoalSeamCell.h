//
//  TLCoalSeamCell.h
//  GeoManager
//
//  Created by shoujun xue on 2/27/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NumberKeyboard;
@protocol TLCoalSeamCellDelegate <NSObject>
-(void)textField:(UITextField *)textField ShouldBeginEditingWithIndexPath:(NSIndexPath *)indexPath;
-(void)textField:(UITextField *)textField DidEndEditingWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface TLCoalSeamCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldCoalSeam;
@property (weak, nonatomic) IBOutlet UILabel *lablethickness;
@property (weak, nonatomic) IBOutlet UITextField *textFieldThick;
@property (weak, nonatomic) IBOutlet UILabel *labelThicknessUnit;
@property (strong, nonatomic)NumberKeyboard *keyboard;

@property (assign, nonatomic)id<TLCoalSeamCellDelegate>delegate;

@property (strong, nonatomic)NSIndexPath *indexPath;

@property (nonatomic) int state;

@end
