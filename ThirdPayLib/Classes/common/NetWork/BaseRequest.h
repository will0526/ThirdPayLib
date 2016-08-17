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


@property (nonatomic , strong) NSString * commandId;
@property (nonatomic , strong) NSString * messageType;

@property (nonatomic, strong) NSMutableDictionary  *requestParamDic;

-(NSString *)getCommandId;

-(NSDictionary *)dtoToDictionary;
@end
