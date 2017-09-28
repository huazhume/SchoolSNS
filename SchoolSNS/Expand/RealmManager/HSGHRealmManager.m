//
//  HSGHRealmManager.m
//  RealmManager
//
//  Created by Huaral on 2017/4/28.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import "HSGHRealmManager.h"
#import "HSGHMediaFileManager.h"
#import "HSGHSanboxFile.h"
#import "HSGHRealmBaseModel.h"
#import "HSGHRealmManager.h"

@implementation HSGHRealmManager

/**
 数据管理者

 @param db 用户唯一标示 数据库名称
 @return self
 */

+ (HSGHRealmManager *)sharedManager {

  static HSGHRealmManager *sharedInstance = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    //初始化
    sharedInstance = [[self alloc] init];
  });

  return sharedInstance;
}

/**
 创建数据库
 
 @param db 数据库名称 唯一标示
 */
- (void)createRealmDB:(NSString *)db {
  //创建Realm数据库
  NSString *dbPath = [[[HSGHMediaFileManager sharedManager]
      getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE
                           AndMediaType:FILE_DB_TYPE]
      stringByAppendingPathComponent:[NSString
                                         stringWithFormat:@"%@.realm", db]];
  if ([HSGHSanboxFile isFileExists:dbPath]) {
    //存在
  } else {
    //不存在 则创建
    [self setDefaultRealmForUser:db];
  }
  self.realm = [RLMRealm realmWithURL:[NSURL fileURLWithPath:dbPath]];
}

/**
 根据用户唯一标示建立数据库

 @param username 用户唯一标示
 */
- (void)setDefaultRealmForUser:(NSString *)username {

  RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
  // 使用默认的目录，但是使用用户名来替换默认的文件名
  config.fileURL = [[[[NSURL
      fileURLWithPath:[[HSGHMediaFileManager sharedManager]
                          getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE
                                               AndMediaType:FILE_DB_TYPE]]
      URLByDeletingLastPathComponent] URLByAppendingPathComponent:username]
      URLByAppendingPathExtension:@"realm"];
  // 将这个配置应用到默认的 Realm 数据库当中
  [RLMRealmConfiguration setDefaultConfiguration:config];
}

/**
 增加

 @param modelArray 数组
 */
- (void)insertRealmModel:(NSArray<HSGHRealmBaseModel *> *)modelArray {
  [self.realm beginWriteTransaction];
  for (int i = 0; i < modelArray.count; i++) {
    [self.realm addObject:modelArray[i]];
  }
  [self.realm commitWriteTransaction];
}
//删除

//修改

/**
 查询

 @param baseModel BaseModelInstance
 @param predicate 谓词 查询条件
 @return 查询结果
 */
- (RLMResults *)searchResultsWithClass:(Class<HSGHRealmBaseModel>)baseClass
                         WithPredicate:(NSPredicate *)predicate {
  RLMResults *tan = [baseClass.class objectsInRealm:[HSGHRealmManager sharedManager].realm withPredicate:predicate];
    
  return tan;
}


- (void)deleteDataWithClass:(Class<HSGHRealmBaseModel>)baseClass
              WithPredicate:(NSPredicate *)predicate{
    RLMResults * tan = [self searchResultsWithClass:baseClass WithPredicate:predicate];
    [[HSGHRealmManager sharedManager].realm beginWriteTransaction];
    for(int i = 0; i < tan.count ; i ++){
         [[HSGHRealmManager sharedManager].realm deleteObject:tan[i]];
    }
    [[HSGHRealmManager sharedManager].realm commitWriteTransaction];
}


//- (void)deleteAllDataWithClass:(Class<HSGHRealmBaseModel>)baseClass {
//    [[HSGHRealmManager sharedManager].realm beginWriteTransaction];
//    [[HSGHRealmManager sharedManager].realm commitWriteTransaction];
//}


/**
 数据库升级

 @param block 映射关系code
 */
- (void)updateDBWithRelation:(updateDBBlock)block {
  self.realm.configuration.schemaVersion =
      self.realm.configuration.schemaVersion + 1; //版本号加1
  self.realm.configuration.migrationBlock =
      ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
          // enumerateObjects:block: 方法遍历了存储在 Realm
          // 文件中的每一个“Person”对象
          //            [migration enumerateObjects:Person.className
          //                                  block:^(RLMObject *oldObject,
          //                                  RLMObject *newObject) {
          //
          //                                      // 将名字进行合并，存放在
          //                                      fullName 域中
          //                                      newObject[@"fullName"] =
          //                                      [NSString
          //                                      stringWithFormat:@"%@ %@",
          //                                                                oldObject[@"firstName"],
          //                                                                oldObject[@"lastName"]];
          //                                  }];
          //重新映射关系
          block();
        }
      };
  [RLMRealmConfiguration setDefaultConfiguration:self.realm.configuration];
}





@end

