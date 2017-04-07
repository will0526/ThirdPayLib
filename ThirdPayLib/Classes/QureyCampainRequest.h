//
//  QureyCampainRequest.h
//  Pods
//
//  Created by will on 2017/3/31.
//
//
#import "BaseRequest.h"


@interface QureyCampainRequest : BaseRequest

@property(nonatomic,strong)NSString *merchantNo;        //商户号
@property(nonatomic,strong)NSString *pageNo;        //页码
@property(nonatomic,strong)NSString *pageSize;        //每页大小


@end
