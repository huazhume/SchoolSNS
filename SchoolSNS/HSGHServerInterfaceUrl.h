//
//  HSGHServerInterfaceUrl.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 24/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//
//

#if 0 //1调试模式，0发布模式
#define DWSRocordScreen
#endif

#if 1   //1 外网 0内网

#define HSGHServerLoginHost @"http://api.qiansquare.com:80" // 52.43.57.148
#define HSGHServerImageHost @"http://api.qiansquare.com:80" // 52.43.57.148

#else

#define HSGHServerLoginHost @"http://192.168.0.223:8080"
#define HSGHServerImageHost @"http://192.168.0.223:80"
//#define HSGHServerLoginHost @"http://localhost:8080"


#endif

#define HSGHServerPublicHost @"http://106.14.193.192/interface/hsghhome.php"

/***********------------- Auth  no signature
 * ----------------------------****************/
// Login
#define HSGHServerGetTicketURL                                                 \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/auth/getTicket"]
#define HSGHServerVerityTicketURL                                              \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/auth/"            \
                                                      @"verifyTicket"]
#define HSGHVerifyRenewalURL                                                   \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/auth/verifyRenewal"]

// Change
#define HSGHServerForgetPSDURL                                                 \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/auth/forgetPassword"]
#define HSGHServerResetPSDURL                                                  \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/auth/resetPassword"]
#define HSGHServerReport                                                       \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/user/report"]
#define HSGHServerSuggest                                                      \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/user/suggest"]

// Register
#define HSGHServerLoginURL                                                     \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/auth/login"]
#define HSGHServerRegisterURL                                                  \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/auth/register"]
// SendVerifyCode
#define HSGHServerVerityCodeURL                                                \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/auth/sendVerifyCode"]

/***********------------- message  need signature
 * ----------------------------****************/
#define HSGHMessageCountURL                                                    \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/message/getNewCount"] //消息数
#define HSGHMessageFetchURL                                                    \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/message/query"] //查询消息
#define HSGHMessageResetURL                                                    \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/message/resetNewCount"]
#define HSGHMessageIsReadURL                                                   \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/message/read"]
#define HSGHMessageRemoveURL                                                   \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/message/remove"]

/***********------------- friend  need signature
 * ----------------------------****************/

/***********------------- friend  controller
 * ----------------------------****************/
//获取推荐用户
#define HSGHFriendGetRecommendUsersURL                                         \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friend/getRecommendUsers"]
//获取好友
#define HSGHFriendGetFriendsURL                                                \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/friend/"          \
                                                      @"getFriends"]
//搜索好友
#define HSGHSearchFriendsURL                                                   \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friend/searchUsers"]
//查看给自己发申请的用户列表
#define HSGHHadSendedUsersURL                                                  \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friendApply/user/send"]
//查看给自己发申请的用户列表
#define HSGHHadReceivedUsersURL                                                \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friendApply/user/receive"]
//添加好友
#define HSGHServerFriendApplyURL                                               \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/friendApply/"     \
                                                      @"apply"]

//同意好友申请
#define HSGHServerFriendAgreeURL                                               \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/friendApply/"     \
                                                      @"agree"]

//删除发给我申请的用户
#define HSGHServerReceiveOtherFriendRemoveURL                                  \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friendApply/user/receive/remove"]
//删除我发送过申请的用户
#define HSGHServerSendOtherFriendRemoveURL                                     \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friendApply/user/send/remove"]
//删除指定用户 /web/friend/removeFriend
#define HSGHServerFriendRemoveURL                                              \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friend/removeFriend"]
//删除推荐用户
#define HSGHServerRecommendFriendRemoveURL                                     \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friend/removeRecommendUser"]

//获取全部评论
#define HSGHGetAllReply                                                        \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/getReply"]
#define HSGHGetHotReply                                                        \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/"           \
                                                      @"getReplyHot"]
#define HSGHGetConversationAll                                                 \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/qqian/getConversationAll"]

/***********------------- QQIAN  need signature
 * ----------------------------****************/

#define HSGHHomeQQiansURL                                                      \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/query"]

#define HSGHSearchQQiansURL                                                    \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/"           \
                                                      @"queryByIds"]

#define HSGHHomePublishURL                                                     \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/publish"]

#define HSGHUpCancel                                               \
[HSGHServerLoginHost                                                         \
stringByAppendingPathComponent:@"/web/qqian/upCancel"]

#define HSGHAnonymStatusURL                                                    \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/qqian/getAnonymStatus"]
#define HSGHHomeQQiansUPURL                                                    \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/up"]
#define HSGHHomeQQiansForwardURL                                               \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/forward"]

#define HSGHHomeQQiansForwardCancelURL [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/forwardCancel"]

#define HSGHHomeQQiansReplyURL                                                 \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/reply"]
#define HSGHHomeQQiansPersonURL                                                \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/qqian/query/person"]
#define HSGHHomeQQiansLocationURL                                              \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/qqian/query/location"]
#define HSGHHomeQQiansRecomURL                                                 \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/qqian/query/recommend"]
#define HSGHHomeQQiansFriendDetailURL                                          \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/qqian/query/friend"]
/// web/friendApply/user/receive/query
#define HSGHHomeFriendReceiveDetailURL                                         \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friendApply/user/receive/query"]
#define HSGHHomeFriendSendDetailURL                                            \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friendApply/user/send/query"]
/// web/qqian/query/personMostHot
#define HSGHHomeFriendPersonMostHotDetailURL                                   \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/qqian/query/personMostHot"]

#define HSGHHomeQQiansMsgDetailURL                                             \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/message/getQQianByMessage"]
#define HSGHHomeQQiansUpDetailURL                                              \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/"           \
                                                      @"getUpUsers"]
#define HSGHHomeQQiansReportURL                                                \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/report"]

#define HSGHHomeQQiansReportAndDeleteURL                                       \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/qqian/reportAndDelete"]

#define HSGHHomeTestURL @"http://www.huaral.tech/interface/hsghhome.php"
#define HSGHHomeQQiansRemoveURL                                                \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/qqian/remove"]

/***********------------- User  need signature
 * ----------------------------****************/
#define HSGHHomeModifySignURL                                                  \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/user/modifySign"]
#define HSGHHomeModifyPSDURL                                                   \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/user/modifyPassword"]
#define HSGHHomeBindingURL                                                     \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/user/bind"]
#define HSGHHomeUnBindingURL                                                   \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/user/unbind"]
#define HSGHHomeSettingsSendVerifyCodeURL                                      \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/user/sendVerifyCode"]
#define HSGHHomeModifyUserURL                                                  \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/user/modifyUser"]

#define HSGHHomeModifyUnivURL                                                  \
[HSGHServerLoginHost stringByAppendingPathComponent:@"/web/user/modifyUniv"]

#define HSGHHomeModifyUserSettingsURL                                          \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/user/modifyUserSetting"]
#define HSGHHomeCompleteUserURL                                                \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/user/complete"]

// PrivatePOST /web/user/complete
#define HSGHHomeSettingsShowUnivURL                                            \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/user/modifyShowUniv"]

/***********------------- resource  no  signature
 * ----------------------------****************/
#define HSGHFetchCityURL                                                       \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/resource/city"]
#define HSGHFileUploadURL                                                      \
  [HSGHServerImageHost stringByAppendingPathComponent:@"/upload"]
#define HSGHFetchUnivURL                                                       \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/resource/univ/search"]
#define HSGHFetchAllUnivURL                                                    \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/resource/univ/getAll"]
#define HSGHFetchHighSchoolURL                                                 \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/resource/highSchool/search"]

/***********------------- User  need signature
 * ----------------------------****************/
// User
#define HSGHGetUserURL                                                         \
  [HSGHServerLoginHost stringByAppendingPathComponent:@"/web/user/getUser"]
#define HSGHGetUserSettingsURL                                                 \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/user/getUserSetting"]
#define HSGHZoneGetPublicFriends                                               \
  [HSGHServerLoginHost                                                         \
      stringByAppendingPathComponent:@"/web/friend/getPublicFriends"]



#import <UIKit/UIKit.h>

@interface HSGHServerInterfaceUrl : NSObject

+ (NSString *)LoginURL;

+ (BOOL)isSignatureBlackList:(NSString *)url;
+ (NSString *)deleteHost:(NSString *)url;
@end
