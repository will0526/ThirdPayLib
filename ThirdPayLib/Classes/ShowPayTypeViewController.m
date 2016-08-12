//
//  ShowPayTypeViewController.m
//  Pods
//
//  Created by will on 16/8/10.
//
//

#import "ShowPayTypeViewController.h"
#import "UIImage+SNAdditions.h"
#import "UIView+Category.h"
@interface ShowPayTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;


@end

@implementation ShowPayTypeViewController
{
    NSString *service;
    NSString *it_b_pay;
    NSString *_input_charset;
    
    //    sign_type
    //    sign
    //
    NSString * partner;// =  "2088101568358171";
    NSString * seller_id;
    NSString * out_trade_no;
    NSString * subject;
    NSString * body;
    NSString * total_fee;
    NSString * notify_url;
    
    NSString * payment_type;
    NSString * sign;
    NSString * sign_type;
    
    NSArray * dataSource;
    NSArray * payTypeIcon;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    partner="2088101568358171"&seller_id="xxx@alipay.com"&out_trade_no="0819145412-6177"&subject="测试"&body="测试测试"&total_fee="0.01"&notify_url="http://notify.msp.hk/notify.htm"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&sign="lBBK%2F0w5LOajrMrji7DUgEqNjIhQbidR13GovA5r3TgIbNqv231yC1NksLdw%2Ba3JnfHXoXuet6XNNHtn7VE%2BeCoRO1O%2BR1KugLrQEZMtG5jmJIe2pbjm%2F3kb%2FuGkpG%2BwYQYI51%2BhA3YBbvZHVQBYveBqK%2Bh8mUyb7GM1HxWs9k4%3D"&sign_type="RSA"
    
    dataSource = @[@"微信",@"支付宝",@"Apple Pay",@"百度钱包"];
    payTypeIcon = @[@"weixinIcon",@"alipayIcon",@"AppleIcon",@"baiIcon"];
    //    self.view.frame.top;
    UIImage *image = [UIImage imageNamed:@"alipayIcon"];
    
    
    [self.view addSubview:self.tableView];
    
    
}


#pragma mark tableView start

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50*dataSource.count) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString static *identify = @"payType";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
//    iconView.image = [UIImage getImageFromBundle:[NSString stringWithFormat:@"%@",payTypeIcon[indexPath.row]]];
    UIImage *image = [UIImage getImageFromBundle:@"alipayIcon"];
    image = [UIImage imageNamed:@"test.png"];
        iconView.image = image;
    iconView.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:iconView];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 100, 40)];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.text = dataSource[indexPath.row];
    [cell addSubview:textLabel];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:line];
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    @[@"微信",@"支付宝",@"Apple Pay",@"百度钱包"];
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"微信");
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}


#pragma mark tableView end
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
