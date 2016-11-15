//
//  QRCodeViewController.h
//  Pods
//
//  Created by will on 2016/10/26.
//
//

#import "CommonViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Category.h"
#import "ThirdPay.h"
@protocol QRCodeDelegate <NSObject>
-(void)QRCode:(NSString*)code;
@end

@interface QRCodeViewController : CommonViewController<AVCaptureMetadataOutputObjectsDelegate>

{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    BOOL isReading;
    BOOL qrcodeFlag;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@property(nonatomic,strong)id<QRCodeDelegate> delegate;
@property(nonatomic, weak)id<ThirdPayDelegate> thirdPayDelegate;

@end
