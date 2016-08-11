/*!
 
 @header   SystemInfo.h
 @abstract IOSTempleteProject   
 @author   Sasha
 @version  1.0  14-2-10 Creation
 
 */

#import <Foundation/Foundation.h>

#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

#define IS_IPAD         ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad))
#define IS_IPADz         ([(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) intValue])

#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//#define IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define WIDTH_FIT ([[UIScreen mainScreen] bounds].size.width/320)
#define HEIGHT_FIT (([[UIScreen mainScreen] bounds].size.height-64)/504)
#define IS_IPHONE_4 ([UIScreen mainScreen].bounds.size.height == 480)
@interface SystemInfo : NSObject


/*系统版本*/
+ (NSString *)osVersion;

/*硬件版本*/
+ (NSString *)platform;

/*appName 本应用与后台约定为MOPS*/
+ (NSString *)appName;

/*硬件版本名称*/
+ (NSString *)platformString;

/*系统当前时间 格式：yyyy-MM-dd HH:mm:ss*/
+ (NSString *)systemTimeInfo;

/*软件版本*/
+ (NSString *)appVersion;



/*是否越狱*/
+ (BOOL)isJailBroken;

/*越狱版本*/
+ (NSString *)jailBreaker;

/*本地ip*/
+ (NSString *)localIPAddress;

/*macAddress在iOS7中失效，故改为uuid，使用keychain永久保存达到udid的效果*/
+ (NSString *)getUUID;

@end
