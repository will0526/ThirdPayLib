//
//  ThirdPayViewController.h
//  Pods
//
//  Created by will on 2017/5/24.
//
//

#import <UIKit/UIKit.h>

@interface ThirdPayViewController : UIViewController


typedef enum{
    ThirdPayType_Alipay,           //支付宝
    ThirdPayType_WeichatPay,       //微信
    ThirdPayType_ApplePay,         //Apple Pay
    ThirdPayType_YiPay,            //翼支付
    ThirdPayType_BaiduPay          //百度钱包
    
}ThirdPayType;

typedef enum{
    ThirdPayResult_SUCCESS,           //支付成功
    ThirdPayResult_FAILED,       //支付失败
    ThirdPayResult_CANCEL,         //交易取消
    ThirdPayResult_PAYING,            //支付中
    ThirdPayResult_EXCEPTION,          //参数异常
    ThirdPayResult_UNKNOWTYPE          //未实现支付方式
    
    
}ThirdPayResult;

typedef void (^CallBack)(ThirdPayResult code,NSString *message);

-(void)pay:(NSString *)OrderInfo payType:(ThirdPayType )payType appSchemeStr:(NSString *)appSchemeStr CallBack:(CallBack)callBack;


-(Boolean)handleOpenURL:(NSURL *)url;
@end
