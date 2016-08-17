//
//  SBaseResponse.h
//  UMSCashier
//
//  Created by will on 14-3-16.
//  Copyright (c) 2014年 UMS. All rights reserved.
//

@interface BaseResponse : NSObject
{
    NSDictionary * jsonDict;    
}

@property (nonatomic , strong)  NSDictionary * jsonDict;


-(NSDictionary *)getJsonDict;

-(void)praseJsondicttoResponse;

//-(CommonDTO *)dtoToDictionary:(NSDictionary *)jsonDict;

@end
