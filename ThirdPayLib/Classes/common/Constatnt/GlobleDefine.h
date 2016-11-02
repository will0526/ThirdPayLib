/*!
 
 @header   GbobleDefine.h
 @abstract IOSTempleteProject
 @author   will
 @version  1.0  14-1-24 Creation
 
 */

#ifndef GbobleDefine_h
#define GbobleDefine_h
#import "SystemInfo.h"
//---------------------------------------------------------------------------------------------
@class BaseResponse;
//----------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------
#pragma mark - Block functions
#pragma mark   block相关
///block 声明
#ifdef NS_BLOCKS_AVAILABLE
typedef void (^BasicBlock)(void);
typedef void (^OperationCallBackBlock)(BOOL isSuccess, NSString *errorMsg);
typedef void (^CallBackBlockWithResult)(BOOL isSuccess, NSString *errorCode,NSString *errorMsg,id result);
typedef void (^ArrayBlock)(NSArray *list);

typedef void (^CallBackSuccess)(BaseResponse *response);
typedef void (^CallBackFailed)(NSString *errorCode,NSString *errorMsg);
typedef void (^CallBackFailedWithResult)(NSString *errorCode,NSString *errorMsg,BaseResponse *response);

#endif


#define TRADESUCCESS @"支付成功"
#define TRADEFAILED @"支付失败"
#define TRADECANCEL @"交易取消"
#define BOOKORDERFAILED @"下单失败"

//第一次进入app侧滑菜单提示=====
#define FIRSTUSEAPP @"firstuseappMenu"//第一点击menu图标

//----------------------------------------------------------------------------------------------
#pragma mark - Thread functions
#pragma mark   GCD线程相关
///线程执行方法 GCD
#define PERFORMSEL_BACK(block) dispatch_async(\
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),\
block)

#define PERFORMSEL_MAIN(block) dispatch_async(dispatch_get_main_queue(),\
block)
//----------------------------------------------------------------------------------------------
#pragma mark - Assert functions
#pragma mark   Assert 断言
//UMSAssert 断言
#define UMSAssert(expression, ...) \
do { if(!(expression)) { \
DLog(@"%@", \
[NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@",\
#expression,\
__PRETTY_FUNCTION__,\
__FILE__, __LINE__, \
[NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); }\
} while(0)
//----------------------------------------------------------------------------------------------
#pragma mark - KVO property stringFormat functions
#pragma mark   KVO 中参数字符串化方法
//# 将宏的参数字符串化，C 函数 strchr 返回字符串中第一个 '.' 字符的位置
#define Keypath(keypath) (strchr(#keypath, '.') + 1)
//----------------------------------------------------------------------------------------------
#pragma mark - Singleton Creation  functions
#pragma mark   单例创建，统一单例命名调用方式
//单例声明 .h中使用
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;
//单例实现创建 .m中使用
#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//----------------------------------------------------------------------------------------------
#pragma mark - Extern and Inline  functions
#pragma mark   内联函数  外联函数

/*／UMS_EXTERN 外联函数*/
#if !defined(UMS_EXTERN)
#  if defined(__cplusplus)
#   define UMS_EXTERN extern "C"
#  else
#   define UMS_EXTERN extern
#  endif
#endif


/*UMS_INLINE 内联函数*/
#if !defined(UMS_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define UMS_INLINE static inline
# elif defined(__cplusplus)
#  define UMS_INLINE static inline
# elif defined(__GNUC__)
#  define UMS_INLINE static __inline__
# else
#  define UMS_INLINE static
# endif
#endif
//----------------------------------------------------------------------------------------------
#pragma mark - Nil or NULL
#pragma mark   为空判断
//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//----------------------------------------------------------------------------------------------
//arc 支持performSelector:
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//----------------------------------------------------------------------------------------------
//日志打印
#ifdef DEBUGLOG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define DLog(...)
#endif

//----------------------------------------------------------------------------------------------
UMS_EXTERN NSString* EncodeObjectFromDic(NSDictionary *dic, NSString *key);

UMS_EXTERN id        safeObjectAtIndex(NSArray *arr, NSInteger index);

UMS_EXTERN NSString     * EncodeStringFromDic(NSDictionary *dic, NSString *key);
UMS_EXTERN NSString* EncodeDefaultStrFromDic(NSDictionary *dic, NSString *key,NSString * defaultStr);
UMS_EXTERN NSNumber     * EncodeNumberFromDic(NSDictionary *dic, NSString *key);
UMS_EXTERN NSDictionary *EncodeDicFromDic(NSDictionary *dic, NSString *key);
UMS_EXTERN NSArray      *EncodeArrayFromDic(NSDictionary *dic, NSString *key);
UMS_EXTERN NSArray      *EncodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic));
UMS_EXTERN void EncodeUnEmptyStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key);
UMS_EXTERN void EncodeUnEmptyObjctToArray(NSMutableArray *arr,id object);
UMS_EXTERN void EncodeDefaultStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key,NSString * defaultStr);
UMS_EXTERN void EncodeUnEmptyDicObjctToDic(NSMutableDictionary *dic,NSDictionary *object, NSString *key);

//----------------------------------------------------------------------------------------------
/*safe release*/
#undef TT_RELEASE_SAFELY
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
__REF = nil;\
}\
}
//----------------------------------------------------------------------------------------------
/*本地化转换[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"IOSTempleteResources"\ofType:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]/*/

#undef L
#define L(key) @"key"


#endif

#define CustomLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:@"AppLanguage"];

#define UserLanguageIsEn  [[[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"] isEqualToString:@"en”];
