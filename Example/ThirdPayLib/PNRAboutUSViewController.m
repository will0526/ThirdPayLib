//
//  PNRAboutUSViewController.m
//  ThirdPayLib
//
//  Created by will on 16/9/8.
//  Copyright © 2016年 王英永. All rights reserved.
//

#import "PNRAboutUSViewController.h"

@interface PNRAboutUSViewController ()

@end

@implementation PNRAboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30, 80, self.view.frame.size.width-60, 40)];
    title.text= @"汇付科技";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:title];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(15, 130, self.view.frame.size.width-30, 250)];
    content.text= @"上海汇付科技有限公司 由国内领先的综合金融服务机构 汇付天下 投资，为汇付集团核心成员企业，专注于为传统行业、金融机构、小微企业及个人投资者提供金融账户、支付结算、数据管理等综合金融服务，是汇付天下打造新金融产业链的一个重要平台。\n\n汇付科技的核心团队均拥有长期的金融行业经验，具有很强的市场洞察力和行业资源整合能力；作为国内领先的综合金融技术及运营服务机构，汇付科技一直秉承不断创新的经营理念，致力于为客户提供资产交易平台、基金业务外包、财富管理平台等新金融行业的水电煤基础产品及服务，服务于资产交易所、基金管理人、财富管理平台等新金融机构，与合作伙伴共同打造新金融生态。 \n                                                        ";
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 0;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:content];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(30, content.frame.origin.y+content.frame.size.height+10, self.view.frame.size.width-60, 20)];
    title1.text= @"上海汇付科技有限公司";
    title1.textAlignment = NSTextAlignmentRight;
    title1.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:title1];
    
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(30, title1.frame.origin.y+title1.frame.size.height+10, self.view.frame.size.width-60, 20)];
    title2.text= @"©2015 PnR Technologies Co., Ltd.";
    title2.textAlignment = NSTextAlignmentRight;
    title2.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:title2];
    
    // Do any additional setup after loading the view.
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
