//
//  HSGHVideoScrollBottomTitleView.m
//  SchoolSNS
//
//  Created by Murloc on 31/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//



/// 图库 - 照片 - 视频
#import "HSGHVideoScrollBottomTitleView.h"


@interface HSGHVideoScrollBottomTitleView()


@property (nonatomic, strong) UIView* titleContainView;
@property (nonatomic, strong) NSArray* titleArray;
@property (nonatomic, strong) NSMutableArray* buttonsArray;

@property (nonatomic, strong) UIView* deleteContainView;
@property (nonatomic, strong) UIButton* deleteButton;

@end



@implementation HSGHVideoScrollBottomTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleArray = @[@"视频库", @"照片", @"视频"];
        _buttonsArray = [NSMutableArray new];
        
        [self setupViews];
        [self updateUIState:VideoNotStarted];
    }
    
    return self;
}


- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    //Title Mode
    _titleContainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:_titleContainView];

    NSUInteger count = _titleArray.count;
    CGFloat cellWidth = self.width / count;
    for (int i = 0; i < count; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * cellWidth, 0, cellWidth, self.height);
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitle:_titleArray[i] forState:UIControlStateSelected];
        [button setTitleColor:HEXRGBCOLOR(0x272727) forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.selected = (i == 0);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_buttonsArray addObject:button];
        if (i != TakePhoto) {
            [_titleContainView addSubview:button];
        }
    }
    
    //Delete Mode
    _deleteContainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:_deleteContainView];
    
    _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, self.height)];
    _deleteButton.centerX = _deleteContainView.centerX;
    [_deleteButton setTitle:@"< 删除" forState:UIControlStateNormal];
    [_deleteButton setTitle:@"< 删除" forState:UIControlStateSelected];
    [_deleteButton setTitleColor:HEXRGBCOLOR(0x272727) forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [_deleteContainView addSubview:_deleteButton];
}


- (void)updateUIState:(VideoBottomUIType)type {
    switch (type) {
        case VideoNotStarted:{
                [UIView animateWithDuration:0.5 animations:^{
                    _deleteContainView.top = self.height;
                    _titleContainView.top = 0;
                }];
            }
            break;
            
        case VideoRecording:{
                [UIView animateWithDuration:0.5 animations:^{
                    _deleteContainView.top = self.height;
                    _titleContainView.top = self.height;
                }];
            }
            break;
            
        case VideoDelete:
        case VideoDeleteSelected:{
                [UIView animateWithDuration:0.5 animations:^{
                    _deleteContainView.top = 0;
                    _titleContainView.top = self.height;
                }];
            }
            break;
            
        default:
            break;
    }
}


- (void)updateNotStartedTitle:(int)index {
    for (UIButton* button in _buttonsArray) {
        button.selected = (index == button.tag);
    }
}


- (void)refreshUI:(TakePhotoType)type {
    //因为默认图片不再有，所以这里需要做一个转换
    if (type == TakePhoto) {
        type = TakeVideo;
    }
    [self updateNotStartedTitle:type];
}


- (void)clickButton:(UIButton*)sender {
    if (_selectedBlock) {
        _selectedBlock(sender.tag);
    }
    
    for (UIButton* button in _buttonsArray) {
        button.selected = (sender.tag == button.tag);
    }
}

- (void)clickDeleteButton {
    if (_deleteButton.selected ) {
        if (_deleteBlock) {
            _deleteBlock();
        }
    }
    
    if (!_deleteButton.selected ) {
        if (_willDeleteBlock) {
            _willDeleteBlock();
        }
    }
    
    _deleteButton.selected = !_deleteButton.selected;
}


- (void)enterVideo {
    [self clickButton:_buttonsArray[TakeVideo]];
}
@end
