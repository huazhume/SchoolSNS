//
//  HSGHATFriendTableViewCell.m
//  SchoolSNS
//
//  Created by 陈位 on 2017/8/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHATFriendTableViewCell.h"
#import "HSGHFriendViewModel.h"

@interface HSGHATFriendTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selImageV;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *univImageV;
@property (weak, nonatomic) IBOutlet UILabel *univNameLabel;
@property (weak, nonatomic) IBOutlet UIView *BgView;



@end

@implementation HSGHATFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageV.layer.cornerRadius = 17.0;
    self.headImageV.clipsToBounds = YES;
    UIColor *tmpColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
//    self.headImageV.layer.borderColor = [tmpColor CGColor];
//    self.headImageV.layer.borderWidth = 1;
    
    self.BgView.layer.cornerRadius = 19.0;
    self.BgView.clipsToBounds = YES;
    
    self.BgView.layer.borderColor = [tmpColor CGColor];
    self.BgView.layer.borderWidth = 1;
    
    
}

- (void)setModel:(HSGHFriendSingleModel *)model {
    _model = model;
    
    NSString *fullName = model.fullName ? model.fullName : @"";
    
    if (model.fullNameEn!=nil && ![@"" isEqualToString:model.fullNameEn]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",fullName,model.fullNameEn];
    } else {
        self.nameLabel.text = fullName;
    }
    
    
    [self.univImageV sd_setImageWithURL:[NSURL URLWithString:model.unvi.iconUrl] placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"] options:SDWebImageAllowInvalidSSLCertificates];
    self.univNameLabel.text = model.unvi.name ? model.unvi.name : @"";

    
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:model.picture.thumbUrl] placeholderImage:[[UIImage imageNamed:@"usernone"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    
    
    if (model.selected) {
        self.selImageV.image = [UIImage imageNamed:@"AtMulSecect"];
    } else {
        self.selImageV.image = [UIImage imageNamed:@"AtMulUnSecect"];
    }
    
    
}

@end
