//
//  HSGHFirstLaunchShowVC.m
//  SchoolSNS
//
//  Created by Murloc on 24/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHFirstLaunchShowVC.h"
#import "HSGHPhotoPickerController.h"

@interface HSGHFirstLaunchShowVC ()

@end

@implementation HSGHFirstLaunchShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    [self performSelector:@selector(enterNext) withObject:nil afterDelay:3.f];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}


- (void)enterNext {
    HSLog(@"---HSGHFirstLaunchShowVC----enterNext()");
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"firstLaunchVC_2_rootVC_publish_notifi" object:nil];
    }];
    
//    HSGHPhotoPickerController *vc = [HSGHPhotoPickerController new];
//    vc.isLauncher = true;
//    vc.isPush = true;
//    NSMutableArray *arr = self.navigationController.viewControllers.mutableCopy;
//    [arr removeAllObjects];
//    [arr addObject:vc];
//    [self.navigationController setViewControllers:arr animated:YES];
}

@end
