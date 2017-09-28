//
//  HSGHAddressChooseView.h
//  SchoolSNS
//
//  Created by hemdenry on 2017/9/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGHAddressChooseView : UIView <UIPickerViewDelegate,UIPickerViewDataSource,NSXMLParserDelegate>

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UIButton *chooseBtn;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableDictionary *cityIDDic;

@property void(^chooseClick)(NSString *cityID,NSString *cityName);

@end
