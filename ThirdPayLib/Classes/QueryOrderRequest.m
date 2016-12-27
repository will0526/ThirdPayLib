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
    
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, self.merchantNo, @"merchantNo");
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"0010", @"transType");
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"0000", @"payType");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    EncodeUnEmptyStrObjctToDic(dic, self.orderNO, @"ippOrderNo");
    
    EncodeUnEmptyDicObjctToDic(self.requestParamDic, dic, @"params");
    
    return self.requestParamDic;
}



@end
