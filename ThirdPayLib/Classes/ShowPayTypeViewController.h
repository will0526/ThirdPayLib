//
//  ShowPayTypeViewController.h
//  Pods
//
//  Created by will on 16/8/10.
//
//

#import <UIKit/UIKit.h>
#import "ThirdPay.h"
#import "CommonViewController.h"
@interface ShowPayTypeViewController :CommonViewController





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
 *  @param memberPoints     积分抵扣金额（分）
 *  @param notifyURL        后台通知地址
 
 *  @param controller       调用接口的view
 *  @param delegate         回调代理
 *  @param payType          支付方式
 */

@property(nonatomic,strong)NSString *merchantNO;
@property(nonatomic,strong)NSString *memberNO;
@property(nonatomic,strong)NSString *merchantOrderNO;
@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,strong)NSString *goodsDetail;
@property(nonatomic,strong)NSString *memo;
@property(nonatomic,strong)NSString *totalAmount;
@property(nonatomic,strong)NSString *payAmount;
@property(nonatomic,strong)NSString *notifyURL;
@property(nonatomic,strong)NSString *redPocket;
@property(nonatomic,strong)NSString *memberPoints;

@property(nonatomic, weak)id<ThirdPayDelegate> thirdPayDelegate;

@end
