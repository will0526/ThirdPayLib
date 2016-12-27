//
//  QueryMemberAllRequest.h
//  Pods
//
//  Created by will on 2016/12/27.
//
//

#import "BaseRequest.h"

@interface QueryMemberAllRequest : BaseRequest

@property(nonatomic,strong)NSString *merchantNo;        //商户号

@property(nonatomic,strong)NSString *accountType;       //用户类型
@property(nonatomic,strong)NSString *accountNo;        //用户号

@end
