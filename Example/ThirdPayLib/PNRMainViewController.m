//
//  PNRMainViewController.m
//  ThirdPayLib
//
//  Created by will on 16/8/26.
//  Copyright © 2016年 王英永. All rights reserved.
//

#import "PNRMainViewController.h"
#import "PNRViewController.h"
#import "PNRAboutUSViewController.h"
#import <ThirdPayLib/ThirdPay.h>
#import "PNRMerchantViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PNRPayBillViewController.h"

@interface PNRMainViewController ()

@property (nonatomic,strong)UIButton *queryButton;
@property (nonatomic,strong)UIButton *orderButton;
@property (nonatomic,strong)UIButton *orderButton2;
@property (nonatomic,strong)UIButton *aboutButton;
@property (nonatomic,strong)UIButton *scanButton;
@property (nonatomic,strong)UIButton *queryMemberButton;
@property (nonatomic,strong)UIButton *queryAllMemberButton;
@property (nonatomic, strong)UIButton *transButton;
@property (nonatomic, strong)UIButton *queryCampain;
@property (nonatomic, strong)UIButton *payBillBtn;
@end

@implementation PNRMainViewController
{
    int height;
    int width;
    UIImageView *icon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"慧客支付";
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:@"测试" forKey:@"environment"];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:self.transButton];
    self.navigationItem.rightBarButtonItem = menuButton;
    icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 308*self.view.frame.size.width/540)];
    
    [icon setImage:[UIImage imageNamed:@"icon@2x"]];
    [self.view addSubview:icon];
    width = (self.view.frame.size.width-30)/2;
    height = (self.view.frame.size.height - 64 - icon.frame.size.height-30)/3;
    
    
    
    [self.view addSubview:self.orderButton];
    [self.view addSubview:self.orderButton2];
    //    [self.view addSubview:self.queryButton];
    [self.view addSubview:self.queryMemberButton];
    [self.view addSubview:self.queryAllMemberButton];
    
    [self.view addSubview:self.queryCampain];
    
    [self.view addSubview:self.aboutButton];
    [self.view addSubview:self.payBillBtn];
    
    
//    [self.view addSubview:self.scanButton];
    // Do any additional setup after loading the view.
}


-(UIButton *)payBillBtn{
    if (_payBillBtn == nil) {
        _payBillBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 100, self.view.frame.size.width*2/3, 40)];
        [_payBillBtn setTitle:@"买单" forState:UIControlStateNormal];
        [_payBillBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_payBillBtn setBackgroundColor:[UIColor orangeColor]];
        
        _payBillBtn.tag = 10;
        [_payBillBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _payBillBtn;
    
}


-(UIButton *)queryButton{
    if (_queryButton == nil) {
        _queryButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 100, self.view.frame.size.width*2/3, 40)];
        [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
        [_queryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_queryButton setBackgroundColor:[UIColor orangeColor]];
        
//        _queryButton.tag = 0;
        [_queryButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _queryButton;
    
}

-(UIButton *)orderButton{
    if (_orderButton == nil) {
        _orderButton = [[UIButton alloc]initWithFrame:CGRectMake(10, icon.frame.origin.y+icon.frame.size.height+10, width, height)];
        [_orderButton setTitle:@"下单" forState:UIControlStateNormal];
        [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [_orderButton setBackgroundColor:[self colorWithRGBHex:(0x3d98ff)]];
        
        _orderButton.tag = 0;
        [_orderButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _orderButton;
}

- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

-(UIButton *)orderButton2{
    if (_orderButton2 == nil) {
        _orderButton2 = [[UIButton alloc]initWithFrame:CGRectMake(_orderButton.frame.size.width+20, _orderButton.frame.origin.y, width,height)];
        [_orderButton2 setTitle:@"下单（无页面）" forState:UIControlStateNormal];
        [_orderButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_orderButton2 setBackgroundColor:[self colorWithRGBHex:(0x3d98ff)]];
        
        _orderButton2.tag = 1;
        [_orderButton2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _orderButton2;
    
    
}

-(UIButton *)aboutButton{
    if (_aboutButton == nil) {
        _aboutButton = [[UIButton alloc]initWithFrame:CGRectMake(_queryAllMemberButton.frame.origin.x, _queryAllMemberButton.frame.origin.y + _queryAllMemberButton.frame.size.height + 10,  width,height)];
        [_aboutButton setTitle:@"关于我们" forState:UIControlStateNormal];
        [_aboutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_aboutButton setBackgroundColor:[self colorWithRGBHex:(0xffa21c)]];
        
        _aboutButton.tag = 15;
        [_aboutButton addTarget:self action:@selector(aboutUS) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _aboutButton;
}

-(UIButton *)scanButton{
    if (_scanButton == nil) {
        _scanButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 240, self.view.frame.size.width*2/3, 40)];
        [_scanButton setTitle:@"二维码扫描" forState:UIControlStateNormal];
        [_scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_scanButton setBackgroundColor:[UIColor orangeColor]];
        
        _scanButton.clipsToBounds = YES;
        _scanButton.layer.cornerRadius = 20;
        _scanButton.tag = 4;
        [_scanButton addTarget:self action:@selector(scanQRCode) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _scanButton;
}

-(UIButton *)queryMemberButton{
    if (_queryMemberButton == nil) {
        _queryMemberButton = [[UIButton alloc]initWithFrame:CGRectMake(10,  _orderButton.frame.origin.y+ _orderButton.frame.size.height+10,  width,height)];
        [_queryMemberButton setTitle:@"订单权益查询" forState:UIControlStateNormal];
        [_queryMemberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_queryMemberButton setBackgroundColor:[self colorWithRGBHex:(0x4fc72f)]];
        
        _queryMemberButton.tag = 2;
        [_queryMemberButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _queryMemberButton;
    
}

-(UIButton *)queryAllMemberButton{
    if (_queryAllMemberButton == nil) {
        _queryAllMemberButton = [[UIButton alloc]initWithFrame:CGRectMake(_orderButton2.frame.origin.x, _orderButton2.frame.origin.y+_orderButton2.frame.size.height+10,  width,height)];
        [_queryAllMemberButton setTitle:@"所有权益查询" forState:UIControlStateNormal];
        [_queryAllMemberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_queryAllMemberButton setBackgroundColor:[self colorWithRGBHex:(0x4fc72f)]];
        
        _queryAllMemberButton.tag = 3;
        [_queryAllMemberButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _queryAllMemberButton;
    
}
-(UIButton *)transButton{
    if (_transButton == nil) {
        _transButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_transButton setTitle:@"测试" forState:UIControlStateNormal];
        [_transButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
//        [_transButton setBackgroundColor:[UIColor orangeColor]];
        
        _transButton.clipsToBounds = YES;
        _transButton.tag = 7;
        [_transButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _transButton;
    
}
-(UIButton *)queryCampain{
    if (_queryCampain == nil) {
        _queryCampain = [[UIButton alloc]initWithFrame:CGRectMake(10, _queryAllMemberButton.frame.origin.y+_queryAllMemberButton.frame.size.height+10,  width,height)];
        [_queryCampain setTitle:@"营销活动查询" forState:UIControlStateNormal];
        [_queryCampain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_queryCampain setBackgroundColor:[self colorWithRGBHex:(0xffa21c)]];
        
        
        _queryCampain.tag = 4;
        [_queryCampain addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _queryCampain;
    
    
}

-(void)scanQRCode{
    
    PNRViewController *pnr = [[PNRViewController alloc]init];
    [pnr scanQRCode:self];

}

-(void)aboutUS{
    
    
    
    
    
    
    PNRAboutUSViewController *about = [[PNRAboutUSViewController alloc]init];
//    PNRMerchantViewController *merchant = [[PNRMerchantViewController alloc]init];
    
    [self.navigationController pushViewController:about animated:YES];
    
    
}

-(void)alipay{
    
    NSString * OrderString = @"app_id=2016072801677304&format=JSON&method=alipay.trade.app.pay&charset=utf-8&version=1.0&sign_type=RSA&timestamp=2017-05-24+10%3A15%3A18&notify_url=http%3A%2F%2Fipp.pnrtec.com%2Freceiver%2F0003%2F0005%2F01.html&sign=V3xokJ%2Fn5nyAsTRHxtuYpQr3diDfJHfNUJBrtkTS1nDyD95%2FO5U2otkW6uCiH5jRW%2BRb1YmwqoSuhfrOr5WGaUUGeNIaTfKZs16babKIzTV1BABNjHrpnBSh1XUSjQRRpI0RePtWIYuYIT6LtinmhaKjlZMS1IVDbGp5vwYjG4c%3D&biz_content={\"total_amount\":\"1.00\",\"body\":\"%E8%8B%B9%E6%9E%9C%E6%89%8B%E6%9C%BA6s%E5%92%8CiPhone7+%E6%AD%A3%E5%93%81%E8%A1%8C%E8%B4%A7\",\"product_code\":\"QUICK_MSECURITY_PAY\",\"subject\":\"%E8%8B%B9%E6%9E%9C%E6%89%8B%E6%9C%BA6s%E5%92%8CiPhone7+%E6%AD%A3%E5%93%81%E8%A1%8C%E8%B4%A7\",\"seller_id\":\"2088611361074461\",\"out_trade_no\":\"000000000010\"}";
    
    @try{
        [[[UIApplication sharedApplication] windows] objectAtIndex:0].hidden = NO;
        
        [[AlipaySDK defaultService] payOrder:OrderString fromScheme:@"ThirdPay" callback:^(NSDictionary *result) {
            
            NSLog(@"reslut = %@",result);
            
        }];
    }
    @catch(NSException *exception) {
        NSLog(@"exception%@",exception);
    }
    @finally {
        
    }

}


-(void)buttonPressed:(UIButton *)button{
    
    if (button.tag == 7) {
        
        
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *environment = (NSString *)[userDef objectForKey:@"environment"];
        
        if (environment) {
            if ([environment isEqualToString:@"测试"]) {
                [self.transButton setTitle:@"准生产" forState:UIControlStateNormal];
                [userDef setObject:@"准生产" forKey:@"environment"];
            }else{
                [userDef setObject:@"测试" forKey:@"environment"];
                [self.transButton setTitle:@"测试" forState:UIControlStateNormal];
            }
            
        }else{
            
        }
        return;
    }
    
    if (button.tag == 10) {
        PNRPayBillViewController *payBill = [[PNRPayBillViewController alloc]init];
        [self.navigationController pushViewController:payBill animated:YES];
        return;
    }
    
    //0下单1下单（无页面）2订单权益查询3所有权益查询4营销活动查询
    
    PNRViewController *pnr = [[PNRViewController alloc]init];
    
    pnr.viewType = button.tag;
    [self.navigationController pushViewController:pnr animated:YES];
    
    
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
