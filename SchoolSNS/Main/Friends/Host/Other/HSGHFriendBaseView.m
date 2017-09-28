//
//  HSGHFriendBaseView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendBaseView.h"

@interface HSGHFriendBaseView ()<UIScrollViewDelegate>
{
    CGFloat _oldOffset;
}
@end

@implementation HSGHFriendBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.mainTableView];
}

- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT - 53 - 39)
                                                      style:UITableViewStylePlain];
    }
    _mainTableView.separatorColor = [UIColor colorWithRed:239 / 255.0
                                                    green:239 / 255.0
                                                     blue:239 / 255.0
                                                    alpha:1];
    _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return _mainTableView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y > _oldOffset){
        //隐藏
        [self.delegate navAndTabIsHidden:YES];
    }else{
        [self.delegate navAndTabIsHidden:NO];
    }
}

- (NSArray *)removeIndexItem:(NSArray *)array WithIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * muArr = [NSMutableArray arrayWithArray:array];
    [muArr removeObjectAtIndex:indexPath.row];
    return muArr;
    
}

@end
