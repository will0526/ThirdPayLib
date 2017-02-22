//
//  PNRVoucherInfo.h
//  Pods
//
//  Created by will on 2016/12/12.
//
//

#import <Foundation/Foundation.h>

@interface PNRVoucherInfo : NSObject

//优惠券信息
//
@property(nonatomic,strong)NSString *voucherType;  //支付方式 余额 0，积分1，优惠券 2，消费卡3
@property(nonatomic,strong)NSString *voucherId;     //对应ID（优惠券为对应优惠券ID）

@property(nonatomic,strong)NSString *voucherAmount;     //优惠券支付金额（优惠券为对应优惠券金额）


@end
