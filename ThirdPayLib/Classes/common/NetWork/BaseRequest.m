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
#import <ifaddrs.h>
#import <arpa/inet.h>

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
        NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)([datenow timeIntervalSince1970]*1000)];
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, [NSString stringWithFormat:@"%@",timeSp], @"seqNo");
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, timeSp, @"time");
        
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, APIVER, @"version");
        
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, @"000001", @"terminalNo");
        
        
        
        EncodeUnEmptyStrObjctToDic(_requestParamDic, currentDateStr, @"batchNo");
        
    }
    return _requestParamDic;
}


// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

-(NSString*)getResolution{
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSLog(@"print %f,%f",width,height);
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    NSString *resolution = [NSString stringWithFormat:@"%d*%d",(int)width*scale_screen,(int)height*scale_screen];
    return resolution;
    
    
}



@end
