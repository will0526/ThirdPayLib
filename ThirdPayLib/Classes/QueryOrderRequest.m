//
//  QueryOrderRequest.m
//  Pods
//
//  Created by will on 16/8/25.
//
//

#import "QueryOrderRequest.h"

@implementation QueryOrderRequest



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

-(NSDictionary *)dtoToDictionary
{
    [super dtoToDictionary];
    
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, self.merchantNO, @"merchantNo");
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"0010", @"transType");
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"0000", @"payType");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    
    NSString *uuid = [SystemInfo getUUID];
    NSString *device = [SystemInfo platformString];
    NSString *OS = [SystemInfo osVersion];
    NSString *ipAdrress = [self getIPAddress];
//    NSString *ipAdrress = @"192.168.2.1";
    EncodeUnEmptyStrObjctToDic(dic, uuid, @"uuid");
    EncodeUnEmptyStrObjctToDic(dic, VERSION, @"sdkVer");
    EncodeUnEmptyStrObjctToDic(dic, @"121.48", @"xlocation");
    EncodeUnEmptyStrObjctToDic(dic, @"31.22", @"ylocation");
    EncodeUnEmptyStrObjctToDic(dic, ipAdrress, @"ip");
    EncodeUnEmptyStrObjctToDic(dic, [NSString stringWithFormat:@"%@",device], @"device");
    EncodeUnEmptyStrObjctToDic(dic, [NSString stringWithFormat:@"%@",device], @"resolution");
    EncodeUnEmptyStrObjctToDic(dic, [NSString stringWithFormat:@"%@",OS], @"OSver");
    EncodeUnEmptyStrObjctToDic(dic, self.orderNO, @"ippOrderNo");
    
    EncodeUnEmptyDicObjctToDic(self.requestParamDic, dic, @"params");
    
    return self.requestParamDic;
}



@end
