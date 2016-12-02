//
//  QueryOrderRequest.h
//  Pods
//
//  Created by will on 16/8/25.
//
//

#import "BaseRequest.h"

@interface QueryOrderRequest : BaseRequest



@property(nonatomic,strong)NSString *merchantNo;        //商户号

@property(nonatomic,strong)NSString *orderNO;   //订单号




@end
