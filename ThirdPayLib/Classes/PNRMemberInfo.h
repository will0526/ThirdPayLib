//
//  PNRMemberInfo.h
//  Pods
//
//  Created by will on 2016/12/23.
//
//

#import <Foundation/Foundation.h>

@interface PNRMemberInfo : NSObject

@property(nonatomic,strong)NSString *accountType;       //手机号2，ERP会员号类型为3
@property(nonatomic,strong)NSString *accountNo;
@property(nonatomic,strong)NSString *orderAmount;
@property(nonatomic,strong)NSString *merchantNo;        //商户号
@property(nonatomic,strong)NSString *projectNo;        //项目号


@end
