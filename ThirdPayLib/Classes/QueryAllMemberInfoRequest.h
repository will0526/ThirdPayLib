//
//  QueryAllMemberInfoRequest.h
//  Pods
//
//  Created by will on 2016/12/27.
//
//

#import "BaseRequest.h"

@interface QueryAllMemberInfoRequest : BaseRequest

//用户所有权益查询


@property(nonatomic,strong)NSString *merchantNo;        //商户号
@property(nonatomic,strong)NSString *projectNo;        //项目号
@property(nonatomic,strong)NSString *accountType;       //用户类型
@property(nonatomic,strong)NSString *accountNo;         //用户号


@end
