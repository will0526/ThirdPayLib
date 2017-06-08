//
//  ThirdPay.h
//  Pods
//
//  Created by will on 16/8/10.
//
//

#define weixinAppID     @"wxd74f10be104372ab"
#define weixinAppSecret @"16361bdf5841fbb95a42376101febdd1"

#import <Foundation/Foundation.h>
@class PNROrderInfo;

@class PNRMemberInfo;

typedef enum{
    PayStatus_PAYFAIL,                 //交易失败
    PayStatus_PAYSUCCESS,              //交易成功
    PayStatus_PAYTIMEOUT,              //交易超时
    PayStatus_PAYCANCEL,               //交易取消
    
}PayStatus;


typedef enum{
    PayType_Alipay,           //支付宝
    PayType_WeichatPay,       //微信
    PayType_ApplePay,         //Apple Pay
    PayType_YiPay,            //翼支付
    PayType_BaiduPay          //百度钱包
    
}PayType;

typedef enum{
    
    TradeType_Online,        //01网上订单
    TradeType_Offline,       //02
}TradeType;

typedef void (^ThirdPayCompletion)(NSDictionary *result);

@protocol ThirdPayDelegate <NSObject>

@optional

/*
 //
 */
//支付结果回调 （两个支付方式，回调结果方法一致）
-(void)onPayResult:(PayStatus) payStatus withInfo:(NSDictionary *)dict;



/*
 orderId    订单号;
 orderState  订单状态;
 pay
 memo          备注
 */

//订单查询回调
-(void)onQueryOrder:(NSDictionary *)dict;

//营销查询
-(void)onQueryCampain:(NSDictionary *)dict;

//针对订单用户权益查询查询回调
-(void)onQueryMemberForOrder:(NSDictionary *)dict;

//用户所有权益查询
-(void)onQueryMember:(NSDictionary *)dict;


@end




@interface ThirdPay : NSObject



/**
 *  订单支付，无支付方式选择，支付方式通过payType传递
 *  字典tradeinfo 内字段如下
 *  @param controller       调用接口的view
 *  @param delegate         回调代理
 */
+(void)payWithTradeInfo:(PNROrderInfo *)orderInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate ;



/**
 *  订单查询 (推荐使用)
 *
 *  tradeInfo内容包含以下字段
 
 *  @param controller       调用接口的UIViewController
 *  @param delegate         回调代理
 */

+(void)queryOrderInfo:(PNROrderInfo *)orderInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate;


/**
 *  用户权益查询
 *
 *  memberInfo下单用户账户信息，下单前查询用户可用权益
 
 *  @param controller       调用接口的UIViewController
 *  @param delegate         回调代理
 */

+(void)queryMemberInfoForOrder:(PNRMemberInfo *)memberInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate;

/**
 *  用户所有权益查询
 *
 *  memberInfo下单用户账户信息，下单前查询用户可用权益
 
 *  @param controller       调用接口的UIViewController
 *  @param delegate         回调代理
 */

+(void)queryMemberInfo:(PNRMemberInfo *)memberInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate;


/**
 *  订单支付，展示支付方式选择页面
 
 
 *  @param controller       调用接口的view
 *  @param delegate         回调代理
 */
+(void)showPayTypeWithTradeInfo:(PNROrderInfo *)orderInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate;


+(void)queryCampaign:(PNRMemberInfo *)memberInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate;


+(Boolean)handleOpenURL:(NSURL *)url withCompletion:(ThirdPayCompletion )complete;

+(void)scanQRCode:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate;


@end
