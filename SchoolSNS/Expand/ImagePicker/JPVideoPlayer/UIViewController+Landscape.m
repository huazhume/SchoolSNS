/*
 * This file is part of the JPVideoPlayer package.
 * (c) NewPan <13246884282@163.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Click https://github.com/Chris-Pan
 * or http://www.jianshu.com/users/e2f2d779c022/latest_articles to contact me.
 */

#import "UIViewController+Landscape.h"
#import "JPVideoPlayerSwizzle.h"
#import <objc/runtime.h>
//
//NSString *  _Nonnull const JPVideoPlayerLandscapeNotification = @"www.jpvideoplayer.landscape.notification";
//
@interface UIViewController()

/**
 * The Current `UIViewController` need landscape.
 */
//@property(nonatomic)UIViewController *needLandscapeVC;

@end

@implementation UIViewController (Landscape)

//+(void)load{
//    [super load];
//    
//    // fix #50.
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self jp_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(jp_viewDidLoad) error:nil];
//        [self jp_swizzleMethod:NSSelectorFromString(@"dealloc") withMethod:@selector(jp_dealloc) error:nil];
//        [self jp_swizzleMethod:@selector(shouldAutorotate) withMethod:@selector(jp_shouldAutorotate) error:nil];
//    });
//}
//
//- (BOOL)jp_shouldAutorotate{
//    if (self.needLandscapeVC && (self == self.needLandscapeVC)) {
//        return NO;
//    }
//    else{
//        return [self jp_shouldAutorotate];
//    }
//}
//
//- (void)jp_viewDidLoad{
//    [self jp_viewDidLoad];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLandscapeNotification:) name:JPVideoPlayerLandscapeNotification object:nil];
//}
//
//- (void)jp_dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (BOOL)jp_prefersStatusBarHidden{
//    if (self.needLandscapeVC && (self == self.needLandscapeVC)) {
//        return NO;
//    }
//    else{
//        return [self jp_shouldAutorotate];
//    }
//}
//
//
//#pragma mark - Private
//
//- (void)didReceiveLandscapeNotification:(NSNotification *)note{
//    UIViewController *vc = note.object;
//    if (!vc) {
//        return;
//    }
//    
//    self.needLandscapeVC = vc;
//}
//
//- (void)setNeedLandscapeVC:(UIViewController *)needLandscapeVC{
//    objc_setAssociatedObject(self, @selector(needLandscapeVC), needLandscapeVC, OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (UIViewController *)needLandscapeVC{
//    return objc_getAssociatedObject(self, _cmd);
//}

@end
