//
//  HSGHMsgBaseView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHMsgBaseView.h"

@implementation HSGHMsgBaseView

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
    self.mainTableView.tableFooterView = [UIView new];
    
}
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT - 33 - 20 - 39)
                                                      style:UITableViewStylePlain];
    }
    _mainTableView.separatorColor = [UIColor colorWithRed:239 / 255.0
                                                    green:239 / 255.0
                                                     blue:239 / 255.0
                                                    alpha:1];
    _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return _mainTableView;
}
- (NSArray *)removeIndexItem:(NSArray *)array WithIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * muArr = [NSMutableArray arrayWithArray:array];
    [muArr removeObjectAtIndex:indexPath.row];
    return muArr;
    
}

@end
