//
//  HSGHMsgTableViewCell.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHMsgTableViewCell.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHTools.h"
#import "HSGHZoneVC.h"
#import "NSAttributedString+YYText.h"
#import "YYText.h"

#import "AppDelegate.h"

@interface YYTextMatchBindingParserTwo ()
@property(nonatomic, strong) NSRegularExpression *regex;
@end

@implementation YYTextMatchBindingParserTwo
- (instancetype)init {
  self = [super init];
  NSString *pattern = @"@([^<>]*)<([^<>]*)>"; //(.)* 任意字符
  self.regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                    options:kNilOptions
                                                      error:nil];
  return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text
    selectedRange:(NSRangePointer)range {
  __block BOOL changed = NO;
  NSMutableAttributedString *changeText =
      [[NSMutableAttributedString alloc] initWithAttributedString:text];

  __block NSInteger increaseLength = 0;
  [_regex
      enumerateMatchesInString:changeText.string
                       options:NSMatchingWithoutAnchoringBounds
                         range:changeText.yy_rangeOfAll
                    usingBlock:^(NSTextCheckingResult *result,
                                 NSMatchingFlags flags, BOOL *stop) {
                      if (result) {
                        NSRange innerRange = result.range;
                        if (innerRange.location == NSNotFound ||
                            innerRange.length < 1)
                          return;

                        // Find
                        NSString *subStr =
                            [changeText.string substringWithRange:innerRange];
                        NSRange subRange = [subStr rangeOfString:@"<"];
                        if (subRange.location != NSNotFound) {
                          NSString *userId = [subStr
                              substringWithRange:NSMakeRange(
                                                     subRange.location + 1,
                                                     subStr.length -
                                                         subRange.location - 1 -
                                                         1)];
                          [text replaceCharactersInRange:
                                    NSMakeRange(
                                        innerRange.location + increaseLength +
                                            subRange.location,
                                        subStr.length - subRange.location)
                                              withString:@" "];
                          NSRange changeRange =
                              NSMakeRange(innerRange.location + increaseLength,
                                          subRange.location);
                          [text yy_setTextHighlightRange:changeRange
                                                   color:HEXRGBCOLOR(0x3897f0)
                                         backgroundColor:text.yy_color
                                               tapAction:^(
                                                   UIView *containerView,
                                                   NSAttributedString *text,
                                                   NSRange range, CGRect rect) {
                                                 [HSGHZoneVC
                                                     enterOtherZone:userId];
                                               }];
                          [text yy_setFont:[UIFont boldSystemFontOfSize:14.f]
                                     range:changeRange];
                          increaseLength -=
                              subStr.length - subRange.location - 1;
                          changed = YES;
                        }
                      }
                    }];
  return changed;
}

@end

@interface HSGHMsgTableViewCell () <UIAlertViewDelegate> {
  HSGHSingleMsg *_msg;
}
@end

@implementation HSGHMsgTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  self.friendIconBtn.layer.cornerRadius = 15;
  self.friendIconBtn.layer.masksToBounds = YES;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.bgView.layer.borderWidth = 0.5;
  self.bgView.layer.borderColor = [[UIColor colorWithRed:188 / 255.0
                                                   green:188 / 255.0
                                                    blue:188 / 255.0
                                                   alpha:1] CGColor];
  self.bgView.layer.cornerRadius = 18;
  self.bgView.layer.masksToBounds = YES;
  //    self.titleWidth.constant = [HSGHTools widthOfString:self.friendName.text
  //    font:self.friendName.font height:17];
  _commentLab = [[YYLabel alloc] init];
  [self.commentLabbg addSubview:self.commentLab];
  _commentLab.numberOfLines = 0;
  _commentLab.textAlignment = NSTextAlignmentLeft;

  [_commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(_commentLabbg);
    make.top.mas_equalTo(_commentLabbg);
    make.bottom.mas_equalTo(_commentLabbg);
    make.right.mas_equalTo(_commentLabbg);
  }];
  _commentLab.textParser = [YYTextMatchBindingParserTwo new];
  _commentLab.font = self.commentLabbg.font;
  _commentLab.textColor = self.commentLabbg.textColor;

  UILongPressGestureRecognizer *longPressGr =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(longPressToDo:)];
  longPressGr.minimumPressDuration = 1.0;
  [self.contentView addGestureRecognizer:longPressGr];
  self.contentView.userInteractionEnabled = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void)longPressToDo:(UILongPressGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    // end
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"删除此条消息？"
                               delegate:self
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:@"取消", nil] show];
  } else if (recognizer.state == UIGestureRecognizerStateEnded) {
  }
}
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [[AppDelegate instanceApplication] indicatorShow];
    [HSGHMessageModel fetchRemoveWithMessageId: _msg.messageId:^(BOOL success) {
        [[AppDelegate instanceApplication]indicatorDismiss];
            if(success == YES){
                
                                if(_block){
                                    self.block(1000);
                                }
                            }else{
                                
                                [[[UIAlertView alloc] initWithTitle:@"" message:@"删除失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                            }
        }];
  }
}

- (void)updateInfo:(HSGHSingleMsg *)singleMsg {
  _msg = singleMsg;
  if (singleMsg.user.picture.thumbUrl) {

    [_friendIconBtn
        sd_setBackgroundImageWithURL:[NSURL URLWithString:singleMsg.user.picture
                                                              .thumbUrl]
                            forState:UIControlStateNormal
                    placeholderImage:[[UIImage imageNamed:@"usernone"]
                                         imageWithRenderingMode:
                                             UIImageRenderingModeAlwaysOriginal]

                             options:SDWebImageAllowInvalidSSLCertificates
                           completed:^(UIImage *image, NSError *error,
                                       SDImageCacheType cacheType,
                                       NSURL *imageURL) {
                             if (image) {
                               _friendIconBtn.imageView.image = [image
                                   imageWithRenderingMode:
                                       UIImageRenderingModeAlwaysOriginal];
                             }
                           }];
  }

  [_friendIconBtn addTarget:self
                     action:@selector(goin:)
           forControlEvents:UIControlEventTouchUpInside];

  _friendName.text =
      singleMsg.user.displayName ? singleMsg.user.displayName : @"匿名";
  _friendUniversity.text =
      singleMsg.user.unvi.name ? singleMsg.user.unvi.name : @"";
  if (singleMsg.user.displayName != nil &&
      ![singleMsg.user.displayName isEqualToString:@""]) {
    [_universityImage
        sd_setImageWithURL:[NSURL URLWithString:singleMsg.user.unvi.iconUrl]
          placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"]
                   options:SDWebImageAllowInvalidSSLCertificates];
    self.universityHeight.constant = 17;
    self.universityImage.hidden = NO;
    self.friendUniversity.hidden = NO;
  } else {
    self.universityHeight.constant = 0;
    self.universityImage.hidden = YES;
    self.friendUniversity.hidden = YES;
    [_friendIconBtn
        setBackgroundImage:
            [[UIImage imageNamed:@"anoicon"]
                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                  forState:UIControlStateNormal];
  }
  NSString *infoString = @"";
    
//  switch (singleMsg.type) {//
//  case 1:
//    infoString = @"新鲜事中评论: ";
//    infoString = [NSString stringWithFormat:@"新鲜事中评论: %@", singleMsg.contentPart];
//    break;
//  case 2:
//    infoString = [NSString stringWithFormat:@"评论中回复: %@", singleMsg.contentPart];
//    break;
//  case 5:
//    infoString = @"新鲜事中@了你";
//    break;
//  case 6:
//    infoString = @"评论中@了你";
//    break;
//  case 3:
//    infoString = @"赞了你的新鲜事";
//    break;
//  case 4:
//    infoString = @"赞了你的评论";
//    break;
//
//  default:
//    break;
//  }
    
    switch (singleMsg.type) {//
        case 1:
            infoString = @"新鲜事中@了你";
            break;
        case 2:
            infoString = @"赞了你的新鲜事";
            break;
        case 3:
            infoString = [NSString stringWithFormat:@"新鲜事中评论: %@", singleMsg.contentPart];
            break;
        case 4:
            infoString = @"转发了您的新鲜事";
            break;
        default:
            break;
    }
    
  _commentLab.text = [NSString stringWithFormat:@"%@", infoString];
  //设置已读和未读
  if ([singleMsg.read integerValue] == true) {
    _commentLab.textColor = HEXRGBCOLOR(0xa5a5a5);
    _friendName.textColor = HEXRGBCOLOR(0xa5a5a5);
    _friendUniversity.textColor = HEXRGBCOLOR(0xa5a5a5);
    self.contentView.backgroundColor = HEXRGBCOLOR(0xF9F9F9);
  } else {
    _commentLab.textColor = HEXRGBCOLOR(0x272727);
    _friendName.textColor = HEXRGBCOLOR(0x272727);
    _friendUniversity.textColor = HEXRGBCOLOR(0x747474);
    self.contentView.backgroundColor = [UIColor whiteColor];
  }
}

- (void)goin:(UIButton *)button {

  [HSGHZoneVC enterOtherZone:_msg.user.userId];
}

@end
