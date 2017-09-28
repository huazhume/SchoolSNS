//
//  HSGHZoneAreaBHeadView.m
//  SchoolSNS
//
//  Created by Murloc on 15/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHZoneAreaBHeadView.h"

@interface HSGHZoneAreaBHeadView()
@property(nonatomic, strong) UIButton *selectionButton1; //Height 25
@property(nonatomic, strong) UIImageView *selectionButton1ImageView; //22

@property(nonatomic, strong) UIButton *selectionButton2;
@property(nonatomic, strong) UIImageView *selectionButton2ImageView;
@property(nonatomic, strong) UIView *selectedView;
@property(nonatomic, assign) BOOL isSecondSelection;

@end


@implementation HSGHZoneAreaBHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupSelectionButton];
    }
    
    return self;
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSelectionButton];
    }
    return self;
}

- (void)setupSelectionButton {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = HEXRGBCOLOR(0xefefef);
    lineView.frame = CGRectMake(0, 0, [[self class] shouldSize].width, .5f);
    [self addSubview:lineView];
    
    _selectionButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectionButton1.backgroundColor = [UIColor clearColor];
    
    _selectionButton1.frame = CGRectMake(0, 0, [[self class] shouldSize].width / 2, [[self class] shouldSize].height);
    _selectionButton1.tag = 1;
    [_selectionButton1 addTarget:self
                          action:@selector(selectSelection:)
                forControlEvents:UIControlEventTouchUpInside];
    
    _selectionButton1ImageView = [UIImageView new];
    [_selectionButton1ImageView setImage:[UIImage imageNamed:@"zone_selection1_n"]];
    _selectionButton1ImageView.highlightedImage = [UIImage imageNamed:@"zone_selection1_s"];
    _selectionButton1ImageView.contentMode = UIViewContentModeScaleAspectFill;
    _selectionButton1ImageView.frame = CGRectMake(0, 0, 30, 30);
    _selectionButton1ImageView.left = (_selectionButton1.width - _selectionButton1ImageView.width) / 2.f;
    _selectionButton1ImageView.top = (_selectionButton1.height - _selectionButton1ImageView.height) / 2.f;
    [_selectionButton1 addSubview:_selectionButton1ImageView];
    
    _selectionButton1.selected = YES;
    _selectionButton1ImageView.highlighted = YES;
    
    _selectionButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectionButton2.backgroundColor = [UIColor clearColor];
    
    _selectionButton2.frame = CGRectMake([[self class] shouldSize].width / 2, 0, [[self class] shouldSize].width / 2, [[self class] shouldSize].height);
    _selectionButton2.tag = 2;
    [_selectionButton2 addTarget:self
                          action:@selector(selectSelection:)
                forControlEvents:UIControlEventTouchUpInside];
    _selectionButton2ImageView = [UIImageView new];
    [_selectionButton2ImageView setImage:[UIImage imageNamed:@"zone_selection2_n"]];
    _selectionButton2ImageView.highlightedImage = [UIImage imageNamed:@"zone_selection2_s"];
    _selectionButton2ImageView.contentMode = UIViewContentModeScaleAspectFill;
    _selectionButton2ImageView.frame = CGRectMake(0, 0, 30, 30);
    _selectionButton2ImageView.left = (_selectionButton2.width - _selectionButton2ImageView.width) / 2.f;
    _selectionButton2ImageView.top = (_selectionButton2.height - _selectionButton2ImageView.height) / 2.f;
    [_selectionButton2 addSubview:_selectionButton2ImageView];
    
    
    [self addSubview:_selectionButton2];
    [self addSubview:_selectionButton1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, [[self class] shouldSize].height - (CGFloat) 0.75,
                                                                 [[self class] shouldSize].width, 0.75)];
    lineView2.backgroundColor = HEXRGBCOLOR(0xefefef);
    [self addSubview:lineView2];
    
    _selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, [[self class] shouldSize].height - (CGFloat) 0.75,
                                                            [[self class] shouldSize].width / 2, 0.75)];
    _selectedView.backgroundColor = HEXRGBCOLOR(0x888888);
    [self addSubview:_selectedView];
    
    _selectionButton2.selected = NO;
}
    
- (void)selectSelection:(UIButton *)button {
    BOOL isSelectedTwo = (button.tag == 2);
    if (_isSecondSelection != isSelectedTwo) {
        _isSecondSelection = isSelectedTwo;
        _selectionButton1.selected = !_isSecondSelection;
        _selectionButton2.selected = _isSecondSelection;
        _selectionButton1ImageView.highlighted = _selectionButton1.selected;
        _selectionButton2ImageView.highlighted = _selectionButton2.selected;
        
        if (_selectionButton2.selected) {
            [UIView animateWithDuration:0.2 animations:^{
                _selectedView.left = [[self class] shouldSize].width / 2;
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                _selectedView.left = 0;
            }];
        }
        
        if (_sectionBlock) {
            self.sectionBlock(!_isSecondSelection);
        }
    }
}

- (BOOL)isSecond {
    return _isSecondSelection;
}


- (void)clickSelection:(BOOL)isMine {
    UIButton *button = [UIButton new];
    button.tag = isMine ? 1 : 2 ;
    [self selectSelection: button];
}

+ (CGSize)shouldSize {
    return CGSizeMake(HSGH_SCREEN_WIDTH, 35.f);
}
@end
