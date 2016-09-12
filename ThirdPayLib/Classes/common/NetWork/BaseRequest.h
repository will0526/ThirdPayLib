//
//  UMSBaseRequest.h
//  UMSCashier
//
//  Created by will on 14-3-16.
//  Copyright (c) 2014年 UMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDTO.h"
#undef	DEFAULT_POST_TIMEOUT
#define DEFAULT_POST_TIMEOUT		(30.0f)			// 发协议30秒超时
@interface BaseRequest : NSObject

@property (nonatomic, strong) NSMutableDictionary  *requestParamDic;
@property (nonatomic, strong) NSString *terminalNo;
@property (nonatomic, strong) NSString *batchNo;
@property (nonatomic, strong) NSString *transType;

-(NSDictionary *)dtoToDictionary;
- (NSString *)getIPAddress;
@end
