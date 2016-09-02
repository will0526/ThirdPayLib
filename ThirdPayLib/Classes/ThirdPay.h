//
//  ThirdPay.h
//  Pods
//
//  Created by will on 16/8/10.
//
//

#import <Foundation/Foundation.h>
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
    PayType_BestPay             //百度钱包
    
}PayType;

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


@end




@interface ThirdPay : NSObject


//积分金币等用户信息查询


/**
 *  订单支付，无支付方式选择，支付方式通过payType传递
 *  字典tradeinfo 内字段如下
 *  @param memberNO         用户号    （非必传）
 *  @param merchantNO       商户号
 *  @param merchantOrderNO  商户订单号
 *  @param goodsName        商品名称
 *  @param goodsDetail      商品详情
 *  @param memo             备注      （非必传）
 *  @param totalAmount      订单总金额（分）
 *  @param payAmount        待支付金额（分）
 *  @param notifyURL        后台通知地址
 
 *  @param controller       调用接口的view
 *  @param delegate         回调代理
 *  @param payType          支付方式
 */
+(void)payWithTradeInfo:(NSDictionary *)tradeInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate PayType:(PayType)payType;


/**
 *  订单查询 (推荐使用)
 *
 *  tradeInfo内容包含以下字段
 *  @param merchantOrderID 商户订单号
 *  @param orderID    订单号
 *  @param merchantID   商户号
 
 *  @param controller       调用接口的UIViewController
 *  @param delegate         回调代理
 */
+(void)queryOrderInfo:(NSDictionary *)tradeInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate;


/**
 *  订单支付，展示支付方式选择页面
 *  字典tradeinfo 内字段如下
 *  @param memberNo         用户号       （非必传）
 *  @param merchantNO       商户号
 *  @param merchantOrderNO  商户订单号
 *  @param goodsName        商户号
 *  @param goodsDetail      商户号
 *  @param memo             备注         （非必传）
 *  @param totalAmount      订单总金额
 *  @param payAmount        待支付总金额
 
 *  @param controller       调用接口的view
 *  @param delegate         回调代理
 */
+(void)showPayTypeWithTradeInfo:(NSDictionary *)tradeInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate;


+(Boolean)handleOpenURL:(NSURL *)url withCompletion:(ThirdPayCompletion )complete;




@end
