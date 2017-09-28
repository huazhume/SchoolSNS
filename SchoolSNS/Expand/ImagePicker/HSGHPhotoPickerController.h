//
//  HSGHPhotoPickerController.h
//  InstagramPhotoPicker


#import <UIKit/UIKit.h>
#import "HSGHBaseViewController.h"

@interface HSGHPhotoPickerController : HSGHBaseViewController

@property (nonatomic, copy) void(^cropBlock)(UIImage *image);
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL isEnterVideo;

//PhotoMode
@property (nonatomic, assign) BOOL isPersonalMode;
@property (nonatomic, assign) BOOL isChangeRate;
@property (nonatomic, assign) BOOL isLauncher;



//VideoMode
@property (nonatomic, assign) BOOL isContainsVideo;

@end
