//
//  BookOrderRequest.m
//  Pods
//
//  Created by will on 16/8/16.
//
//

#import "BookOrderRequest.h"
#import "LJSecurityUtils.h"
@implementation BookOrderRequest


- (instancetype)init
{
    self = [super init];
    if (self) {
        _tradeCurrency = @"rmb";
        _tradeTpye = @"";
        
    }
    return self;
}

-(NSDictionary *)dtoToDictionary
{
    [super dtoToDictionary];
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, self.merchantNO, @"merchantNO");
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *uuid = [SystemInfo getUUID];
    NSString *device = [SystemInfo platformString];
    NSString *OS = [SystemInfo osVersion];
    
    
    NSString *ipAdrress = [LJSecurityUtils getIPAddress];
    NSLog(@"ip.....%@",ipAdrress);
    EncodeUnEmptyStrObjctToDic(dic, uuid, @"uuid");
    EncodeUnEmptyStrObjctToDic(dic, VERSION, @"sdkver");
    EncodeUnEmptyStrObjctToDic(dic, @"121.48", @"xlocation");
    EncodeUnEmptyStrObjctToDic(dic, @"31.22", @"ylocation");
    EncodeUnEmptyStrObjctToDic(dic, [NSString stringWithFormat:@"%@%@",device,OS], @"osver");
    
    NSString *payTypeStr = @"";
    switch (self.payType) {
        case PayType_Alipay:
        {
            payTypeStr = @"";
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
    
    EncodeUnEmptyStrObjctToDic(dic, [NSString stringWithFormat:@"%d",self.payType], @"payType");
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
    EncodeUnEmptyStrObjctToDic(dic, self.notifyURL, @"backURL");
    EncodeUnEmptyStrObjctToDic(dic, self.memo, @"attach");
    
    
    EncodeUnEmptyDicObjctToDic(self.requestParamDic, dic, @"params");
    
    
    return self.requestParamDic;
}

@end


