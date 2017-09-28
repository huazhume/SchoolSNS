//
//  BFLDateFormatManager.h
//  BFLive
//
//  Created by BaoFeng on 16/1/31.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFSDateFormatManager : NSObject

/**
 *  时间格式化为 00：00：00
 *
 *     seconds 秒数
 *
 *     
 */

+ (NSString *)distanceTimeWithBeforeTime:(double)seconds;
+ (NSString *)formatToTimerType:(long long)seconds;

/**
 *   时间格式化为XXX
 *
 *     seconds 距离1970时间间隔
 *
 *    
 */
+ (NSString *)formatToHumanableInfoType:(double)seconds;


/**
 *  时间格式化为 2016年01月31日
 *
 *     seconds 距离1970时间间隔
 *
 *    
 */
+ (NSString *)formatToDateType_yyyyMMdd_withTimeIntervalSince1970:(double)seconds;

/**
 *  时间格式化为 2016-01-31 18:30
 *
 *     seconds 距离1970时间间隔
 *
 *    
 */
+ (NSString *)formatToDateType_yyyyMMddHHmm_withTimeIntervalSince1970:(double)seconds;


/**
 *  时间格式化为 2016-01-31 18:30:00
 *
 *     seconds 距离1970时间间隔
 *
 *    
 */
+ (NSString *)formatToDateType_yyyyMMddHHmmss_withTimeIntervalSince1970:(double)seconds;


/**
 *  时间格式化为 01-31 18:30:00
 *
 *     seconds 距离1970时间间隔
 *
 *    
 */
+ (NSString *)formatToDateType_MMddHHmmss_withTimeIntervalSince1970:(double)seconds;

/**
 *  时间格式化为 01月31日 18:30
 *
 *     seconds 距离1970时间间隔
 *
 *     
 */
+ (NSString *)formatToDateType_MMddHHmm_withTimeIntervalSince1970:(double)seconds;

/**
 *  时间格式化为 2016年01月31日
 *
 *     date date
 *
 *    
 */
+ (NSString *)formatToDateType_yyyyMMdd_withDate:(NSDate *)date;


/**
 *  时间格式化为 01月31日
 *
 *     date date
 *
 *    
 */
+ (NSString *)formatToDateType_MMdd_withTimeIntervalSince1970:(double)seconds;

/**
 *  时间格式化为 10:10
 *
 *     date date
 *
 *    
 */
+ (NSString *)formatToDateType_HHmm_withTimeIntervalSince1970:(double)seconds;

/**
 *  时间格式化为 05-12 10:10
 *
 *     date date
 *
 *    
 */
+ (NSString *)formatToDateType_MM_ddHHmm_withTimeIntervalSince1970:(double)seconds;

/**
 *  时间格式化为 05-12
 *
 *     date date
 *
 *    
 */
+ (NSString *)formatToDateType_MMdd_withDate:(NSDate *)date;

/**
 *  格式化为周几或者星期几
 *
 *   date 日期
 *   : 0 -> 星期几 ; 1 -> 周几
 *    
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)date type:(NSInteger)type;

/**
 *  是否为同一天
 *
 *     date 距离1970时间间隔
 *
 *    
 */

+ (BOOL)isSameDay:(double)seconds;

/**
 *   比较时间是否超过几天
 *
 *     aDate  第一次记录时间
 *     aDay  几天
 *
 *    
 */
+ (BOOL)isPassDate:(NSDate*)aDate withDay:(int)aDay;

/**
 比较是否超过多少小时

    aDate 时间
    hours 小时
    
 */
+ (BOOL)isPassDate:(NSDate*)aDate withHours:(int)hours;
/**
 *  发贴时间格式化为人类可读格式
 *
 *  0-59分钟内：XX分钟前
 *  1小时-24小时内：XX小时前
 *  1天-7天内：X天前
 *  7天以上：今年-月/日 12:00；
 *  非今年-年月日：XX/XX/XX 12:00
 *
 *     interval 距离1970时间间隔
 *    
 *
 *
 */
+(NSString *)formatToHumanReadableInfoWithTimeIntervalSince1970:(double)interval;

/**
 *  时间格式化为 20160512
 *
 *     date date
 *
 *    
 */
+ (NSString *)formatToDateType_yyyy_MM_dd_withTimeIntervalSince1970:(double)seconds;

/**
 *  时间格式化为 2016年9月25日 周日 14：00
 *
 *     date date
 *
 *    
 */
+ (NSString *)formatToDateType_yyyy_MM_dd_week_HH_MM_withTimeIntervalSince1970:(double)seconds;
/**
 *  时间格式化为 9月 2016 
 *
 *     date date
 *
 *    
 */
+ (NSString *)formatToDateType_yyyy_withTimeIntervalSince1970:(double)seconds;
/**
 *  时间格式化为 30
 *
 *     date date
 *
 *    
 */
+ (NSString *)formatToDateType_dd_withTimeIntervalSince1970:(double)seconds;

/**
 *  时间格式化为 sep
 *
 *     date date
 *
 *    
 */
+(NSString *)formatToDateTypeMonthWithTimeIntervalSince1970:(double)seconds;

/**
 *  计算当前时间和开始时间的时间差
 *
 *    
 *
 *    
 */
+ (double)calculateTimeDifferent:(double)beginTime;

/**
 *  起始时间
 *
 *    
 *
 *    
 */
+ (double)beginTime;


@end
