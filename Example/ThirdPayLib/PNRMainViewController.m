//
//  PNRMainViewController.m
//  ThirdPayLib
//
//  Created by will on 16/8/26.
//  Copyright © 2016年 王英永. All rights reserved.
//

#import "PNRMainViewController.h"
#import "PNRViewController.h"
@interface PNRMainViewController ()

@property (nonatomic,strong)UIButton *queryButton;
@property (nonatomic,strong)UIButton *orderButton;
@property (nonatomic,strong)UIButton *orderButton2;
@end

@implementation PNRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试demo";
    
    [self.view addSubview:self.queryButton];
    [self.view addSubview:self.orderButton];
    [self.view addSubview:self.orderButton2];
    
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
