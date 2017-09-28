//
//  HSGHHomeMainCellHeaderView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFirstHeaderView.h"
#import "HSGHZoneVC.h"
#import "HSGHFriendViewModel.h"
#import "UIButton+HSGHFriendModeBtn.h"
#import "HSGHUserInf.h"
#import "AppDelegate.h"

@interface HSGHFirstHeaderView (){
    HSGHHomeQQianModelFrame * _qqianFrame;  
}
@property (weak, nonatomic) IBOutlet UIView* headBack;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* qqianID;
@property (nonatomic,strong)HSGHHomeQQianModel * qqianVo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *universityHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameHeight;


@end

@implementation HSGHFirstHeaderView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [[NSBundle mainBundle] loadNibNamed:@"HSGHFirstHeaderView"
                                  owner:self
                                options:nil];
    self.view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.headBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headBtn addTarget:self action:@selector(clickHead) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.view];
}

- (void)clickHead
{
    if (_block) {
        _block(1000,_userId);
    } else {
        [HSGHZoneVC enterOtherZone:_userId];
    }
}
- (IBAction)clickAddFriend:(id)sender
{
    
    if((_qqianFrame.mode == QQIAN_FRIEND ) && _qqianFrame.friendMode !=FRIEND_CATE_FRIST ){
        
    }else{
        [HSGHFriendViewModel fetchFriendShipWithMode:_qqianVo.friendStatus WithBtn:(UIButton *)sender WithUserID:_qqianVo.creator.userId WithQqianId:_qqianVo.qqianId WithReplayId:nil WithCallBack:^(BOOL success, UIImage *image) {
            if(success){
                self.block(2000,_qqianVo.qqianId);
                [self.addFriendButton setImage:image forState:UIControlStateNormal];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"" message:@"加好友失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
            }
        }WithAddLabel:self.addingLab];
    }
}
- (void)setModelFrame:(HSGHHomeQQianModelFrame*)modelF
{
    _qqianFrame = modelF;
    

    _qqianVo = modelF.model;
    //设置约束   直接用xib中的约束即可
//    CGFloat maxWidth = HSGH_SCREEN_WIDTH - 60;
//    CGFloat nomalWidth = [HSGHTools widthOfString:modelF.model.creator.unvi.name font:self.universityLab.font height:self.universityLab.frame.size.height] + 17 + 5 + 3;
//    if(maxWidth<nomalWidth){
//        CGFloat nomalHeight = [self getLabelHeightString:modelF.model.creator.unvi.name font:self.universityLab.font width:maxWidth];
//        self.uiniBack.constant = maxWidth;
//        self.universityHeight.constant = 25;//nomalHeight;
//    }else{
//        self.uiniBack.constant = nomalWidth;
//        self.universityHeight.constant = 20;
//    }
    
    //设置值
    if(modelF.model.creator.userId == nil || [modelF.model.creator.userId isEqualToString:@""]){
        [self.headBtn setBackgroundImage:[UIImage imageNamed:@"anoicon"] forState:UIControlStateNormal];
        self.addFriendButton.hidden = YES;
        [self.universityIcon sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        self.usernameLab.text = @"";
        self.universityLab.text = @"";
        
    }else{
        self.addFriendButton.hidden = NO;
        if (modelF.model.creator.picture.srcUrl && [modelF.model.creator.picture.srcUrl hasPrefix:@"http"]) {
            __weak typeof(self) weakSelf = self;
        [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:modelF.model.creator.picture.srcUrl]
                                              forState:UIControlStateNormal
                                      placeholderImage:[[UIImage imageNamed:@"usernone"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]
                                               options:SDWebImageAllowInvalidSSLCertificates
                                             completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
                                                 if (image) {
                                                     weakSelf.headBtn.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                                                 }
                                             }];
        } else {
            [self.headBtn setBackgroundImage:[[UIImage imageNamed:modelF.model.creator.picture.srcUrl] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                    forState:UIControlStateNormal];
        }
        [self.universityIcon sd_setImageWithURL:[NSURL URLWithString:modelF.model.creator.unvi.iconUrl] placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"] options:SDWebImageAllowInvalidSSLCertificates];
        self.usernameLab.text = modelF.model.creator.displayName;
        self.universityLab.text = modelF.model.creator.unvi.name;
    }
   
    _userId = modelF.model.creator.userId;
    _qqianID = modelF.model.qqianId;
    [HSGHFriendViewModel fetchAddBtnStateWithCurrentUserId:modelF.model.creator.userId WithOtherId:nil WithQQianMode:modelF.mode FriendMode:modelF.friendMode WithMode:modelF.model.friendStatus WithBtn:self.addFriendButton WithAddLabel:self.addingLab];
    
    //分享 和 加好友不可见
    if(_qqianFrame.mode == QQIAN_FRIEND && (_qqianFrame.friendMode == FRIEND_CATE_THIRD || _qqianFrame.friendMode == FRIEND_CATE_SECOND)){
        self.leftBtn.hidden = YES;
        if([modelF.model.friendStatus integerValue] != 4){
            self.addFriendButton.hidden = YES;
        }
    }else{
        self.leftBtn.hidden = NO;
    }
    if([modelF.model.creator.unvi.name isEqualToString:@""] || modelF.model.creator.unvi.name == nil){
        self.uiniBack.constant = 20;
    }
}
- (IBAction)moreTools:(id)sender {
    if(_block){
        self.block(3000, _qqianID);
    }
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
- (CGFloat)getLabelHeightString:(NSString*)text font:(UIFont*)font width:(CGFloat)width
{
    CGSize contentSize = [text
                          sizeWithFont:font
                          constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    return contentSize.height ;
}


@end
