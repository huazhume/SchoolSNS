//
//  HSGHFriendFirstHeaderView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendFirstHeaderView.h"

@interface HSGHFriendFirstHeaderView ()<UITextFieldDelegate>



@end

@implementation HSGHFriendFirstHeaderView

-(void)awakeFromNib{
  [super awakeFromNib];

  [self.searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  self.closeBtn.hidden = YES;
  self.searchTF.returnKeyType = UIReturnKeySearch;
}

- (IBAction)closeBtnClicked:(id)sender {
  self.searchTF.text = @"";
  [self.searchTF resignFirstResponder];
  [self.searchTF endEditing:YES];
  [self textFieldDidChange:self.searchTF];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        if(_searchBlock){
            self.searchBlock(string);
        }
        return NO;
    }
    
  return YES;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 2, 1);
    
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 2, 1);
    
}
-(void)textFieldDidChange :(UITextField *)textField{
  self.block(textField.text);
  if([textField.text isEqualToString:@""]){
    self.closeBtn.hidden = YES;
  }else{
    self.closeBtn.hidden = NO;
  }
  
}


@end
