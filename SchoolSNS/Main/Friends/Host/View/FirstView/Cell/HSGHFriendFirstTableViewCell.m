//
//  HSGHFriendFirstTableViewCell.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendFirstTableViewCell.h"
#import "HSGHFriendViewModel.h"
#import "HSGHZoneVC.h"
#import "HSGHTools.h"
#import "AppDelegate.h"

@interface HSGHFriendFirstTableViewCell()<UIAlertViewDelegate>
@property (nonatomic, copy) NSString* userID;
@end
@interface HSGHFriendFirstTableViewCell ()
{
    FRINED_CATE_TYPE  _type;
}
@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@property (weak, nonatomic) IBOutlet UIButton *addingBtn;

@end

@implementation HSGHFriendFirstTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.friendIconBtn.layer.cornerRadius = 17;
    self.friendIconBtn.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [[UIColor colorWithRed:188 / 255.0 green:188 / 255.0 blue:188 / 255.0 alpha:1] CGColor];
    self.bgView.layer.cornerRadius = 19;
    self.bgView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.uniHeight.constant = [HSGHTools getWidthWidthString:self.friendUniversity.text font:self.friendUniversity.font width:HSGH_SCREEN_WIDTH - 96].height + 4;
    
    self.contentHeight.constant = [HSGHTools getWidthWidthString:self.friendUniversity.text font:self.friendUniversity.font width:HSGH_SCREEN_WIDTH - 96].height + 10;
    UILongPressGestureRecognizer* longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.contentView addGestureRecognizer:longPressGr];
    self.contentView.userInteractionEnabled = YES;
}
- (void)changeWordSpaceForLabel:(UILabel*)label WithSpace:(float)space
{
    
    NSString* labelText = label.text;
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{ NSKernAttributeName : @(space) }];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}
- (IBAction)clickHeadIcon:(id)sender {
    [HSGHZoneVC enterOtherZone:_userID];
}
- (void)longPressToDo:(UILongPressGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        HSLog(@"longPressToDo");
        
        if (_type==FRIEND_CATE_MEDAO) {//加我界面进来
            if (self.ignoreBackblock) {
                self.ignoreBackblock();//忽略加我
            }
        } else {
            if (self.yuanQiBackblock) {
                self.yuanQiBackblock();
            }
        }
    }
    
    
//    if(_type != FRIEND_CATE_OTHER){
//        if (recognizer.state == UIGestureRecognizerStateBegan) {
//            //end
//            NSString * string = @"";
//            if (_type == FRIEND_CATE_SEARCH) {
//                string = @"删除此条推荐信息";
//            } else if (_type == FRIEND_CATE_SCHOLL) {
//                string = @"删除此好友";
//            } else if (_type == FRIEND_CATE_MEDAO) {
//                string = @"删除此条好友申请";
//                
//            } else if (_type == FRIEND_CATE_OTHERDAO) {
//                string = @"删除此条添加信息";
//            }
//            [[[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil] show];
//        }else if(recognizer.state == UIGestureRecognizerStateEnded){
//            
//        }
//    }
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    HSLog(@"_____%ld",buttonIndex);
    if(buttonIndex == 0){
        [[AppDelegate instanceApplication]indicatorShow];
        NSString * url = @"";
        if (_type == FRIEND_CATE_SEARCH) {
            url = HSGHServerRecommendFriendRemoveURL;
            
        } else if (_type == FRIEND_CATE_SCHOLL) {
            url = HSGHServerFriendRemoveURL;
        } else if (_type == FRIEND_CATE_MEDAO) {
            url = HSGHServerReceiveOtherFriendRemoveURL;
            
        } else if (_type == FRIEND_CATE_OTHERDAO) {
            url = HSGHServerSendOtherFriendRemoveURL;
        }
        
        [ HSGHFriendViewModel fetchRemoveWithUrl:url Params:@{@"userId":_userID} :^(BOOL success) {
            [[AppDelegate instanceApplication]indicatorDismiss];
            if(success == YES){
                //删除好友成功
                if(_block){
                    self.block(1000);
                }
            }else{
                //删除好友失败
                 [[[UIAlertView alloc] initWithTitle:@"" message:@"删除失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
        }];
    }
}

- (void)setup:(FRINED_CATE_TYPE)type
{
    _type = type;
     self.addLabel.hidden = YES;
    self.addingBtn.hidden = YES;
    self.systemInstLabel.hidden = YES;
    
    if (type == FRIEND_CATE_SEARCH) {

        self.passBtn.hidden = YES;
        self.detailLab.hidden = NO;
        self.timeLab.hidden = YES;
        self.systemInstLabel.hidden = NO;

    } else if (type == FRIEND_CATE_SCHOLL) {
        self.passBtn.hidden = YES;
        self.detailLab.hidden = YES;
        self.timeLab.hidden = NO;
         self.timeLab.hidden = YES;
    } else if (type == FRIEND_CATE_MEDAO) {
        self.passBtn.hidden = NO;
        self.detailLab.hidden = YES;
        self.timeLab.hidden = YES;
        [self.passBtn setImage:[UIImage imageNamed:@"friend_to"] forState:UIControlStateNormal];
        self.addLabel.text = @"待您通过";
          self.addLabel.hidden = NO;

    } else if (type == FRIEND_CATE_OTHERDAO) {
        self.passBtn.hidden = NO;
        self.detailLab.hidden = YES;
        self.timeLab.hidden = YES;
        [self.passBtn setImage:[UIImage imageNamed:@"friend_to"] forState:UIControlStateNormal];
        self.addLabel.hidden = NO;
        self.addLabel.text = @"申请中";
        
    }else{
        self.passBtn.hidden = NO;
        self.detailLab.hidden = YES;
        self.timeLab.hidden = YES;
//        [self.passBtn setImage:[UIImage imageNamed:@"friend_to"] forState:UIControlStateNormal];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)passBtnClicked:(id)sender
{

//    [HSGHFriendViewModel addFriend:@""
//                           replyID:nil
//                             block:^(BOOL success) {
//                                 if (success) {
////                                     if(_type == )
//                                 }
//                             }];
}

- (void)updateInfo:(HSGHFriendSingleModel*)data {
    _model = data;
    _userID = data.userId;
    
    if (_type==FRIEND_CATE_SCHOLL) {
        NSString *fullName = data.fullName ? data.fullName : @"";
        
        if (data.fullNameEn!=nil && ![@"" isEqualToString:data.fullNameEn]) {
            _friendName.text = [NSString stringWithFormat:@"%@ (%@)",fullName,data.fullNameEn];
        } else {
            _friendName.text = fullName;
        }
        
//        NSString *displayName = data.displayName ? data.displayName : @"";
//        if (![fullName isEqualToString:displayName]) {
//            _friendName.text = [NSString stringWithFormat:@"%@ (%@)",displayName,fullName];
//        } else {
//            _friendName.text = displayName;
//        }
        
    } else {
        _friendName.text = data.displayName ? data.displayName : @"";
    }
    
//    if (data.unvi.iconUrl) {
        [_universityImage sd_setImageWithURL:[NSURL URLWithString:data.unvi.iconUrl] placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"] options:SDWebImageAllowInvalidSSLCertificates];
//    }
    _friendUniversity.text = data.unvi.name ? data.unvi.name : @"";
    if (data.picture.thumbUrl) {
        __weak typeof(self) weakSelf = self;
        [_friendIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:data.picture.thumbUrl]
                                            forState:UIControlStateNormal
                                    placeholderImage:[[UIImage imageNamed:@"usernone"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]
                                             options:SDWebImageAllowInvalidSSLCertificates
                                           completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
                                               if (image) {
                                                   weakSelf.friendIconBtn.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                                               }
                                           }];
    }
     self.contentHeight.constant = [HSGHTools getWidthWidthString:self.friendUniversity.text font:self.friendUniversity.font width:HSGH_SCREEN_WIDTH - 96].height + 14;
    HSLog(@"%@", data.status);
}

@end
