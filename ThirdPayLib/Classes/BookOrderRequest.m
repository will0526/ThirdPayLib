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
        _tradeCurrency = @"CNY";
        _tradeTpye = @"online";
        
    }
    return self;
}

-(NSDictionary *)dtoToDictionary
{
    [super dtoToDictionary];
    
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, self.merchantNo, @"merchantNo");
    
    NSString *payTypeStr = @"";
    switch (self.payType) {
        case PayType_Alipay:
        {
            payTypeStr = @"0003";
        }
            break;
        case PayType_WeichatPay:
        {
            payTypeStr = @"0002";
        }
            break;
        case PayType_BaiduPay:
        {
            payTypeStr = @"0006";
        }
            break;
        case PayType_YiPay:
        {
            payTypeStr = @"0004";
        }
            break;
        case PayType_ApplePay:
        {
            payTypeStr = @"0005";
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
    NSString *ipAdrress = [self getIPAddress];
    EncodeUnEmptyStrObjctToDic(dic, uuid, @"uuid");
    EncodeUnEmptyStrObjctToDic(dic, VERSION, @"sdkVer");
    
    EncodeUnEmptyStrObjctToDic(dic, ipAdrress, @"ip");
    EncodeUnEmptyStrObjctToDic(dic, [NSString stringWithFormat:@"%@",OS], @"osVer");
    EncodeUnEmptyStrObjctToDic(dic, [NSString stringWithFormat:@"%@",device], @"device");
    EncodeUnEmptyStrObjctToDic(dic, [self getResolution], @"resolution");
    EncodeUnEmptyStrObjctToDic(dic, self.totalAmount, @"orderAmount");
    EncodeUnEmptyStrObjctToDic(dic, self.payAmount, @"tradeAmount");
    EncodeUnEmptyStrObjctToDic(dic, self.tradeCurrency, @"currency");
    EncodeUnEmptyStrObjctToDic(dic, self.merchantOrderNo, @"orderNo");
    EncodeUnEmptyStrObjctToDic(dic, self.orderTitle, @"orderSubject");
    EncodeUnEmptyStrObjctToDic(dic, self.orderDetail, @"orderDescription");
    EncodeUnEmptyStrObjctToDic(dic, @" ", @"goodsInfo");
    EncodeUnEmptyStrObjctToDic(dic, self.tradeTpye, @"tradeType");
    EncodeUnEmptyStrObjctToDic(dic, self.accountNo, @"accountNo");
    EncodeUnEmptyStrObjctToDic(dic, self.redPocket, @"redPocket");
    EncodeUnEmptyStrObjctToDic(dic, self.memberPoints, @"memberPoints");
    
    EncodeUnEmptyStrObjctToDic(dic, self.notifyURL, @"backURL");
    
    EncodeUnEmptyStrObjctToDic(dic, self.memo, @"attach");
    
    EncodeUnEmptyDicObjctToDic(self.requestParamDic, dic, @"params");
    
    return self.requestParamDic;
}





@end


