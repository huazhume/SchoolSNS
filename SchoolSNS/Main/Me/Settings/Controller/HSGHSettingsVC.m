//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
// My homepage and other people homepage.


#import "HSGHSettingsVC.h"
#import "AppDelegate.h"
#import "HSGHUserInf.h"
#import "HSGHSettingsModel.h"
#import "SchoolSNS-Swift.h"

@interface HSGHSettingsVC()

@end


@implementation HSGHSettingsVC {

}


- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6) { //Exit login
        //Empty the userInfo
        
        [(AppDelegate *) ([UIApplication sharedApplication].delegate) enterLogin];
        [HSGHUserInf emptyUserDefault];
    }
}



@end
