//
//  VoucherData.h
//  Pods
//
//  Created by will on 2017/2/8.
//
//

#import <Foundation/Foundation.h>

@interface VoucherData : NSObject


//voucherType	String	固定3位	Y	优惠券类型
//voucherId	String	变长64位	Y	优惠券编码
//voucherNo	String	变长32位	Y	优惠券编号
//startTime	String	固定14位	N	优惠券开始有效期
//expirationTime	String	固定14位	N	优惠券结束有效期
//availableStartTime	String	固定6位	N	可用开始时间
//availableEndTime	String	固定6位	N	可用结束时间
//voucherAmount	Number	-	Y	优惠券面额
//usePayType	payType[]	-	N	优惠券使用渠道
//superposeType	String	固定1位	Y	叠加类型
//satisfyOrderAmount	Number	-	Y	优惠券满足金额
//discount	Number	-	Y	优惠券折扣比例


@property(nonatomic,strong)NSString *voucherType;  //支付方式 余额 0，积分1，优惠券 2，消费卡3
@property(nonatomic,strong)NSString *voucherId;     //对应ID（优惠券为对应优惠券ID）
@property(nonatomic,strong)NSString *voucherNo;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *expirationTime;
@property(nonatomic,strong)NSString *availableStartTime;
@property(nonatomic,strong)NSString *availableEndTime;
@property(nonatomic,strong)NSString *usePayType;
@property(nonatomic,strong)NSString *satisfyOrderAmount;
@property(nonatomic,strong)NSString *discount;
@property(nonatomic,strong)NSString *voucherName;
@property(nonatomic,strong)NSString *voucherDescription;

@property(nonatomic,strong)NSString *voucherAmount;     //优惠券支付金额（优惠券为对应优惠券


@property(nonatomic, assign)BOOL superposeType;

@property(nonatomic, assign)BOOL selected;
+(VoucherData *)initWithDict:(NSDictionary *)dict;

@end
