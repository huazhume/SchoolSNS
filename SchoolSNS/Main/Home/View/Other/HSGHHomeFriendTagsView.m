//
//  HSGHHomeFriendTagsView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeFriendTagsView.h"
#import "HSGHFriendTagsTableViewCell.h"

@interface HSGHHomeFriendTagsView () <UITableViewDelegate,
                                      UITableViewDataSource> {
  NSMutableArray *_dataList;
  NSInteger selectRowIndex;
}

@property(weak, nonatomic) IBOutlet UIImageView *ImageView;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HSGHHomeFriendTagsView

- (void)awakeFromNib {
  [super awakeFromNib];
  self.leftWidth.constant = (HSGH_SCREEN_WIDTH / 3.0 / 2.0) - 40.5;
  _dataList = [[NSMutableArray alloc] initWithArray:@[
    @{ @"title" : @"好友",
       @"selected" : @1 },
    @{ @"title" : @"校友",
       @"selected" : @0 },
    @{ @"title" : @"同届",
       @"selected" : @0 },
    @{ @"title" : @"在读",
       @"selected" : @0 }
  ]];

  [self.tableView registerNib:[UINib
                                  nibWithNibName:@"HSGHFriendTagsTableViewCell"
                                          bundle:[NSBundle mainBundle]]
       forCellReuseIdentifier:@"mainCell"];
  UIImage *normal = [[UIImage imageNamed:@"home_friend_bg"]
      stretchableImageWithLeftCapWidth:0
                          topCapHeight:30];

  self.ImageView.image = normal;
  UITapGestureRecognizer *ges =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tap:)];
  [self.bgView addGestureRecognizer:ges];
  self.bgView.userInteractionEnabled = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  HSGHFriendTagsTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
  cell.textLab.text = _dataList[indexPath.row][@"title"];
  cell.backgroundColor = [UIColor clearColor];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (indexPath.row == selectRowIndex) {
    cell.redLine.hidden = NO;
  } else {
    cell.redLine.hidden = YES;
  }
  return cell;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    return 39;
  }
  return 28;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  selectRowIndex = indexPath.row;
  [self.tableView reloadData];
  self.selectblock(_dataList[indexPath.row][@"title"]);
  self.hidden = YES;
}
- (IBAction)tap:(id)sender {
  __weak HSGHHomeFriendTagsView * welfSelf = self;
  [UIView animateWithDuration:0.2
      animations:^{
        self.alertHeight.constant = 5;
        [self layoutIfNeeded];
        [self.alert layoutIfNeeded];

      }
      completion:^(BOOL finished) {
        self.hidden = YES;
        welfSelf.block();
      }];
}

@end

