//
//  HSGHFriendViewCell.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 11/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHFriendViewCell.h"
#import "SDAutoLayout.h"
#import "UIImageView+CornerRadius.h"

@implementation HSGHFriendViewCell {
    UIView *_nameContentView; //For school icon and name v center
    __weak IBOutlet UIImageView *_photoImageView;
    UIImageView *_schoolIconView;
    UILabel *_nameLabel;
}

- (void)prepareForReuse {
    [super prepareForReuse];

}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

}

- (void)setup {
//    [_photoImageView zy_cornerRadiusAdvance:_photoImageView.width / 2.f rectCornerType:UIRectCornerAllCorners];
    _nameContentView = [UIView new];
    _nameContentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_nameContentView];

    _schoolIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _schoolIconView.image = [UIImage imageNamed:@"PreviewImage"];
    [_nameContentView addSubview:_schoolIconView];

    _nameLabel = [UILabel new];
    _nameLabel.textColor = HEXRGBCOLOR(0x272727);
    _nameLabel.font = [UIFont boldSystemFontOfSize:13.f];
    _nameLabel.height = 13.f;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_nameContentView addSubview:_nameLabel];

}

- (void)setHeadImagePath:(NSString *)headImagePath {
    if (![_headImagePath isEqualToString:headImagePath]) {
        _headImagePath = headImagePath;
        [_photoImageView sd_setImageWithURL:[NSURL URLWithString:headImagePath]];
    }
}

- (void)setSchoolIconPath:(NSString *)schoolIconPath {
    if (![_schoolIconPath isEqualToString:schoolIconPath]) {
        _schoolIconPath = schoolIconPath;
        [_schoolIconView sd_setImageWithURL:[NSURL URLWithString:schoolIconPath]
                           placeholderImage:[UIImage imageNamed:@"PreviewImage"]];
    }
}

- (void)setName:(NSString *)name {
    if (![_name isEqualToString:name]) {
        _name = name;
        _nameLabel.text = name;
        //update homeCityAddress
        [_nameLabel sizeToFit];
        if (_nameLabel.width > self.width - _schoolIconView.width) {
            _nameLabel.width = self.width - _schoolIconView.width;
        }
        _nameContentView.width = _nameLabel.width + _schoolIconView.width;
        _nameLabel.left = _schoolIconView.right;
        _nameContentView.top = _photoImageView.bottom + 5.f;
        _nameContentView.left = (self.width - _nameContentView.width) / 2;
        _nameLabel.centerY = _schoolIconView.centerY;
    }
}

@end
