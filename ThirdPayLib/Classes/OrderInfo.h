//
//  OrderInfo.h
//  Pods
//
//  Created by will on 16/9/9.
//
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject


@property(nonatomic,strong)NSString *merchantNO;        //商户号
@property(nonatomic,strong)NSString *memberNO;          //用户号
@property(nonatomic,strong)NSString *merchantOrderNO;   //商户订单号
@property(nonatomic,strong)NSString *goodsName;         //商品名称
@property(nonatomic,strong)NSString *goodsDetail;       //商品详情
@property(nonatomic,strong)NSString *memo;              //订单备注
@property(nonatomic,strong)NSString *totalAmount;       //订单总金额
@property(nonatomic,strong)NSString *payAmount;         //订单支付金额


@property(nonatomic,strong)NSString *redPocket;         //红包金额
@property(nonatomic,strong)NSString *memberPoints;      //积分金额

@property(nonatomic,strong)NSString *notifyURL;
@property(nonatomic,strong)NSString *appSchemeStr;

@end
