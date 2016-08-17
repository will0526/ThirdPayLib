

#ifndef EnvironmentConfig_h

#define EnvironmentConfig_h

//#define kRelease 1
#define kDevelop 1



//显示版本号
//测试环境
#ifdef kRelease




//===============================================================================

//#define __IPHONE_9_0 90000
#elif kDevelop

#define RSAKEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCmf7e7F6E2Sxq3SmZLnaLIt5XCTDQzrRWG2JdN2xe5GfMFYlDDKL1Wt2mrtp08nnRmLoL0bMwdKt+S7aIASOs69O4dPyhlkVBRMUUMIt9XIMc7xUFkeRl2tNLvieX++OuHLtuGmaWrZHlqUK5D8dwMGPS/LRJyTQbFQbQx1LgwwIDAQAB"

#define VERSION @"1.0.0"//APP版本
#define APIVER @"1"//api版本


#define BASEURL @"https://pay.pnrtec.com:4443/front/pay/onlineGateway.json"//URL


#define weixinAppID     @"wx6688088896af3762"
#define weixinAppSecret @"5a33445d8d2b4fc811de515a24bd39ba"

#define qqAppID  @"1102080086"
#define qqAppKey @"PRyDR7j5OAssahov"

#define share_title @""//分享标题
#define share_content @""//分享内容
#define share_url @""//分享url

#endif

#endif




