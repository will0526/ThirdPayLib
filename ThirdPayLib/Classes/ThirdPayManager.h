//
//  ThirdPayViewController.h
//  Pods
//
//  Created by will on 2017/5/24.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThirdPayManager : NSObject


typedef NS_ENUM(NSInteger,ThirdPayType){
    ThirdPayType_Alipay =1,           //支付宝
    ThirdPayType_WeichatPay,       //微信
    ThirdPayType_ApplePay,         //Apple Pay
    ThirdPayType_YiPay,            //翼支付
    ThirdPayType_BaiduPay          //百度钱包
    
};

typedef NS_ENUM(NSInteger,ThirdPayResult){
    ThirdPayResult_SUCCESS =1,           //支付成功
    ThirdPayResult_FAILED,       //支付失败
    ThirdPayResult_CANCEL,         //交易取消
    ThirdPayResult_PAYING,            //支付中
    ThirdPayResult_EXCEPTION,          //参数异常
    ThirdPayResult_UNKNOWTYPE          //未实现支付方式
    
    
};

typedef void (^CallBack)(ThirdPayResult code,NSString *message,NSString *alipaySign);

+(void)pay:(NSString *)OrderInfo payType:(ThirdPayType )payType CallBack:(CallBack)callBack;
//支付宝必调
+(void)setAppSchemeStr:(NSString *)appSchemeStr;
//百度钱包必调
+(void)setViewController:(UIViewController *)viewController;


+(BOOL)wechatInstalled;

+(BOOL)handleOpenURL:(NSURL *)url;



@end
