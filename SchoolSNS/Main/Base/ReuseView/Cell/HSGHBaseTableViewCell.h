//
//  BFSBaseTableViewCell.h
//  BFSports
//
//  Created by wayne on 16/6/29.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGHBaseTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier param:(NSDictionary *)param;
/**
 *  传进来的参数
 */
@property (nonatomic, copy) NSDictionary * paramDict;

/**
 *  tableView   :   所属table
 *  param       :   保留参数
 */
+(instancetype)cellWithTableView:(UITableView *)tableView param:(NSDictionary *)param;

/*
 *  初始化cell视图
 */
- (void)setupView;

/**
 *  cell高度固定,类直接调用
 *
 *    
 */
+ (CGFloat)cellHeight;

/**
 *  cell高度不固定，实例化临时cell，获取高度
 *
 *    
 */
- (CGFloat)cellHeight;


/**
 *  cell复用ID
 *
 *     
 */
+ (NSString*)cellIdentifity;

@end
