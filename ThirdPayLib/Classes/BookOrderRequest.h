//
//  BookOrderRequest.h
//  Pods
//
//  Created by will on 16/8/16.
//
//

#import "BaseRequest.h"
#import "ThirdPay.h"
@interface BookOrderRequest : BaseRequest

/**
 *  订单支付，无支付方式选择，支付方式通过payType传递
 *  字典tradeinfo 内字段如下
 *  @param memberNo         用户号
 *  @param merchantID       商户号
 *  @param merchantOrderID  商户订单号
 *  @param goodsName        商品名称
 *  @param goodsDetail      商品详情
 *  @param memo             备注
 *  @param totalAmount      订单总金额（分）
 *  @param payAmount        待支付金额（分）
 *  @param redPocket        红包金额（分）
 *  @param memberPoints     积分金额（分）
 
 
 *  @param controller       调用接口的view
 *  @param delegate         回调代理
 *  @param payType          支付类型
 */

@property(nonatomic,strong)NSString *merchantNO;        //商户号
@property(nonatomic,strong)NSString *memberNO;          //用户号
@property(nonatomic,strong)NSString *merchantOrderNO;   //商户订单号
@property(nonatomic,strong)NSString *goodsName;         //商品名称
@property(nonatomic,strong)NSString *goodsDetail;       //商品详情
@property(nonatomic,strong)NSString *memo;              //订单备注
@property(nonatomic,strong)NSString *totalAmount;       //订单总金额
@property(nonatomic,strong)NSString *payAmount;         //订单支付金额

@property(nonatomic,assign)PayType payType;         //订单支付方式



@property(nonatomic,strong)NSString *tradeTpye;         //调用类型(线上)
@property(nonatomic,strong)NSString *redPocket;         //红包金额
@property(nonatomic,strong)NSString *memberPoints;      //积分金额
@property(nonatomic,strong)NSString *tradeCurrency;     //币种 （RMB）


@end
