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


@interface PNRMainViewController ()

@property (nonatomic,strong)UIButton *queryButton;
@property (nonatomic,strong)UIButton *orderButton;
@property (nonatomic,strong)UIButton *orderButton2;
@property (nonatomic,strong)UIButton *aboutButton;
@property (nonatomic,strong)UIButton *scanButton;
@property (nonatomic,strong)UIButton *queryMemberButton;
@end

@implementation PNRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试demo";
    
    [self.view addSubview:self.queryButton];
    [self.view addSubview:self.queryMemberButton];
    [self.view addSubview:self.orderButton];
    [self.view addSubview:self.orderButton2];
//    [self.view addSubview:self.aboutButton];
    [self.view addSubview:self.scanButton];
    // Do any additional setup after loading the view.
}


-(UIButton *)queryButton{
    if (_queryButton == nil) {
        _queryButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 100, self.view.frame.size.width*2/3, 40)];
        [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
        [_queryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_queryButton setBackgroundColor:[UIColor orangeColor]];
        
        _queryButton.clipsToBounds = YES;
        _queryButton.layer.cornerRadius = 20;
        _queryButton.tag = 0;
        [_queryButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _queryButton;
    
}

-(UIButton *)orderButton{
    if (_orderButton == nil) {
        _orderButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 170, self.view.frame.size.width*2/3, 40)];
        [_orderButton setTitle:@"下单" forState:UIControlStateNormal];
        [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_orderButton setBackgroundColor:[UIColor orangeColor]];
        
        _orderButton.clipsToBounds = YES;
        _orderButton.layer.cornerRadius = 20;
        _orderButton.tag = 1;
        [_orderButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _orderButton;
}


-(UIButton *)orderButton2{
    if (_orderButton2 == nil) {
        _orderButton2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 240, self.view.frame.size.width*2/3, 40)];
        [_orderButton2 setTitle:@"下单（无页面）" forState:UIControlStateNormal];
        [_orderButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_orderButton2 setBackgroundColor:[UIColor orangeColor]];
        
        _orderButton2.clipsToBounds = YES;
        _orderButton2.layer.cornerRadius = 20;
        _orderButton2.tag = 2;
        [_orderButton2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _orderButton2;
    
    
}

-(UIButton *)aboutButton{
    if (_aboutButton == nil) {
        _aboutButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 380, self.view.frame.size.width*2/3, 40)];
        [_aboutButton setTitle:@"关于我们" forState:UIControlStateNormal];
        [_aboutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_aboutButton setBackgroundColor:[UIColor orangeColor]];
        
        _aboutButton.clipsToBounds = YES;
        _aboutButton.layer.cornerRadius = 20;
        _aboutButton.tag = 3;
        [_aboutButton addTarget:self action:@selector(aboutUS) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _aboutButton;
}

-(UIButton *)scanButton{
    if (_scanButton == nil) {
        _scanButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 310, self.view.frame.size.width*2/3, 40)];
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
        _queryMemberButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 380, self.view.frame.size.width*2/3, 40)];
        [_queryMemberButton setTitle:@"查询权益" forState:UIControlStateNormal];
        [_queryMemberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_queryMemberButton setBackgroundColor:[UIColor orangeColor]];
        
        _queryMemberButton.clipsToBounds = YES;
        _queryMemberButton.layer.cornerRadius = 20;
        _queryMemberButton.tag = 5;
        [_queryMemberButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _queryMemberButton;
    
}

-(void)scanQRCode{
    
    PNRViewController *pnr = [[PNRViewController alloc]init];
    [pnr scanQRCode:self];

}

-(void)aboutUS{
    
    
    //PNRAboutUSViewController *about = [[PNRAboutUSViewController alloc]init];
    PNRMerchantViewController *merchant = [[PNRMerchantViewController alloc]init];
    
    [self.navigationController pushViewController:merchant animated:YES];
    
    
}


-(void)buttonPressed:(UIButton *)button{
    
    
    
    
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
