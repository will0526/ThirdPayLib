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
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyMMdd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:datenow];
        NSString *timeSp = [NSString stringWithFormat:@"%d", (long)[datenow timeIntervalSince1970]];
        NSString *uuid = [SystemInfo getUUID];
        EncodeUnEmptyStrObjctToDic(_requestParamDic, [NSString stringWithFormat:@"%@",timeSp], @"seqNo");
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, timeSp, @"time");
        
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, APIVER, @"version");
        
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, @"000001", @"terminalNo");
        
        
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, currentDateStr, @"batchNo");
        
    }
    return _requestParamDic;
}

@end
