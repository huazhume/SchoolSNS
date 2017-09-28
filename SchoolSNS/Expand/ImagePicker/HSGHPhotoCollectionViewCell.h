//
//  HSGHPhotoCollectionViewCell.h

#import <UIKit/UIKit.h>

@interface HSGHPhotoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGFloat time;
@property (assign, nonatomic) BOOL isVideo;
@end
