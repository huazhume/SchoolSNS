//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHSchoolView.h"
#import "UILabel+UILabel_VerticalAlign.h"
#import "HSGHTools.h"
#import "AppDelegate.h"
#import "SchoolSNS-Swift.h"


@implementation HSGHSchoolView {

    __weak IBOutlet UIImageView *_schoolIconImageView;
    __weak IBOutlet VerticallyAlignedLabel *_universityInfoLabel;
    
    __weak IBOutlet UILabel *_cityLabel;
    __weak IBOutlet NSLayoutConstraint *_cityLabelWidthCons;

    __weak IBOutlet UIButton *addButton;
    __weak IBOutlet UIImageView *edcationIcon;
}


#define SectionHeight        56

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"HSGHSchoolView" owner:self options:nil].firstObject;
        self.frame = frame;
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    edcationIcon.hidden = true;
}

- (IBAction)clickAddSchool:(id)sender {
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
    HSGHRegSchoolInfosVC *vc = (HSGHRegSchoolInfosVC *)[profileStoryBoard instantiateViewControllerWithIdentifier:@"RegSchoolInfo2"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isEditingModel = true;
    [[[AppDelegate instanceApplication] fetchCurrentNav] pushViewController:vc animated:YES];
}

- (void)setCity:(NSString *)city {
    if (![_city isEqualToString:city]) {
        _city = city;
        
        NSString * newString = city;
        if ([newString containsString:@"市"]) {
            newString = [newString substringWithRange:NSMakeRange(0, [newString length] - 1)];
        }
        
        CGFloat width = [HSGHTools widthOfString:newString font:_cityLabel.font height:_cityLabel.height];
        
        if (width > 37) {
            _cityLabelWidthCons.constant = 150;
            _cityLabel.textAlignment = NSTextAlignmentLeft;
        }
        else {
            _cityLabelWidthCons.constant = 37;
            _cityLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        _cityLabel.text = newString;
    }
}

- (void)updateIsMineInfo:(BOOL)isMine {
    addButton.hidden = !isMine;
}

- (void)updateContainsView:(BachelorUniversity*)bachelorUniv masterUnvi:(BachelorUniversity*)masterUniv highSchool:(BachelorUniversity*)highSchool{
    [_schoolContainsView removeAllSubviews];
    
    NSUInteger sectionCount = 0;
    if (UN_NIL_STR(masterUniv.univId).length > 0) {
        [self addNewSection:masterUniv section:sectionCount];
        sectionCount++;
    }
    
    if (UN_NIL_STR(bachelorUniv.univId).length > 0) {
        [self addNewSection:bachelorUniv section:sectionCount];
        sectionCount++;
    }
    else {
        if (UN_NIL_STR(highSchool.univId).length > 0) {
            [self addNewSection:highSchool section:sectionCount];
            sectionCount++;
        }
    }
    
    edcationIcon.hidden = !(sectionCount > 0);
}

- (void)addNewSection:(BachelorUniversity*)univ section:(NSUInteger)section{
    NSUInteger currentTop = section * SectionHeight;
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, currentTop, 37, 37)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:UN_NIL_STR(univ.iconUrl)] placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"]];
    [_schoolContainsView addSubview:imageView];
    
    VerticallyAlignedLabel* label = [VerticallyAlignedLabel new];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Bold" size:13];
    if(font==nil){
        font = [UIFont boldSystemFontOfSize:13];
    }
    label.font = font;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.textColor = HEXRGBCOLOR(0x272727);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    label.frame = CGRectMake(imageView.width + 8, currentTop, _schoolContainsView.width -  imageView.width - 44 - 8, 38);
    NSUInteger rows = [HSGHTools calcLabelRows:label text:UN_NIL_STR(univ.name)];
    if (rows > 1) {
        label.height = 38;
    }
    else {
        label.height = 19;
    }
    label.text = UN_NIL_STR(univ.name);
    [_schoolContainsView addSubview:label];
    
    UILabel* dateLabel = [[UILabel alloc]init];
    dateLabel.font = [UIFont systemFontOfSize: 13];
    dateLabel.font = font;
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.textColor = HEXRGBCOLOR(0x747474);
    dateLabel.frame = CGRectMake(label.left, label.bottom + 4, label.width, 14);
    dateLabel.numberOfLines = 1;
    [_schoolContainsView addSubview:dateLabel];
    
    
    NSString *lastYear = (univ.univStatus == UnivStatusGraduation) ? [self
       covertToYear:univ.univOut] : @"至今";
    if (UN_NIL_STR([self covertToYear:univ.univOut]).length == 0) {
        lastYear = @"至今";
    }
//    else {
//        lastYear = [self covertToYear:univ.univOut];
//    }
    
    dateLabel.text = [NSString stringWithFormat:@"%@-%@", [self covertToYear:univ.univIn], lastYear];
}



- (NSString *)covertToYear:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:date];
}

+ (CGFloat)calcWholeHeight:(BachelorUniversity*)bachelorUniv masterUnvi:(BachelorUniversity*)masterUniv highSchool:(BachelorUniversity*)highSchool {
    CGFloat topHeight = 17;
    CGFloat bottomHeight = 28;
    NSUInteger sectionsCount = 0;
    
    if (UN_NIL_STR(bachelorUniv.univId).length > 0) {
        sectionsCount ++;
        if (UN_NIL_STR(masterUniv.univId).length > 0) {
            sectionsCount ++;
        }
    }
    else {
        if (UN_NIL_STR(highSchool.univId).length > 0) {
            sectionsCount ++;
        }
    }
    return topHeight + bottomHeight + SectionHeight * sectionsCount;
}

- (IBAction)changeAddress:(UIButton *)sender {
    if (self.modifyAddress) {
        self.modifyAddress();
    }
}

@end
