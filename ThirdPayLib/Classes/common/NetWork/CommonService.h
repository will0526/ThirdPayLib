/*!
 
 @header   UMSCommonService.h
 @abstract ChinaUMS   
 @author   will
 @version  1.0  14-3-6 Creation
 
 */

#import <Foundation/Foundation.h>

#import "BaseRequest.h"
#import "BaseResponse.h"
#import "CommonDTO.h"
#import "MOPHUDCenter.h"
#import <AFNetWorking/AFNetworking.h>
#import "CommonViewController.h"
@interface CommonService : NSObject

//不需要网络通讯图标
+(void)beginService:(BaseRequest *)request
           response:(BaseResponse *)response
            success:(CallBackSuccess)SuccessBlock
             failed:(CallBackFailed)FailedBlock
    showProgressBar:(BOOL)background;

//强制性动画
+ (void)beginService:(BaseRequest *)request
            response:(BaseResponse *)response
             success:(CallBackSuccess)SuccessBlock
              failed:(CallBackFailed)FailedBlock
          controller:(CommonViewController *)ctl;
//非强制性动画
+ (void)optionalBeginService:(BaseRequest *)request
                    response:(BaseResponse *)response
                     success:(CallBackSuccess)SuccessBlock
                      failed:(CallBackFailed)FailedBlock
                  controller:(CommonViewController *)ctl;

+ (void)beginService:(BaseRequest *)request
            response:(BaseResponse *)response
             success:(CallBackSuccess)SuccessBlock
              failed:(CallBackFailed)FailedBlock
withOptionalAnimation:(MOPHUDCenterHUDType)hudtype
             timeout:(NSInteger)timeout
     showProgressBar:(BOOL)showProgressBar
           withTitle:(NSString*)title
      withController:ctl;


+(BOOL)hasServiceError:(NSDictionary *)dict;

+(NSString *)getServiceErrorCode:(NSDictionary *)dict;

+(NSString *)getServiceErrorMsg:(NSDictionary *)dict;


@end



