//
//  BFLDateFormatManager.m
//  BFLive
//
//  Created by BaoFeng on 16/1/31.
//  Copyright © 2016年 BF. All rights reserved.
//
#include <mach/mach_time.h>
#import "HSGHDateFormatManager.h"
//#import "YYKit.h"

@implementation BFSDateFormatManager

+ (NSString *)formatToTimerType:(long long)seconds {
  long long second = seconds % 60;
  long long minute = seconds / 60;

  NSString *param =
      [NSString stringWithFormat:@"%.2lld:%.2lld", minute, second];
  return param;
}

+ (NSString *)distanceTimeWithBeforeTime:(double)seconds {
  NSString *distanceStr;
//  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
//  if ([date isYesterday]) {
//    distanceStr = @"昨天";
//  } else if ([date isToday]) {
//    distanceStr = @"今天";
//  }

  return distanceStr;
}

+ (NSString *)formatToHumanableInfoType:(double)seconds {
  NSString *info;
  NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSTimeInterval delta = -[theDate timeIntervalSinceNow];
  if (delta < 60) {
    info = @"刚刚";
  } else {
    delta = delta / 60;
    if (delta < 60) {
      info = [NSString stringWithFormat:@"%d分钟前", (int)delta];
    } else {
      delta = delta / 60;
      if (delta < 24) {
        info = [NSString stringWithFormat:@"%d小时前", (int)delta];
      } else {
        delta = delta / 24;
        if ((NSInteger)delta == 1) {
          info = @"昨天";
        } else if ((NSInteger)delta == 2) {
          info = @"前天";
        } else {
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
          [dateFormatter setDateFormat:@"yyyy-MM-dd"];
          info = [dateFormatter stringFromDate:theDate];
        }
      }
    }
  }
  return info;
}

+ (NSString *)formatToDateType_yyyyMMdd_withTimeIntervalSince1970:
    (double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_MMdd_withTimeIntervalSince1970:(double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM月dd日"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_yyyy_withTimeIntervalSince1970:(double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_dd_withTimeIntervalSince1970:(double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"dd"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_yyyyMMddHHmm_withTimeIntervalSince1970:
    (double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_yyyy_MM_dd_withTimeIntervalSince1970:
    (double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyyMMdd"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_yyyyMMddHHmmss_withTimeIntervalSince1970:
    (double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_MMddHHmmss_withTimeIntervalSince1970:
    (double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_MM_ddHHmm_withTimeIntervalSince1970:
    (double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM-dd HH:mm"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_MMddHHmm_withTimeIntervalSince1970:
    (double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}
+ (NSString *)formatToDateType_HHmm_withTimeIntervalSince1970:(double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"HH:mm"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_yyyyMMdd_withDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)formatToDateType_MMdd_withDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM月dd日"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}

+ (NSString *)weekdayStringFromDate:(NSDate *)date type:(NSInteger)type {
  NSArray *weekdays;
  if (type == 0) {
    weekdays =
        [NSArray arrayWithObjects:[NSNull null], @"星期日", @"星期一",
                                  @"星期二", @"星期三", @"星期四",
                                  @"星期五", @"星期六", nil];
  } else {
    weekdays = [NSArray arrayWithObjects:[NSNull null], @"周日", @"周一",
                                         @"周二", @"周三", @"周四",
                                         @"周五", @"周六", nil];
  }
  NSCalendar *calendar = [[NSCalendar alloc]
      initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  [calendar setTimeZone:[NSTimeZone systemTimeZone]];
  NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
  NSDateComponents *theComponents =
      [calendar components:calendarUnit fromDate:date];
  return [weekdays objectAtIndex:theComponents.weekday];
}

+ (BOOL)isSameDay:(double)seconds {
  UInt64 timeNow = [[NSDate date] timeIntervalSince1970];
  NSString *time = [BFSDateFormatManager
      formatToDateType_yyyyMMdd_withTimeIntervalSince1970:timeNow];
  NSString *time2 = [BFSDateFormatManager
      formatToDateType_yyyyMMdd_withTimeIntervalSince1970:seconds];
  if ([time isEqualToString:time2]) {
    return YES;
  }
  return NO;
}

+ (BOOL)isPassDate:(NSDate *)aDate withDay:(int)aDay {
  if (aDate && ABS([aDate timeIntervalSinceNow]) < aDay * 24 * 60 * 60) {
    return NO;
  }
  return YES;
}

+ (BOOL)isPassDate:(NSDate *)aDate withHours:(int)hours {

  if (aDate && ABS([aDate timeIntervalSinceNow]) < hours * 60 * 60) {
    return NO;
  }
  return YES;
}

+ (NSString *)formatToHumanReadableInfoWithTimeIntervalSince1970:
    (double)interval {
  NSDate *replyDate = [NSDate dateWithTimeIntervalSince1970:interval];

  NSDate *currentDate = [NSDate date];

  NSDateFormatter *datefmt = [NSDateFormatter new];

  datefmt.dateFormat = @"yyyy";

  NSString *currentYear = [datefmt stringFromDate:currentDate];
  NSString *replyYear = [datefmt stringFromDate:replyDate];

  NSCalendar *userCalendar = [NSCalendar currentCalendar];
  unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |
                           NSCalendarUnitDay | NSCalendarUnitHour |
                           NSCalendarUnitMinute;

  NSDateComponents *components = [userCalendar components:unitFlags
                                                 fromDate:replyDate
                                                   toDate:currentDate
                                                  options:0];

  NSInteger month = [components month];
  NSInteger day = [components day];
  NSInteger hour = [components hour];
  NSInteger minute = [components minute];

  if (![currentYear isEqualToString:replyYear]) {

    datefmt.dateFormat = @"yyyy/MM/dd hh:mm";
    return [datefmt stringFromDate:replyDate];

  } else {
    if ((month != 0) || ((month == 0) && (day > 7))) {
      datefmt.dateFormat = @"MM/dd hh:mm";
      return [datefmt stringFromDate:replyDate];
    } else {
      if (day >= 1) {
        return [NSString stringWithFormat:@"%ld天前", (long)day];
      } else {
        if (hour >= 1) {
          return [NSString stringWithFormat:@"%ld小时前", (long)hour];
        } else if (minute >= 1) {
          return [NSString stringWithFormat:@"%ld分钟前", (long)minute];
        } else {
          if (minute >= 1) {
            return [NSString stringWithFormat:@"%ld分钟前", (long)minute];
          } else {
            return [NSString stringWithFormat:@"刚刚"];
          }
        }
      }
    }
  }
}

+ (NSString *)formatToDateType_yyyy_MM_dd_week_HH_MM_withTimeIntervalSince1970:
    (double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
  [dateFormatter1 setDateFormat:@"yyyy年MM月dd日"];
  NSString *dateStr = [dateFormatter1 stringFromDate:date];
  NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
  [dateFormatter2 setDateFormat:@"HH:mm"];
  NSString *timeStr = [dateFormatter2 stringFromDate:date];
  NSString *weekStr = [BFSDateFormatManager weekdayStringFromDate:date type:1];
  return [NSString stringWithFormat:@"%@ %@ %@", dateStr, weekStr, timeStr];
}
+ (NSString *)formatToDateTypeMonthWithTimeIntervalSince1970:(double)seconds {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM"];
  NSString *time = [dateFormatter stringFromDate:date];
  switch ([time integerValue]) {
  case 1:
    time = @"Jan";
    break;
  case 2:
    time = @"Feb";
    break;
  case 3:
    time = @"Mar";
    break;
  case 4:
    time = @"Apr";
    break;
  case 5:
    time = @"May";
    break;
  case 6:
    time = @"Jun";
    break;
  case 7:
    time = @"Jul";
    break;
  case 8:
    time = @"Aug";
    break;
  case 9:
    time = @"Sep";
    break;
  case 10:
    time = @"Oct";
    break;
  case 11:
    time = @"Nov";
    break;
  case 12:
    time = @"Dec";
    break;

  default:
    break;
  }

  return time;
}

+ (double)beginTime {
  return (double)mach_absolute_time();
}

+ (double)calculateTimeDifferent:(double)beginTime {
  uint64_t nowTime = mach_absolute_time();
  // Elapsed time in mach time units
  uint64_t elapsedTime = nowTime - beginTime;
  static double ticksToNanoseconds = 0.0;
  if (fabs(ticksToNanoseconds) < 0.0001) {
    mach_timebase_info_data_t timebase;
    // to be completely pedantic, check the return code of this next call.
    mach_timebase_info(&timebase);
    ticksToNanoseconds = (double)timebase.numer / timebase.denom;
  }
  //时间差(单位：秒)
  double elapsedTimeInSeconds =
      (elapsedTime * ticksToNanoseconds) / 1000000000.0f;

  return elapsedTimeInSeconds;
}

@end
