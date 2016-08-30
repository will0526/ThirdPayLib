
//
//  UMSCommonService.m
//  ChinaUMS
//
//  Created by will on 14-3-6.
//  Copyright (c) 2014年 DaveDev. All rights reserved.
//

#import "CommonService.h"
#import "JSONKit.h"
#import "SystemInfo.h"
#import "UIView+MBProgressHUD.h"


#define Request_Timeout_Default  15

@interface CommonService()
{

}

@end

@implementation CommonService

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

//不需要网络通讯图标
+(void)beginService:(BaseRequest *)request
           response:(BaseResponse *)response
            success:(CallBackSuccess)SuccessBlock
             failed:(CallBackFailed)FailedBlock
    showProgressBar:(BOOL)background
{
    [self beginService:request
              response:response
               success:SuccessBlock
                failed:FailedBlock
 withOptionalAnimation:MOPHUDCenterHUDTypePullOut
               timeout:Request_Timeout_Default
       showProgressBar:background
             withTitle:nil
        withController:nil];
}
//强制性动画
+ (void)beginService:(BaseRequest *)request
            response:(BaseResponse *)response
             success:(CallBackSuccess)SuccessBlock
              failed:(CallBackFailed)FailedBlock
          controller:(CommonViewController *)ctl
{
    
    [self beginService:request
              response:response
               success:SuccessBlock
                failed:FailedBlock
 withOptionalAnimation:MOPHUDCenterHUDTypeNetWorkLoading
               timeout:Request_Timeout_Default
       showProgressBar:NO
             withTitle:@""
        withController:ctl];
    
}
//非强制性动画
+ (void)optionalBeginService:(BaseRequest *)request
                    response:(BaseResponse *)response
                     success:(CallBackSuccess)SuccessBlock
                      failed:(CallBackFailed)FailedBlock
                  controller:(CommonViewController *)ctl
{
    
    [self beginService:request
              response:response
               success:SuccessBlock
                failed:FailedBlock
 withOptionalAnimation:MOPHUDCenterHUDTypeNetWorkLoading
               timeout:Request_Timeout_Default
       showProgressBar:YES
             withTitle:@""
        withController:ctl];
    
}

+ (void)beginService:(BaseRequest *)request
            response:(BaseResponse *)response
             success:(CallBackSuccess)SuccessBlock
              failed:(CallBackFailed)FailedBlock
withOptionalAnimation:(MOPHUDCenterHUDType)hudtype
             timeout:(NSInteger)timeout
     showProgressBar:(BOOL)showProgressBar
           withTitle:(NSString*)title
      withController:ctl
{
//
    
    if(showProgressBar)
    {
        
//        [[MOPHUDCenter shareInstance]showHUDWithTitle:title
//                                                 type:hudtype
//                                           controller:ctl
//                                       showBackground:NO];
        [ctl showLoadingView];
    }
    dispatch_queue_t myNetQueue = dispatch_queue_create([@"MYNETQUEUE" UTF8String], NULL);
    dispatch_async
    (myNetQueue, ^{
        
        @try
        {
            [request dtoToDictionary];
            NSLog(@"request>>>>>>>%@",request.requestParamDic);
            request.requestParamDic = [self combileParam:request.requestParamDic];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
            policy.allowInvalidCertificates = YES;
            policy.validatesDomainName = NO;
            manager.securityPolicy = policy;
            
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            
//            NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@""];
            manager.requestSerializer.timeoutInterval = timeout;
            NSLog(@"paramsStr............%@",request.requestParamDic);
            
            [manager POST:BASEURL parameters:request.requestParamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"JSON: %@", responseObject);
               NSString *temp = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSData *jsonData = [temp dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                response.jsonDict = dic;
                
                dispatch_async(dispatch_get_main_queue(), ^ {
//                    if(showProgressBar){
////                        [[MOPHUDCenter shareInstance]removeHUD];
//                        [ctl hidingLoadingView];
//                    }
                    
                    NSString *respcode = EncodeStringFromDic(response.jsonDict, @"code");
                    NSString *msg = EncodeStringFromDic(response.jsonDict, @"message");
                    NSLog(@"response>>>>>>>>>>%@",dic);
                    if ( [respcode isEqualToString:@"0000"]) {
                        
                        if (SuccessBlock)
                        {
                            SuccessBlock(response);
                        }
                        
                    }
                    else if ([respcode isEqualToString:@"9001"])
                    {
                        if (FailedBlock)
                        {
                            if(IsStrEmpty(msg)){
                                msg = @"交易处理超时";
                            }
                            FailedBlock(respcode,msg);
                        }
                    }
                    else{
                        if (FailedBlock)
                        {
                            if(IsStrEmpty(msg)){
                                msg = @"网络请求异常";
                            }
                            FailedBlock(respcode,msg);
                        }
                    }
                    
                });
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                dispatch_async(dispatch_get_main_queue(), ^ {
//                    if(showProgressBar){
//                        [[MOPHUDCenter shareInstance]removeHUD];
//                        [ctl hidingLoadingView];
//                    
//                    }
                    if (FailedBlock)
                    {
                        
                        FailedBlock(nil,nil);
                    }
//                    [ctl presentSheet:@"网络请求异常"];

                });
            
                
            }];
            
        }
        @catch (NSException *exception)
        {
            dispatch_async(dispatch_get_main_queue(), ^ {
                if(showProgressBar){
                    [[MOPHUDCenter shareInstance]removeHUD];
                    [ctl hidingLoadingView];
                }
                if (FailedBlock)
                {
                    NSDictionary *dic = exception.userInfo;
                    NSString *errorCode = [dic objectForKey:@"code"];
                    NSString *errorMsg = [NSString stringWithFormat:@"%@",exception.reason];
                    FailedBlock(errorCode,[self combineErrMsg:errorMsg withErrCode:errorCode]);
                    
                    DLog(@"\nResponse Failed:=============================================\
                              \nErrorCode:%@\
                              \nErrorMsg:%@\
                              \nResponse End:=============================================",
                              errorCode,
                              errorMsg
                              );
                    
                        FailedBlock(errorCode,errorMsg);
                    
                }
            });
        }
        @finally
        {
            
        }
    });
}


+(BOOL)hasServiceError:(NSDictionary *)dic
{
    DLog(@"需要在子类复写");
    return NO;
}

+(NSString *)getServiceErrorCode:(NSDictionary *)dic
{
    DLog(@"需要在子类复写");
    return nil;
}

+(NSString *)getServiceErrorMsg:(NSDictionary *)dic
{
    DLog(@"需要在子类复写");
    return nil;
}

+(NSMutableDictionary *)combileParam:(NSMutableDictionary *) dict{
    
    NSString *textStr = [self Base64Params:dict];
    [dict setObject:textStr forKey:@"params"];
    NSString *sign = [self getParamSign:dict];
    EncodeUnEmptyStrObjctToDic(dict, sign, @"sign");
    
    return dict;

}

+(NSString *)Base64Params:(NSMutableDictionary *)temp{
    NSDictionary *dict = EncodeDicFromDic(temp, @"params");
    NSString *retString = nil;
 
    retString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSData *paramsBase64Data = [[retString dataUsingEncoding:NSUTF8StringEncoding]base64EncodedDataWithOptions:0];
    NSString *paramsDataStr = [NSString stringWithUTF8String:[paramsBase64Data bytes]];
    
    return paramsDataStr;
    
}



/**
 * get all params string
 * @param params
 * @return the String
 */
+(NSString *)getParamSign:(NSDictionary *) dict {
    NSString *retString = nil;
    NSArray *keys = [dict allKeys];
    keys = [keys sortedArrayUsingSelector:@selector(compare:)];
    NSString *key;
    
    for (key in keys)
    {
        if (retString == nil) {
            
            retString = [NSString stringWithFormat:@"%@=%@",key,[dict valueForKey:key]];
        } else {
            NSString *val = [NSString stringWithFormat:@"&%@=%@",key,[dict valueForKey:key]];
            
            retString = [retString stringByAppendingString:val];
        }
    }
    
    retString = [NSString stringWithFormat:@"%@%@",retString,SALT];
    NSLog(@"retString............%@",retString);
    if (!retString) {
        retString = @"";
    }
    
    retString = [[retString md5]uppercaseString];
    
    NSLog(@"retString............%@",retString);
    return retString;
}

//错误信息包含错误代码(如果有)
+(NSString *)combineErrMsg:(NSString *)errMsg withErrCode:(NSString *)errCode {
    if (!errCode) return [NSString stringWithFormat:@"%@",errMsg];//2015-05-26
    return [NSString stringWithFormat:@"%@(%@)",errMsg, errCode];
}




@end
