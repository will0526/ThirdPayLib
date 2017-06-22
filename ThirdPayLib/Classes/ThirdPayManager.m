//
//  ThirdPayViewController.m
//  Pods
//
//  Created by will on 2017/5/24.
//
//

#import "ThirdPayManager.h"

#import <BaiduWallet_Portal/BDWalletSDKMainManager.h>

#import <AlipaySDK/AlipaySDK.h>
//#import "BestpaySDK.h"
//#import "BestpayNativeModel.h"
#import "WXApi.h"

#define IsEmptyStr(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

static NSString *scheme;
@interface ThirdPayManager ()<WXApiDelegate,BDWalletSDKMainManagerDelegate>

@property(nonatomic,strong)UIViewController *rootView;

@property(nonatomic,strong)NSString *orderString;
@property(nonatomic,strong)NSString *alipaySign;
@property(nonatomic,strong)NSString *appSchemeStr;
@property(nonatomic,strong)CallBack callback;
@property(nonatomic,assign)ThirdPayType  thirdPayType;


@end

@implementation ThirdPayManager

static ThirdPayManager *defaultThirdPayManager = nil;

+ (ThirdPayManager *)getThirdPayManagerInstance
{
    @synchronized(self){
        if (defaultThirdPayManager == nil) {
            defaultThirdPayManager = [[ThirdPayManager alloc] init];
        }
    }
    return defaultThirdPayManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (defaultThirdPayManager == nil)
        {
            defaultThirdPayManager = [super allocWithZone:zone];
            
            return defaultThirdPayManager;
        }
        
    }
    return nil;
}

+(void)setAppSchemeStr:(NSString *)appSchemeStr{
    scheme = appSchemeStr;
    [ThirdPayManager getThirdPayManagerInstance];
    

}
+(void)setViewController:(UIViewController *)viewController{
    [ThirdPayManager getThirdPayManagerInstance];
    
    defaultThirdPayManager.rootView = viewController;
}

+(void)pay:(NSString *)OrderInfo payType:(ThirdPayType )payType CallBack:(CallBack)callBack1{
    defaultThirdPayManager = [ThirdPayManager getThirdPayManagerInstance];
    
    if (!OrderInfo || [OrderInfo isEqualToString:@""]) {
        
        [ThirdPayManager tradeReturn:ThirdPayResult_EXCEPTION];
        return;
    }
    
    if(nil == payType || callBack1 == nil){
        
        [ThirdPayManager tradeReturn:ThirdPayResult_EXCEPTION];
        return;
    }
    
    defaultThirdPayManager.appSchemeStr = scheme;
    defaultThirdPayManager.orderString = OrderInfo;
    defaultThirdPayManager.thirdPayType = payType;
    defaultThirdPayManager.callback = callBack1;
    switch (payType) {
        case ThirdPayType_Alipay:
        {
            [self alipay];
        }
            break;
        case ThirdPayType_YiPay:
        {
            [self yipay];
            
        }
            break;
        case ThirdPayType_WeichatPay:
        {
            [self weixinpay];
        }
            break;
            
        case ThirdPayType_BaiduPay:
        {
            [self baiduPay];
        }
            break;
        case ThirdPayType_ApplePay:
        {
            [self applePay];
        }
            break;
            
        default:{
            [ThirdPayManager tradeReturn:ThirdPayResult_EXCEPTION];
            return;
            
        }
            break;
    }
    
    
}


//百度钱包

+(void)baiduPay{
    
    
    BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
    [payMainManager setDelegate:defaultThirdPayManager];
    [payMainManager setRootViewController:defaultThirdPayManager.rootView];
    
    [payMainManager doPayWithOrderInfo:defaultThirdPayManager.orderString params:nil delegate:defaultThirdPayManager];
    
}

//百度回调
-(void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString*)payDescs{
    
    
    if (statusCode == 0) {
        
        NSLog(@"成功");
        [ThirdPayManager tradeReturn:ThirdPayResult_SUCCESS];
        
    } else if (statusCode == 1) {
        NSLog(@"支付中");
        [ThirdPayManager tradeReturn:ThirdPayResult_PAYING];
    } else if (statusCode == 2) {
        [ThirdPayManager tradeReturn:ThirdPayResult_CANCEL];
        
        NSLog(@"取消");
    }
    
    
    
}

+(void)tradeReturn:(ThirdPayResult)result{
    //    code 0000 成功
    //    code 0010 取消
    //    code 1000 失败
    //    code 2000 支付中
    //    code 3000 参数异常
    //    code 9999 支付方式未实现
    
    NSString *message = @"";
    switch (result) {
        case ThirdPayResult_CANCEL:
            message = @"交易取消";
            break;
        case ThirdPayResult_SUCCESS:
            message = @"支付成功";
            break;
        case ThirdPayResult_EXCEPTION:
            message = @"参数异常";
            break;
        case ThirdPayResult_UNKNOWTYPE:
            message = @"支付方式未实现";
            break;
        case ThirdPayResult_PAYING:
            message = @"支付中";
            break;
        case ThirdPayResult_FAILED:
            message = @"支付失败";
            break;
        default:
            break;
    }
    
    if(defaultThirdPayManager.callback){
        defaultThirdPayManager.callback(result,message,defaultThirdPayManager.alipaySign);
    }
}

//支付宝
+(void)alipay{
    
    [[AlipaySDK defaultService] payOrder:defaultThirdPayManager.orderString fromScheme:defaultThirdPayManager.appSchemeStr callback:^(NSDictionary *result) {
        NSString *resultStatus = [self encodeStringFromDic:result key:@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            [self tradeReturn:ThirdPayResult_SUCCESS];
        }else if ([resultStatus isEqualToString:@"6001"]){
            [self tradeReturn:ThirdPayResult_CANCEL];
        }else{
            [self tradeReturn:ThirdPayResult_FAILED];
        }
        
    }];
}


//微信
+(void)weixinpay{
    
    NSData *jsonData = [defaultThirdPayManager.orderString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    
    NSString *weixinAppID = [self encodeStringFromDic:dic key:@"appid"];

    [WXApi registerApp:weixinAppID];
    
    NSString *partnerId = [self encodeStringFromDic:dic key:@"partnerid"];
    
    NSString *prepayId = [self encodeStringFromDic:dic key: @"prepayid"];
    NSString *package = [self encodeStringFromDic:dic key:@"packageVal"];
    if(nil == package){
        package = [self encodeStringFromDic:dic key:@"package"];
    }
    NSString *nonceStr= [self encodeStringFromDic:dic key:@"noncestr"];
    NSString *timeSp = [self encodeStringFromDic:dic key:@"timestamp"];
    
    NSString *sign= [self encodeStringFromDic:dic key:@"sign"];
    
    if (IsEmptyStr(weixinAppID) || IsEmptyStr(partnerId) || IsEmptyStr(prepayId) || IsEmptyStr(package) || IsEmptyStr(nonceStr) || IsEmptyStr(timeSp) || IsEmptyStr(sign)) {
        
        
        [self tradeReturn:ThirdPayResult_EXCEPTION];
    }else{
        
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = partnerId;
        request.prepayId= prepayId;
        request.package = package;
        request.nonceStr= nonceStr;
        request.timeStamp= [timeSp intValue];
        request.sign= sign;
        [WXApi sendReq:request];
    }
    
    
    
}

+(BOOL)wechatInstalled{
    
    return [WXApi isWXAppInstalled];

}

//微信回调

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp * response=(PayResp*)resp;
        
        switch(response.errCode){
            case WXSuccess:
            {
                [ThirdPayManager tradeReturn:ThirdPayResult_SUCCESS];
            }
                break;
            case WXErrCodeUserCancel:
            {
                
                [ThirdPayManager tradeReturn:ThirdPayResult_CANCEL];
            }
                break;
            default:
            {
                [ThirdPayManager tradeReturn:ThirdPayResult_FAILED];
            }
                break;
        }
    }
}


//翼支付
+(void)yipay{
    
    [ThirdPayManager tradeReturn:ThirdPayResult_UNKNOWTYPE];
//    DDLog(@"跳转支付页面带入信息:", OrderString);
//    
//    NSString *scheml = appSchemeStr;
//    
//    BestpayNativeModel *order =[[BestpayNativeModel alloc]init];
//    order.orderInfo = OrderString;
//    order.launchType = launchTypePay1;
//    order.scheme = scheml;
//    
//    
//    @try {
//        [BestpaySDK payWithOrder:order fromViewController:self callback:^(NSDictionary *resultDic) {
//            NSLog(@"%@",resultDic);
//        }];
//        
//    } @catch (NSException *exception) {
//        [self tradeReturn:ThirdPayResult_EXCEPTION];
//        
//    } @finally {
//        
//    }
    
    
}


+(void)applePay{
    
   [ThirdPayManager tradeReturn:ThirdPayResult_UNKNOWTYPE];
    
}



+(BOOL)handleOpenURL:(NSURL *)url{
    
    if (!url) {
        [ThirdPayManager tradeReturn:ThirdPayResult_EXCEPTION];
        return YES;
    }
    
    
    switch (defaultThirdPayManager.thirdPayType) {
        case ThirdPayType_YiPay:{
//            [BestpaySDK processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"确保结果显示不会出错：%@",resultDic);
//            }];
//            
//            NSString* params =[url absoluteString];
//            NSDictionary *dic = [self paramsFromString:params];
//            NSString *resultCode = EncodeStringFromDic(dic, @"resultCode");
//            if ([resultCode isEqualToString:@"00"]) {
//               
//                [self tradeReturn:ThirdPayResult_SUCCESS];
//            }else if([resultCode isEqualToString:@"01"]){
//                [self tradeReturn:ThirdPayResult_FAILED];
//                
//            }else if([resultCode isEqualToString:@"02"]){
//                
//                [self tradeReturn:ThirdPayResult_CANCEL];
//            }
            
        }
            break;
        case ThirdPayType_Alipay:{
            
            if ([url.host isEqualToString:@"safepay"]) {
                
                //跳转支付宝钱包进行支付，处理支付结果
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    
                    NSLog(@"result = %@",resultDic);
                    
                    NSString *resultStatus = [self encodeStringFromDic:resultDic key:@"resultStatus"];
                    if ([resultStatus isEqualToString:@"9000"]) {
                        defaultThirdPayManager.alipaySign = [self encodeStringFromDic:resultDic key:@"result"];
                        
                        [ThirdPayManager tradeReturn:ThirdPayResult_SUCCESS];
                        
                    }else if ([resultStatus isEqualToString:@"6001"]){
                        
                        [ThirdPayManager tradeReturn:ThirdPayResult_CANCEL];
                    }else{
                        
                        [ThirdPayManager tradeReturn:ThirdPayResult_FAILED];
                    }
                    
                }];
                
            }
            break;
        }
        case ThirdPayType_WeichatPay:{
            
            if ([url.scheme hasPrefix:@"wx"]&&[url.host isEqualToString:@"pay"]) {
                [WXApi handleOpenURL:url delegate:defaultThirdPayManager];
                return YES;
            }else{
                return NO;
            }
            
            break;
        }
        default:
        {
            return NO;
        }
            break;
    }
    
    return YES;
    
}

+(NSString *)encodeStringFromDic:(NSDictionary *)dic key:(NSString *)key
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSString class]])
    {
        return temp;
    }
    else if ([temp isKindOfClass:[NSNumber class]])
    {
        return [temp stringValue];
    }
    return nil;
}

+(NSDictionary *)paramsFromString:(NSString *)urlStr
{
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (urlStr == nil || [urlStr isEqualToString:@""] || ![urlStr hasPrefix:defaultThirdPayManager.appSchemeStr])
    {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *str = [urlStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://",defaultThirdPayManager.appSchemeStr] withString:@""];
    
    if ([str isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *array = [str componentsSeparatedByString:@"&"];
    
    if ([array count])
    {
        NSDictionary *tmpDic = [[self class] paramsFromKeyValueStr:str];
        [dic setDictionary:tmpDic];
    }
    
    return dic;
}

+ (NSDictionary *)paramsFromKeyValueStr:(NSString *)str
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray *array = [str componentsSeparatedByString:@"&"];
    
    if ([array count]) {
        for (int i = 0; i < [array count]; i ++) {
            NSString *pStr = [array objectAtIndex:i];
            NSArray *kvArray = [pStr componentsSeparatedByString:@"="];
            if ([kvArray count] != 2) {
                continue;
            }
            NSString *key = [kvArray objectAtIndex:0];
            key = [key stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            NSString *value = [kvArray objectAtIndex:1];
            value = [value stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            
            [dic setObject:value forKey:key];
        }
    }
    
    return dic;
}




@end
