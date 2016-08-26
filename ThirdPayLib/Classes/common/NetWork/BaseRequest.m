//
//  UMSBaseRequest.m
//  UMSCashier
//
//  Created by will on 14-3-16.
//  Copyright (c) 2014年 UMS. All rights reserved.
//

#import "BaseRequest.h"
#import <sys/utsname.h>
#import "SystemInfo.h"
#import "EnvironmentConfig.h"
@implementation BaseRequest

-(id)init
{
    self = [super init];
    if (self)
    {
        [self requestParamDic];
    }
    return self;
}

-(NSDictionary *)dtoToDictionary
{
    return self.requestParamDic;
}

-(NSDictionary *)requestParamDic{

    if (!_requestParamDic) {
        _requestParamDic = [[NSMutableDictionary alloc]init];
        NSDate *datenow = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%d", (long)[datenow timeIntervalSince1970]];
        NSString *uuid = [SystemInfo getUUID];
        EncodeUnEmptyStrObjctToDic(_requestParamDic, [NSString stringWithFormat:@"%@",timeSp], @"seqNo");
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, timeSp, @"time");
        
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, APIVER, @"version");
        
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, self.terminalNo, @"terminalNo");
        EncodeUnEmptyStrObjctToDic(_requestParamDic, @"9999", @"batchNo");
        
    }
    return _requestParamDic;
}

@end