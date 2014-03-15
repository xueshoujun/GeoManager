//
//  TLCoalSeamCell.m
//  GeoManager
//
//  Created by shoujun xue on 2/27/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLCoalSeamCell.h"
#import "SelectionCell.h"
#import "TLConstantClass.h"
#import "NumberKeyboard.h"

@implementation TLCoalSeamCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    return self;
}

-(void)awakeFromNib
{
    if (self) {
        _textFieldCoalSeam.delegate = self;
        _textFieldThick.delegate = self;
        _textFieldCoalSeam.tag = TAG_COAL_SEAM_TEXTFIELD;
        _textFieldThick.tag = TAG_COAL_SEAM_VALUE_TEXTFIELD;
        _textFieldThick.returnKeyType = UIReturnKeyDone;
        
        self.keyboard = [[NumberKeyboard alloc] initWithNibName:@"NumberKeyboard" bundle:nil];
        _keyboard.textField = _textFieldThick;
        _keyboard.showsPeriod = YES;
        _textFieldThick.inputView = _keyboard.view;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat offset = 25;
    if (_state == (UITableViewCellStateShowingEditControlMask
                  | UITableViewCellStateShowingDeleteConfirmationMask)) {
        
        CGPoint newCenter =  CGPointMake(self.contentView.center.x - offset, self.contentView.center.y);
        self.contentView.center = newCenter;
        
    }
    /*else  {
        CGPoint newCenter =  CGPointMake(self.contentView.center.x + offset, self.contentView.center.y);
        self.contentView.center = newCenter;
    }*/
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textField:ShouldBeginEditingWithIndexPath:)]) {
        [_delegate textField:textField ShouldBeginEditingWithIndexPath:_indexPath];
    }
    if (textField.tag == TAG_COAL_SEAM_TEXTFIELD) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField.tag == TAG_COAL_SEAM_VALUE_TEXTFIELD) {
//        if (_delegate && [_delegate respondsToSelector:@selector(textField:DidEndEditingWithIndexPath:)]) {
//            [_delegate textField:textField DidEndEditingWithIndexPath:_indexPath];
//        }
//    }
    NSLog(@"textfield input view %@", textField.inputView);
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == TAG_COAL_SEAM_VALUE_TEXTFIELD) {
        if (_delegate && [_delegate respondsToSelector:@selector(textField:DidEndEditingWithIndexPath:)]) {
            [_delegate textField:textField DidEndEditingWithIndexPath:_indexPath];
        }
    }
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)textFieldValueChanged:(id)sender {
    [sender resignFirstResponder];
}

-(void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    self.state = state;
}

//-(void)dealloc
//{
//    [_textFieldThick resignFirstResponder];
//}
@end
