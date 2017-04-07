//
//  BookOrderRequest.h
//  Pods
//
//  Created by will on 16/8/16.
//
//

#import "BaseRequest.h"
#import "ThirdPay.h"
#import "PNRGoodsInfo.h"
#import "PNRVoucherInfo.h"
@interface BookOrderRequest : BaseRequest

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
 *  @param memberPoints     积分金额（分）
 
 
 *  @param controller       调用接口的view
 *  @param delegate         回调代理
 *  @param payType          支付类型
 */

@property(nonatomic,strong)NSString *merchantNo;        //商户号
@property(nonatomic,strong)NSString *accountNo;          //用户号
@property(nonatomic,strong)NSString *accountType;        //用户号类型


@property(nonatomic,strong)NSString *merchantOrderNo;   //商户订单号
@property(nonatomic,strong)NSString *orderTitle;         //商品名称
@property(nonatomic,strong)NSString *orderDetail;       //商品详情
@property(nonatomic,strong)NSString *memo;              //订单备注
@property(nonatomic,strong)NSString *totalAmount;       //订单总金额
@property(nonatomic,strong)NSString *orderAmount;       //订单金额

@property(nonatomic,strong)NSString *payAmount;         //订单支付金额

@property(nonatomic,assign)PayType payType;         //订单支付方式

@property(nonatomic,strong)NSString *appVer;         //app版本号
@property(nonatomic,strong)NSString *appType;        //app类型
@property(nonatomic,strong)NSString *tradeTpye;         //调用类型(线上)
@property(nonatomic,strong)NSString *redPocket;         //红包金额
@property(nonatomic,strong)NSString *memberPoints;      //积分金额
@property(nonatomic,strong)NSString *tradeCurrency;     //币种 （RMB）
@property(nonatomic,strong)NSString *notifyURL;     //通知地址
@property(nonatomic,strong)NSArray *goodsInfo;     //商品信息
@property(nonatomic,strong)NSArray *voucherInfo;     //其他支付信息
@property(nonatomic,strong)NSArray *campaignsInfo;     //其他支付信息

    

@end
