//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHFriendView.h"
#import "HSGHFriendViewCell.h"
#import "HSGHZoneModel.h"
#import "HSGHZoneVC.h"

@interface HSGHFriendView () <UICollectionViewDelegate, UICollectionViewDataSource> {

  __weak IBOutlet UICollectionView *_collectionView;
  NSArray* data;

}
@end


@implementation HSGHFriendView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"HSGHFriendView" owner:self options:nil].firstObject;
        self.frame = frame;
        [_collectionView registerNib:[UINib nibWithNibName:@"HSGHFriendViewCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:[HSGHFriendViewCell class].description];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = HEXRGBCOLOR(0xefefef);
        lineView.frame = CGRectMake(0, 0, self.width, .5f);
        [self addSubview:lineView];
    }
    self.clipsToBounds = YES;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return data.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGHFriendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HSGHFriendViewCell class].description
                                                                           forIndexPath:indexPath];
    HSGHFriendModel* singleData = data[indexPath.row];
  
    cell.headImagePath = UN_NIL_STR(singleData.picture.thumbUrl);
    cell.schoolIconPath = UN_NIL_STR(singleData.unvi.iconUrl);
    cell.name = UN_NIL_STR(singleData.displayName);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGHFriendModel* singleData = data[indexPath.row];
    [HSGHZoneVC enterOtherZone: singleData.userId];
}

- (void)updateData:(NSArray*)dataArray {
    data = dataArray;
    [_collectionView reloadData];
}

@end
