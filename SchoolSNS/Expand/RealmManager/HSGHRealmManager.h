//
//  HSGHRealmManager.h
//  RealmManager
//
//  Created by Huaral on 2017/4/28.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import "HSGHRealmBaseModel.h"
#import <Realm/Realm.h>

//数据库升级Model关系映射
typedef void (^updateDBBlock)();

@interface HSGHRealmManager : NSObject
@property(nonatomic, strong) RLMRealm *realm;

/**
 数据管理者
 @return self
 */
+ (HSGHRealmManager *)sharedManager;

/**
 创建数据库

 @param db 数据库名称 唯一标示
 */
- (void)createRealmDB:(NSString *)db;

/**
 数据库升级

 @param block 映射关系code
 */
- (void)updateDBWithRelation:(updateDBBlock)block;


/**
 添加

 @param modelArray 添加的数组
 */
- (void)insertRealmModel:(NSArray<HSGHRealmBaseModel *> *)modelArray;

/**
 查询
 
 @param baseModel BaseModelInstance
 @param predicate 谓词 查询条件
 @return 查询结果
 */
- (RLMResults *)searchResultsWithClass:(Class<HSGHRealmBaseModel>)baseClass
                         WithPredicate:(NSPredicate *)predicate;
/**
 删除
 
 @param baseModel BaseModelInstance
 @param predicate 谓词 查询条件
 @return 查询结果
 */
- (void)deleteDataWithClass:(Class<HSGHRealmBaseModel>)baseClass
              WithPredicate:(NSPredicate *)predicate ;


@end
