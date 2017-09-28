//
//  HSGHPhotoCollectionViewCell.m

#import "HSGHPhotoCollectionViewCell.h"

@interface HSGHPhotoCollectionViewCell()
@property (nonatomic, strong) UIView* whiteCoverView;
@property (nonatomic, strong) UILabel* timeLabel;

@end

@implementation HSGHPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.layer.borderColor = HEXRGBCOLOR(0xefefef).CGColor;
        [self.contentView addSubview:self.imageView];
        
        _whiteCoverView = [[UIView alloc]initWithFrame:self.bounds];
        _whiteCoverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _whiteCoverView.backgroundColor = HEXRGBACOLOR(0xffffff, 0.5);
        _whiteCoverView.hidden = true;
        [self.contentView addSubview:_whiteCoverView];
        
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 40 - 5, self.height - 13 - 5, 40, 13)];
        _timeLabel.font = [UIFont systemFontOfSize:12.f];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.hidden = YES;
        [self.contentView addSubview:_timeLabel];

    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    _whiteCoverView.hidden = !selected;
    
//    self.imageView.layer.borderWidth = selected ? 1 : 0;
}


- (void)setTime:(CGFloat)time {
    int timeInt = (int)time;
    int s  = timeInt / 60;
    
    if (timeInt < 9) {
        _timeLabel.text = [NSString stringWithFormat:@"0:0%@", @(timeInt)];
    }
    else if (timeInt < 60) {
        _timeLabel.text = [NSString stringWithFormat:@"0:%@", @(timeInt)];
    }
    else {
        int subs = timeInt % 60;
        if (subs < 9) {
            _timeLabel.text = [NSString stringWithFormat:@"%@:0%@", @(s), @(subs)];
        }
        else {
            _timeLabel.text = [NSString stringWithFormat:@"%@:%@", @(s), @(subs)];
        }
    }
}

- (void)setIsVideo:(BOOL)isVideo {
    _timeLabel.hidden = !isVideo;
}
@end
