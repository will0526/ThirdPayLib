//
//  QureyCampainRequest.m
//  Pods
//
//  Created by will on 2017/3/31.
//
//

#import "QureyCampainRequest.h"

@implementation QureyCampainRequest



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
    
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, self.projectNo, @"projectNo");
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"1015", @"transType");
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"0000", @"payType");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    
    EncodeUnEmptyStrObjctToDic(dic, self.merchantNo, @"merchantNo");
    EncodeUnEmptyDicObjctToDic(self.requestParamDic, dic, @"params");
    
    return self.requestParamDic;
}

@end
