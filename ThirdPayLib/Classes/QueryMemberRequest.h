//
//  QueryMemberRequest.h
//  Pods
//
//  Created by will on 2016/12/26.
//
//

#import "BaseRequest.h"

@interface QueryMemberRequest : BaseRequest

//用户可用权益查询


@property(nonatomic,strong)NSString *merchantNo;        //商户号
@property(nonatomic,strong)NSString *voucherMerchantNo; //发券商户号

@property(nonatomic,strong)NSString *accountType;       //用户类型
@property(nonatomic,strong)NSString *accountNo;         //用户号

@property(nonatomic,strong)NSString *orderAmount;       //订单金额



@end
