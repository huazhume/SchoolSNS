//
//  HSGHRealmBaseModel.h
//  RealmManager
//
//  Created by Huaral on 2017/4/28.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import <Realm/Realm.h>

@interface HSGHRealmBaseModel : RLMObject

@end

// This protocol enables typed collections. i.e.:
// RLMArray<HSGHRealmBaseModel *><HSGHRealmBaseModel>
RLM_ARRAY_TYPE(HSGHRealmBaseModel)
