/*!
 
 @header   EnvironmentConfig.h
 @abstract IOSTempleteProject   
           环境配置文件
 @author   will
 @version  1.0  14-1-24 Creation
 */

#ifndef EnvironmentConfig_h

#define EnvironmentConfig_h

//===============================================================================

#pragma mark -  NetWorkVisible Test Address
#pragma mark    网络畅通测试地址
#define	kNetworkTestAddress						@"www.baidu.com"

//===============================================================================

#pragma mark -  APP Download URL
#pragma mark    应用程序下载地址
#define kAppURL @"www.chinams.com"

//===============================================================================

#pragma mark -  HTTP Host Address
#pragma mark    HTTP服务器域名
//=================================================================================================
//=================================================================================================
//#define kRelease 1
#define kDevelop 1



//显示版本号
//测试环境
#ifdef kRelease

#define VERSION @"1.0.0"//APP版本
#define APIVER @"1"//api版本
#define BASEURL @"http://www.jjing.org/api/"//URL


#define BASEPICURL @"http://www.jjing.org/image/get/"//URL
#define BASEUPLOADPICURL @"http://www.jjing.org/image/uploadMany"//URL

#define APISALT @"ab3e87601534d2ad785eb2d241d59f14"
#define APP_NAME @"jingjing"


#define UmengAppkey @"53ec2b55fd98c559fd01a16b"


#define weixinAppID     @"wx6688088896af3762"
#define weixinAppSecret @"5a33445d8d2b4fc811de515a24bd39ba"


//===============================================================================

//#define __IPHONE_9_0 90000
#elif kDevelop


#define VERSION @"1.0.0"//APP版本
#define APIVER @"1"//api版本


#define BASEURL @"http://www.supdata.com:10023/api/"//URL

 
#define APISALT @"ab3e87601534d2ad785eb2d241d59f14"
#define APP_NAME @"jingjing"


#define UmengAppkey @"53ec2b55fd98c559fd01a16b"

#define weixinAppID     @"wx6688088896af3762"
#define weixinAppSecret @"5a33445d8d2b4fc811de515a24bd39ba"

#define qqAppID  @"1102080086"
#define qqAppKey @"PRyDR7j5OAssahov"

#define share_title @""//分享标题
#define share_content @""//分享内容
#define share_url @""//分享url

#define MapKey @"b0288c11bc7ebd8339ae97cdba0e5875"

#endif

#endif




