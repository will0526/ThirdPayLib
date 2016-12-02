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
 *  @param accountNo         用户号
 *  @param merchantID       商户号
 *  @param merchantOrderID  商户订单号
 *  @param orderTitle        商品名称
 *  @param orderDetail      商品详情
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

@property(nonatomic,strong)NSString *merchantNo;
@property(nonatomic,strong)NSString *accountNo;
@property(nonatomic,strong)NSString *merchantOrderNo;
@property(nonatomic,strong)NSString *orderTitle;
@property(nonatomic,strong)NSString *orderDetail;
@property(nonatomic,strong)NSString *memo;
@property(nonatomic,strong)NSString *totalAmount;
@property(nonatomic,strong)NSString *payAmount;
@property(nonatomic,strong)NSString *notifyURL;
@property(nonatomic,strong)NSString *redPocket;
@property(nonatomic,strong)NSString *memberPoints;
@property(nonatomic,strong)NSString *appScheme;
@property(nonatomic,strong)NSString *viewType;

@property(nonatomic, assign)PayType payType;



@property(nonatomic, weak)id<ThirdPayDelegate> thirdPayDelegate;
@property(nonatomic, weak)UIViewController *viewController;

-(void)bookOrder;

-(Boolean)handleOpenURL:(NSURL *)url withCompletion:(ThirdPayCompletion )complete;

-(void)scanCode:(UIViewController *)controller;

@end
