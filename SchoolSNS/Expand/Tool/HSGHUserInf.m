//
//  HSGHUserInf.m
//  HSGHNBC
//
//  Created by Qianqian li on 2017/2/14.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import "HSGHUserInf.h"
#import "SchoolSNS-Swift.h"
#import "AppDelegate.h"

@implementation BachelorUniversity
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.univId forKey:@"univId"];
    [aCoder encodeInteger:self.univStatus forKey:@"univStatus"];
    [aCoder encodeInteger:self.city forKey:@"city"];
    [aCoder encodeInteger:self.educationalLevel forKey:@"educationalLevel"];
    [aCoder encodeObject:self.univIn forKey:@"univIn"];
    [aCoder encodeObject:self.univOut forKey:@"univOut"];

}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.iconUrl = [aDecoder decodeObjectForKey:@"iconUrl"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.univId = [aDecoder decodeObjectForKey:@"univId"];
        self.univStatus = [aDecoder decodeIntegerForKey:@"univStatus"];
        self.univIn = [aDecoder decodeObjectForKey:@"univIn"];
        self.univOut = [aDecoder decodeObjectForKey:@"univOut"];
        self.city = [aDecoder decodeIntegerForKey:@"city"];
        self.educationalLevel = [aDecoder decodeIntegerForKey:@"educationalLevel"];
    }
    return self;
}

- (NSString*)convertToStartYear {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:self.univIn];
}

- (NSString*)convertToEndYear {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:self.univOut];
}


@end

@implementation HeadPicInfo


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.srcHeight forKey:@"srcHeight"];
    [aCoder encodeObject:self.srcSize forKey:@"srcSize"];
    [aCoder encodeObject:self.srcUrl forKey:@"srcUrl"];
    [aCoder encodeObject:self.srcWidth forKey:@"srcWidth"];
    [aCoder encodeObject:self.thumbHeight forKey:@"thumbHeight"];
    [aCoder encodeObject:self.thumbSize forKey:@"thumbSize"];
    [aCoder encodeObject:self.thumbUrl forKey:@"thumbUrl"];
    [aCoder encodeObject:self.thumbWidth forKey:@"thumbWidth"];

}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.key = [aDecoder decodeObjectForKey:@"key"];
        self.srcHeight = [aDecoder decodeObjectForKey:@"srcHeight"];
        self.srcSize = [aDecoder decodeObjectForKey:@"srcSize"];
        self.srcUrl = [aDecoder decodeObjectForKey:@"srcUrl"];
        self.srcWidth = [aDecoder decodeObjectForKey:@"srcWidth"];
        self.thumbHeight = [aDecoder decodeObjectForKey:@"thumbHeight"];
        self.thumbSize = [aDecoder decodeObjectForKey:@"thumbSize"];
        self.thumbUrl = [aDecoder decodeObjectForKey:@"thumbUrl"];
        self.thumbWidth = [aDecoder decodeObjectForKey:@"thumbWidth"];

    }
    return self;
}

@end

@implementation HSGHUserInf

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.phoneCn forKey:@"phoneCn"];
    [aCoder encodeObject:self.phoneAbroad forKey:@"phoneAbroad"];
    [aCoder encodeObject:self.email forKey:@"email"];
    
    [aCoder encodeObject:self.firstNameEn forKey:@"firstNameEn"];
    [aCoder encodeObject:self.middleNameEn forKey:@"middleNameEn"];
    [aCoder encodeObject:self.lastNameEn forKey:@"lastNameEn"];
    
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
    [aCoder encodeObject:self.fullName forKey:@"fullName"];
    [aCoder encodeObject:self.fullNameEn forKey:@"fullNameEn"];

    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.homeCity forKey:@"homeCity"];
    [aCoder encodeObject:self.homeCityId forKey:@"homeCityId"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeInteger:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.ticket forKey:@"ticket"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.secret forKey:@"secret"];
    [aCoder encodeObject:self.renewal forKey:@"renewal"];
    
    [aCoder encodeObject:self.bachelorUniv forKey:@"bachelorUniv"];
    [aCoder encodeObject:self.masterUniv forKey:@"masterUniv"];
    [aCoder encodeObject:self.picture forKey:@"picture"];
    [aCoder encodeObject:self.backgroud forKey:@"backgroud"];
    [aCoder encodeObject:self.highSchool forKey:@"highSchool"];
    
    
    [aCoder encodeInteger:self.displayNameMode forKey:@"displayNameMode"];
    
    [aCoder encodeBool:self.showQQianStranger forKey:@"showQQianStranger"];
    [aCoder encodeBool:self.showQQianAlumni forKey:@"showQQianAlumni"];
    [aCoder encodeBool:self.showUniv forKey:@"showUniv"];
    [aCoder encodeBool:self.searchByName forKey:@"searchByName"];
    
    [aCoder encodeBool:self.notifyReply forKey:@"notifyReply"];
    [aCoder encodeBool:self.notifyAt forKey:@"notifyAt"];
    [aCoder encodeBool:self.notifyUp forKey:@"notifyUp"];
    [aCoder encodeBool:self.notifyApply forKey:@"notifyApply"];
    [aCoder encodeBool:self.notifyAgree forKey:@"notifyAgree"];
    
    [aCoder encodeBool:self.hasSendQianQian forKey:@"hasSendQianQian"];
    
    
    //AutoSend
    [aCoder encodeObject:self.headIconImageKey forKey:@"headIconImageKey"];
    [aCoder encodeObject:self.headBgImageKey forKey:@"headBgImageKey"];
    [aCoder encodeObject:self.headIconImage forKey:@"headIconImage"];
    [aCoder encodeObject:self.headBgImage forKey:@"headBgImage"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.phoneCn = [aDecoder decodeObjectForKey:@"phoneCn"];
        self.phoneAbroad = [aDecoder decodeObjectForKey:@"phoneAbroad"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.homeCity = [aDecoder decodeObjectForKey:@"homeCity"];
        
        self.displayName = [aDecoder decodeObjectForKey:@"displayName"];
        self.fullName = [aDecoder decodeObjectForKey:@"fullName"];
        self.fullNameEn = [aDecoder decodeObjectForKey:@"fullNameEn"];
        
        self.firstNameEn = [aDecoder decodeObjectForKey:@"firstNameEn"];
        self.middleNameEn = [aDecoder decodeObjectForKey:@"middleNameEn"];
        self.lastNameEn = [aDecoder decodeObjectForKey:@"lastNameEn"];

        self.homeCityId = [aDecoder decodeObjectForKey:@"homeCityId"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.sex = [aDecoder decodeIntegerForKey:@"sex"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.ticket = [aDecoder decodeObjectForKey:@"ticket"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.secret = [aDecoder decodeObjectForKey:@"secret"];
        self.renewal = [aDecoder decodeObjectForKey:@"renewal"];
        
        self.bachelorUniv = [aDecoder decodeObjectForKey:@"bachelorUniv"];
        self.masterUniv = [aDecoder decodeObjectForKey:@"masterUniv"];
        self.picture = [aDecoder decodeObjectForKey:@"picture"];
        self.backgroud = [aDecoder decodeObjectForKey:@"backgroud"];
        self.highSchool = [aDecoder decodeObjectForKey:@"highSchool"];
        
        
        self.displayNameMode = [aDecoder decodeIntegerForKey:@"displayNameMode"];
        
        self.showQQianStranger = [aDecoder decodeBoolForKey:@"showQQianStranger"];
        self.showQQianAlumni = [aDecoder decodeBoolForKey:@"showQQianAlumni"];
        self.showUniv = [aDecoder decodeBoolForKey:@"showUniv"];
        self.searchByName = [aDecoder decodeBoolForKey:@"searchByName"];
        
        self.notifyReply = [aDecoder decodeBoolForKey:@"notifyReply"];
        self.notifyAt = [aDecoder decodeBoolForKey:@"notifyAt"];
        self.notifyUp = [aDecoder decodeBoolForKey:@"notifyUp"];
        self.notifyApply = [aDecoder decodeBoolForKey:@"notifyApply"];
        self.notifyAgree = [aDecoder decodeBoolForKey:@"notifyAgree"];
        
        
        self.hasSendQianQian = [aDecoder decodeBoolForKey:@"hasSendQianQian"];
        
        self.headIconImageKey = [aDecoder decodeObjectForKey:@"headIconImageKey"];
        self.headBgImageKey = [aDecoder decodeObjectForKey:@"headBgImageKey"];
        self.headIconImage = [aDecoder decodeObjectForKey:@"headIconImage"];
        self.headBgImage = [aDecoder decodeObjectForKey:@"headBgImage"];
    }
    return self;
}

- (void)setDisplayName:(NSString *)displayName {
    _displayName = displayName;
    _nickName = displayName;
}


- (NSString*)nickName{
    if (self.displayNameMode == 2) {
        return _fullNameEn;
    }
    else {
        return _fullName;
    }
}


+ (HSGHUserInf *)shareManager
{
    static HSGHUserInf *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [HSGHUserInf restoreFormDefault];
        if (!_sharedInstance) {
            _sharedInstance = [[HSGHUserInf alloc] init];
            _sharedInstance.bachelorUniv = [BachelorUniversity new];
            _sharedInstance.masterUniv = [BachelorUniversity new];
            _sharedInstance.highSchool = [BachelorUniversity new];
            _sharedInstance.picture = [HeadPicInfo new];
            _sharedInstance.backgroud = [HeadPicInfo new];
            _sharedInstance.displayNameMode = 1;
            
        }

    });
    return _sharedInstance;
}



+ (void)saveFormNet:(HSGHUserInf*)inf {
    [HSGHUserInf shareManager].userId = inf.userId;
    [HSGHUserInf shareManager].email = inf.email;
    [HSGHUserInf shareManager].phoneCn = inf.phoneCn;
    [HSGHUserInf shareManager].phoneAbroad = inf.phoneAbroad;
    [HSGHUserInf shareManager].firstName = inf.firstName;
    [HSGHUserInf shareManager].lastName = inf.lastName;
    [HSGHUserInf shareManager].sex = inf.sex;
    
    [HSGHUserInf shareManager].firstNameEn = inf.firstNameEn;
    [HSGHUserInf shareManager].lastNameEn = inf.lastNameEn;
    [HSGHUserInf shareManager].middleNameEn = inf.middleNameEn;
    
    [HSGHUserInf shareManager].fullName = inf.fullName;
    [HSGHUserInf shareManager].fullNameEn = inf.fullNameEn;
    [HSGHUserInf shareManager].displayName = inf.displayName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [HSGHUserInf shareManager].bachelorUniv.iconUrl = inf.bachelorUniv.iconUrl;
    [HSGHUserInf shareManager].bachelorUniv.city = inf.bachelorUniv.city;
    [HSGHUserInf shareManager].bachelorUniv.educationalLevel = inf.bachelorUniv.educationalLevel;
    [HSGHUserInf shareManager].bachelorUniv.name = inf.bachelorUniv.name;
    [HSGHUserInf shareManager].bachelorUniv.univId = inf.bachelorUniv.univId;
    [HSGHUserInf shareManager].bachelorUniv.univStatus = inf.bachelorUniv.univStatus;
    [HSGHUserInf shareManager].bachelorUniv.univIn = inf.bachelorUniv.univIn;
    [HSGHUserInf shareManager].bachelorUniv.univOut = inf.bachelorUniv.univOut;

    [HSGHUserInf shareManager].masterUniv.iconUrl = inf.masterUniv.iconUrl;
    [HSGHUserInf shareManager].masterUniv.name = inf.masterUniv.name;
    [HSGHUserInf shareManager].masterUniv.univId = inf.masterUniv.univId;
    [HSGHUserInf shareManager].masterUniv.univStatus = inf.masterUniv.univStatus;
    [HSGHUserInf shareManager].masterUniv.univIn = inf.masterUniv.univIn;
    [HSGHUserInf shareManager].masterUniv.univOut = inf.masterUniv.univOut;
    [HSGHUserInf shareManager].masterUniv.city = inf.masterUniv.city;
    [HSGHUserInf shareManager].masterUniv.educationalLevel = inf.masterUniv.educationalLevel;
    
    [HSGHUserInf shareManager].highSchool.iconUrl = inf.highSchool.iconUrl;
    [HSGHUserInf shareManager].highSchool.name = inf.highSchool.name;
    [HSGHUserInf shareManager].highSchool.univId = inf.highSchool.univId;
    [HSGHUserInf shareManager].highSchool.univStatus = inf.highSchool.univStatus;
    [HSGHUserInf shareManager].highSchool.univIn = inf.highSchool.univIn;
    [HSGHUserInf shareManager].highSchool.univOut = inf.highSchool.univOut;
    [HSGHUserInf shareManager].highSchool.city = inf.highSchool.city;
    [HSGHUserInf shareManager].highSchool.educationalLevel = inf.highSchool.educationalLevel;

    [HSGHUserInf shareManager].picture.key = inf.picture.key;
    [HSGHUserInf shareManager].picture.srcHeight = inf.picture.srcHeight;
    [HSGHUserInf shareManager].picture.srcSize = inf.picture.srcSize;
    [HSGHUserInf shareManager].picture.srcUrl = inf.picture.srcUrl;
    [HSGHUserInf shareManager].picture.srcWidth = inf.picture.srcWidth;
    [HSGHUserInf shareManager].picture.thumbHeight = inf.picture.thumbHeight;
    [HSGHUserInf shareManager].picture.thumbSize = inf.picture.thumbSize;
    [HSGHUserInf shareManager].picture.thumbWidth = inf.picture.thumbWidth;
    [HSGHUserInf shareManager].picture.thumbUrl = inf.picture.thumbUrl;
    
    [HSGHUserInf shareManager].backgroud.key = inf.backgroud.key;
    [HSGHUserInf shareManager].backgroud.srcHeight = inf.backgroud.srcHeight;
    [HSGHUserInf shareManager].backgroud.srcSize = inf.backgroud.srcSize;
    [HSGHUserInf shareManager].backgroud.srcUrl = inf.backgroud.srcUrl;
    [HSGHUserInf shareManager].backgroud.srcWidth = inf.backgroud.srcWidth;
    [HSGHUserInf shareManager].backgroud.thumbHeight = inf.backgroud.thumbHeight;
    [HSGHUserInf shareManager].backgroud.thumbSize = inf.backgroud.thumbSize;
    [HSGHUserInf shareManager].backgroud.thumbWidth = inf.backgroud.thumbWidth;
    [HSGHUserInf shareManager].backgroud.thumbUrl = inf.backgroud.thumbUrl;
    
    
 
    [HSGHUserInf shareManager].signature = inf.signature;
 
    [HSGHUserInf shareManager].homeCityId = inf.homeCityId;
    [HSGHUserInf shareManager].homeCity = inf.homeCity;
    
    [[HSGHUserInf shareManager] saveUserDefault];
    
}

+ (void)saveUserSettings:(HSGHUserInf*)inf  {
    [HSGHUserInf shareManager].displayNameMode = inf.displayNameMode;
    [HSGHUserInf shareManager].showQQianStranger = inf.showQQianStranger;
    [HSGHUserInf shareManager].showQQianAlumni = inf.showQQianAlumni;
    [HSGHUserInf shareManager].showUniv = inf.showUniv;
    
    [HSGHUserInf shareManager].searchByName = inf.searchByName;
    
    [HSGHUserInf shareManager].notifyReply = inf.notifyReply;
    [HSGHUserInf shareManager].notifyAt = inf.notifyAt;
    [HSGHUserInf shareManager].notifyUp = inf.notifyUp;
    [HSGHUserInf shareManager].notifyApply = inf.notifyApply;
    [HSGHUserInf shareManager].notifyAgree = inf.notifyAgree;
    [[HSGHUserInf shareManager] saveUserDefault];
}



+ (void)refreshPSD:(NSString*)password {
    [HSGHUserInf shareManager].password = password;
    [[HSGHUserInf shareManager] saveUserDefault];
}

+ (void)refreshSignature:(NSString*)signature {
    [HSGHUserInf shareManager].signature = signature;
    [[HSGHUserInf shareManager] saveUserDefault];
}

- (void)saveUserDefault {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:data forKey:@"hsghinf"];
    [user synchronize];
}


+ (HSGHUserInf *)restoreFormDefault {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [user objectForKey:@"hsghinf"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)emptyUserDefault {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"hsghinf"];
    [user synchronize];

    [[AppDelegate instanceApplication] clearPushAlias];
}

-(void)releaseSingleton
{
    [HSGHUserInf shareManager].nickName = nil;
}

#pragma mark - public action
- (BOOL)logined {
    return self.userId != nil;
}

+ (BOOL)hasEngName {
    HSGHUserInf* info = [HSGHUserInf shareManager];
    if (info.lastNameEn && info.lastNameEn.length > 0 && info.firstNameEn && info.firstNameEn.length > 0) {
        return true;
    }
    return false;
}

+ (BOOL)hasCompletedInfo {
    HSGHUserInf* info = [HSGHUserInf shareManager];
    if (info.lastName && info.lastName.length > 0 && info.firstName && info.firstName.length > 0) {
        return true;
    }
    return false;
}

+ (void)updateDisplayMode:(BOOL)isCH {
    [HSGHUserInf shareManager].displayNameMode = isCH ? 1 : 2;
    [[HSGHUserInf shareManager] saveUserDefault];
    
    [HSGHSettingsModel modifyUersDisplayNameMode:isCH ? 1 : 2 block:^(BOOL success, NSString *errDes) {
        if (success) {
//            [HSGHUserInf shareManager].displayNameMode = isCH ? 1 : 2;
//            [[HSGHUserInf shareManager] saveUserDefault];
        }
    }];
}


+ (NSString*)fetchRealName {
    if ([HSGHUserInf shareManager].displayNameMode == 2) {
        if (![HSGHUserInf shareManager].fullNameEn || [HSGHUserInf shareManager].fullNameEn.length == 0) {
            if (![HSGHUserInf shareManager].middleNameEn || [HSGHUserInf shareManager].middleNameEn.length == 0) {
                return [NSString stringWithFormat:@"%@ %@", UN_NIL_STR([HSGHUserInf shareManager].firstNameEn), UN_NIL_STR([HSGHUserInf shareManager].lastNameEn)];
            }
            else {
                return [NSString stringWithFormat:@"%@ %@ %@", UN_NIL_STR([HSGHUserInf shareManager].firstNameEn), UN_NIL_STR([HSGHUserInf shareManager].middleNameEn),UN_NIL_STR([HSGHUserInf shareManager].lastNameEn)];
            }
        }
        else {
            return [HSGHUserInf shareManager].fullNameEn;
        }
    }
    else {
        return [HSGHUserInf shareManager].fullName;
    }
}

+ (void)emptyEndYear:(BOOL)isRegular {
    if (isRegular) {
        [HSGHUserInf shareManager].bachelorUniv.univOut = nil;
    }
    else {
        [HSGHUserInf shareManager].masterUniv.univOut = nil;
    }
    
    [[HSGHUserInf shareManager] saveUserDefault];
}


+ (BOOL)hasContainBoardSchool {
    if ([[HSGHUserInf shareManager] logined]) {
        BachelorUniversity* regular = [HSGHUserInf shareManager].bachelorUniv;
        BachelorUniversity* master = [HSGHUserInf shareManager].masterUniv;
        
        if (regular.univId.length == 0 && master.univId.length == 0) {
            return true;
        }
        
        if (regular.univId.length > 0) {
            if (regular.city != 1) {
                return true;
            }
        }
        
        if (master.univId.length > 0) {
            if (master.city != 1) {
                return true;
            }
        }
        
        return false;
    }
    
    return true;
}


+ (BOOL)schoolInfosError {
    if ([[HSGHUserInf shareManager] logined]) {
        BachelorUniversity* regular = [HSGHUserInf shareManager].bachelorUniv;
        BachelorUniversity* master = [HSGHUserInf shareManager].masterUniv;
        
        if (regular.univStatus == 2 && master.univStatus == 2) {
            return true;
        }
        
        if (master.univIn) {
            NSString* masterStartYear = [master convertToStartYear];
            if (regular.univOut) {
                NSString* regularEndYear = [regular convertToEndYear];
                if (masterStartYear.integerValue < regularEndYear.integerValue) {
                    return true;
                }
            }
        }
    }
    return false;
}

@end
