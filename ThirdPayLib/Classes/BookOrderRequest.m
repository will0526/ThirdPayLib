//
//  BookOrderRequest.m
//  Pods
//
//  Created by will on 16/8/16.
//
//

#import "BookOrderRequest.h"

@implementation BookOrderRequest


- (instancetype)init
{
    self = [super init];
    if (self) {
        _tradeCurrency = @"rmb";
        _tradeTpye = @"online";
        
    }
    return self;
}

-(NSDictionary *)dtoToDictionary
{
    [super dtoToDictionary];
    
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, self.merchantNO, @"merchantNo");
    
    NSString *payTypeStr = @"";
    switch (self.payType) {
        case PayType_Alipay:
        {
            payTypeStr = @"0003";
        }
            break;
        case PayType_WeichatPay:
        {
            payTypeStr = @"";
        }
            break;
        case PayType_BestPay:
        {
            payTypeStr = @"";
        }
            break;
        case PayType_YiPay:
        {
            payTypeStr = @"";
        }
            break;
            
        default:
            break;
    }
    
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"0009", @"transType");
    
    
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, payTypeStr, @"payType");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    
    NSString *uuid = [SystemInfo getUUID];
    NSString *device = [SystemInfo platformString];
    NSString *OS = [SystemInfo osVersion];
//    NSString *ipAdrress = [LJSecurityUtils getIPAddress];
    NSString *ipAdrress = @"192.168.2.1";
    EncodeUnEmptyStrObjctToDic(dic, uuid, @"uuid");
    EncodeUnEmptyStrObjctToDic(dic, VERSION, @"sdkver");
    EncodeUnEmptyStrObjctToDic(dic, @"121.48", @"xlocation");
    EncodeUnEmptyStrObjctToDic(dic, @"31.22", @"ylocation");
    EncodeUnEmptyStrObjctToDic(dic, ipAdrress, @"ip");
    EncodeUnEmptyStrObjctToDic(dic, [NSString stringWithFormat:@"%@%@",device,OS], @"osver");
    
    
    
    EncodeUnEmptyStrObjctToDic(dic, self.payAmount, @"tradeAmount");
    EncodeUnEmptyStrObjctToDic(dic, self.tradeCurrency, @"tradeCurrency");
    EncodeUnEmptyStrObjctToDic(dic, self.merchantOrderNO, @"orderNo");
    EncodeUnEmptyStrObjctToDic(dic, self.goodsDetail, @"orderSubject");
    EncodeUnEmptyStrObjctToDic(dic, self.goodsDetail, @"orderDescription");
    EncodeUnEmptyStrObjctToDic(dic, self.goodsName, @"goodsName");
    EncodeUnEmptyStrObjctToDic(dic, self.tradeTpye, @"tradeTpye");
    EncodeUnEmptyStrObjctToDic(dic, self.memberNO, @"memberNo");
    EncodeUnEmptyStrObjctToDic(dic, self.redPocket, @"redPocket");
    EncodeUnEmptyStrObjctToDic(dic, self.memberPoints, @"memberPoints");
    
    EncodeUnEmptyStrObjctToDic(dic, @"https://www.baidu.com/", @"backURL");
    
    EncodeUnEmptyStrObjctToDic(dic, self.memo, @"attach");
    
    EncodeUnEmptyDicObjctToDic(self.requestParamDic, dic, @"params");
    
    return self.requestParamDic;
}

@end


