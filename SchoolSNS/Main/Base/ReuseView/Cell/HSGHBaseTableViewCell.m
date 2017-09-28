//
//  BFSBaseTableViewCell.m
//  BFSports
//
//  Created by wayne on 16/6/29.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import "HSGHBaseTableViewCell.h"
//#import"UIImageView+WebCache.h"
@implementation HSGHBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier param:(NSDictionary *)param
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.paramDict = param;
        [self setupView];
    }
    
    return self;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];

    }
    return self;
}



- (void)setupView
{
    
}

+ (NSString*)cellIdentifity
{
    return NSStringFromClass(self.class);
}

+ (CGFloat)cellHeight
{
    return  0;
}

- (CGFloat)cellHeight
{
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
