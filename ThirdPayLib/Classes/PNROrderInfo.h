//
//  OrderInfo.h
//  Pods
//
//  Created by will on 16/9/9.
//
//

#import <Foundation/Foundation.h>
#import "ThirdPay.h"
@interface PNROrderInfo : NSObject


@property(nonatomic,strong)NSString *merchantNo;        //商户号
@property(nonatomic,strong)NSString *accountNo;          //用户号
@property(nonatomic,strong)NSString *merchantOrderNo;   //商户订单号

@property(nonatomic,strong)NSString *ippOrderNo;         //平台订单号

@property(nonatomic,strong)NSString *orderSubject;         //订单名称
@property(nonatomic,strong)NSString *orderDescription;       //订单详情
@property(nonatomic,strong)NSString *memo;              //订单备注
@property(nonatomic,strong)NSString *totalAmount;       //订单总金额
@property(nonatomic,strong)NSString *payAmount;         //订单支付金额

@property(nonatomic,strong)NSString *appVer;            //app版本号

@property(nonatomic,strong)NSArray *goodsInfo;          //商品信息数组

@property(nonatomic,strong)NSArray *otherPayInfo;       //其他支付类型信息


@property(nonatomic,strong)NSString *notifyURL;         //后台通知地址
@property(nonatomic,strong)NSString *appSchemeStr;      //支付成功跳转回调

@property(nonatomic, assign)PayType paytype;            //支付方式


@end
