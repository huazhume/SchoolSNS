//
//  HSGHAddressChooseView.m
//  SchoolSNS
//
//  Created by hemdenry on 2017/9/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHAddressChooseView.h"

NSInteger leftCount;
NSInteger rightCount;

@implementation HSGHAddressChooseView

- (instancetype)init {
    if (self = [super init]) {
    //    self.backgroundColor = [UIColor whiteColor];
        [self initSub];
    }
    return self;
}

- (void)initSub {
    self.dataArr = [NSMutableArray array];
    self.cityIDDic = [NSMutableDictionary dictionary];
    
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.5;
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    
    self.chooseBtn = [UIButton new];
    [self.chooseBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.chooseBtn.backgroundColor = [UIColor blackColor];
    [self.chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.chooseBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.chooseBtn];
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self).offset(-kFit(300));
        make.height.mas_equalTo(44);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"china_city_data" ofType:@"xml"];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:path]];
    parser.delegate = self;
    [parser parse];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

- (void)btnClick {
    if (self.chooseClick) {
        if (self.dataArr.count > leftCount) {
            NSMutableDictionary *dic = self.dataArr[leftCount];
            NSMutableArray *array = dic[dic.allKeys.firstObject];
            if (array.count > rightCount) {
                NSString *city = array[rightCount];
                NSString *cityID = self.cityIDDic[city];
                self.chooseClick(cityID,city);
            }
        }
    }
    [self removeFromSuperview];
}

#pragma xmlDelegate
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.top.equalTo(self.chooseBtn.mas_bottom);
    }];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    NSString *str = attributeDict[@"name"];
    if ([elementName isEqualToString:@"province"]) {
        [self.dataArr addObject:[NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:str]];
    } else if ([elementName isEqualToString:@"city"]) {
        NSMutableDictionary *dic = self.dataArr.lastObject;
        NSMutableArray *array = dic[dic.allKeys.firstObject];
        [array addObject:str];
    } else if ([elementName isEqualToString:@"district"]) {
        NSMutableDictionary *dic = self.dataArr.lastObject;
        NSMutableArray *array = dic[dic.allKeys.firstObject];
        NSString *city = array.lastObject;
        NSString *cityID = attributeDict[@"zipcode"];
        [self.cityIDDic setObject:cityID forKey:city];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
}

#pragma mark picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataArr.count;
    }else{
        NSMutableDictionary *dic = self.dataArr[leftCount];
        NSMutableArray *array = dic[dic.allKeys.firstObject];
        return array.count;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        NSMutableDictionary *dic = self.dataArr[row];
        NSString *provice = dic.allKeys.firstObject;
        return provice;
    }else{
        NSMutableDictionary *dic = self.dataArr[leftCount];
        NSMutableArray *array = dic[dic.allKeys.firstObject];
        return array[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        leftCount = row;
        rightCount = 0;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    }else{
        rightCount = row;
    }
}
@end
