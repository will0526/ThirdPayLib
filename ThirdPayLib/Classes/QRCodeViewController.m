//
//  QRCodeViewController.m
//  Pods
//
//  Created by will on 2016/10/26.
//
//

#import "QRCodeViewController.h"
#import "UIImage+SNAdditions.h"
#import "MerchantViewController.h"
@interface QRCodeViewController ()<ThirdPayDelegate>

@end

@implementation QRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [scanButton setBackgroundColor:[UIColor orangeColor]];
    
    scanButton.clipsToBounds = YES;
    scanButton.layer.cornerRadius = 22.5;
    scanButton.frame = CGRectMake(50, 440, self.view.width - 100, 45);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:scanButton];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, scanButton.bottom+20, self.view.width - 30, 30)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.adjustsFontSizeToFitWidth = YES;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.text=@"请扫描商户二维码";
    [self.view addSubview:labIntroudction];
    
    
    //    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
    //    imageView.image = [UIImage imageNamed:@"pick_bg"];
    //    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 130, self.view.width - 100, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    _line.image = [UIImage imageWithColor:[UIColor greenColor]];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    qrcodeFlag = NO;
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 130+2*num, _line.width, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 130+2*num, _line.width, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

-(void)backAction
{
//    MerchantViewController *merchant = [[MerchantViewController alloc]init];
//    
//    [timer invalidate];
//    [_preview removeFromSuperlayer];
//    //         if ([self.delegate respondsToSelector:@selector(QRCode:) ])
//    //         {
//    //             [self.delegate QRCode:QRCode];
//    //         }
//    //
////    NSLog(@"barCode:%@",QRCode);
//    
//    [self.navigationController pushViewController:merchant animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}

- (void)setupCamera
{
    isReading = YES;
    NSError *error;
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (!_input) {
        DDLog(@"setupCamera:%@", [error localizedDescription]);
        return ;
    }
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //_output.rectOfInterest = CGRectMake(20,130,280,280);
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // Create a new serial dispatch queue.
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    [self.output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeAztecCode, nil]];
    //    if (qrcodeFlag)
    //        [self.output setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //    else
    //        [self.output setMetadataObjectTypes:[rNSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(20,130,self.view.width - 40,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!isReading) return;
    
    NSString *QRCode;
    
    if (metadataObjects != nil && [metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        QRCode = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    MerchantViewController *merchant = [[MerchantViewController alloc]init];
    merchant.QRcontent = QRCode;
    
    [timer invalidate];
    [_preview removeFromSuperlayer];
    //         if ([self.delegate respondsToSelector:@selector(QRCode:) ])
    //         {
    //             [self.delegate QRCode:QRCode];
    //         }
    //
    NSLog(@"barCode:%@",QRCode);
    
    [self.navigationController pushViewController:merchant animated:YES];
    
    
    
}


-(void)onPayResult:(PayStatus)payStatus withInfo:(NSDictionary *)dict{
    NSLog(@"%u.......%@",payStatus,dict);
    NSString *title = @"";
    NSString *content = [self combieTitle:dict];
    NSLog(@"content%@",content);
    switch (payStatus) {
        case PayStatus_PAYSUCCESS:
        {
            title = @"支付成功";
            
        }
            break;
        case PayStatus_PAYFAIL:
        {
            title = @"交易失败";
            
        }
            break;
        case PayStatus_PAYTIMEOUT:
        {
            title = @"交易超时";
            
        }
            break;
        case PayStatus_PAYCANCEL:
        {
            title = @"交易取消";
            
        }
            break;
            
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}


-(NSString *)combieTitle:(NSDictionary *)dict{
    NSArray *keys = [dict allKeys];
    NSString *key;
    NSString *retString;
    for (key in keys)
    {
        if (retString == nil) {
            
            retString = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,[dict valueForKey:key]];
            [retString cStringUsingEncoding:NSUnicodeStringEncoding];
        }else{
            NSString *val = [NSString stringWithFormat:@",\n\"%@\":\"%@\"",key,[dict valueForKey:key]];
            
            retString = [retString stringByAppendingString:val];
        }
    }
    
    if (!retString) {
        retString = @"";
    }
    retString = [self replaceUnicode:retString];
    
    
    return retString;
    
}
- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
