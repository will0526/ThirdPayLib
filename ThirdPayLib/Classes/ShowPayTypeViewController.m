//
//  ShowPayTypeViewController.m
//  Pods
//
//  Created by will on 16/8/10.
//
//

#import "ShowPayTypeViewController.h"
#import "BookOrderRequest.h"
#import "CommonService.h"

@interface ShowPayTypeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *headView;
@property(nonatomic, strong)UIButton *payButton;

@end

@implementation ShowPayTypeViewController
{
    NSString *service;
    NSString *it_b_pay;
    NSString *_input_charset;
    
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
    int selectedIndex;
    
    
    UILabel *goodsNameLabel;
    UILabel *payAmountLabel;
    UILabel *orderNOLabel;
    UILabel *memoLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付订单";
    
    self.view.backgroundColor =HEX_RGB(0xeeeeee);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    
    dataSource = @[@"翼支付",@"微信支付",@"支付宝支付",@"百度钱包支付"];
    payTypeIcon = @[@"YipayIcon",@"weixinIcon",@"alipayIcon",@"baiIcon"];

    
    [self bookOrder];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.payButton];
    
}

-(void)bookOrder{
    
    BookOrderRequest *request = [[BookOrderRequest alloc]init];
    BaseResponse *response = [[BaseResponse alloc]init];
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@""
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:self
                                   showBackground:NO];
    [CommonService beginService:request response:response success:^(BaseResponse *response) {
        [[MOPHUDCenter shareInstance]removeHUD];
    } failed:^(NSString *errorCode, NSString *errorMsg) {
        [[MOPHUDCenter shareInstance]removeHUD];
    } controller:self];
    
    
    
    
}

-(void)Back{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"取消支付" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            [alertView setHidden:YES];
        }
            break;
        case 1:
        {
            
            [alertView setHidden:YES];
            [self tradeReturn];
        }
            break;
            
        default:
            break;
    }
}

-(UIButton *)payButton{
    if (_payButton == nil) {
        _payButton = [[UIButton alloc]initWithFrame:CGRectMake(30, self.view.height - 70, self.view.width - 60, 50)];
        [_payButton setTitle:[NSString stringWithFormat:@"确认支付￥%@",self.payAmount] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xff9e05)] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xff9e05)] forState:UIControlStateHighlighted];
        _payButton.layer.cornerRadius = 3.5;
        _payButton.clipsToBounds = YES;
        [_payButton addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return _payButton;
}

-(void)payButtonPressed:(UIButton *)button{
    
    
    //    @[@"翼支付",@"微信",@"支付宝",@"百度钱包"];
    switch (selectedIndex) {
        case 0:
        {
            
            
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


-(UIView *)headView{
    
    if (_headView == nil) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
        _headView.backgroundColor = HEX_RGB(0xf9f9fc);
        
        goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, self.view.width - 60, 40)];
        goodsNameLabel.textAlignment = NSTextAlignmentLeft;
        goodsNameLabel.font = [UIFont systemFontOfSize:16];
        goodsNameLabel.text = [NSString stringWithFormat:@"订单详情：%@",self.goodsName];
        [_headView addSubview:goodsNameLabel];
        
        payAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsNameLabel.left, goodsNameLabel.bottom, goodsNameLabel.width, goodsNameLabel.height)];
        payAmountLabel.textAlignment = NSTextAlignmentLeft;
        payAmountLabel.font = [UIFont systemFontOfSize:16];
        payAmountLabel.text = [NSString stringWithFormat:@"订单金额：￥%@",self.payAmount];
        [_headView addSubview:payAmountLabel];
        
        
        orderNOLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, payAmountLabel.bottom, payAmountLabel.width, goodsNameLabel.height)];
        orderNOLabel.textAlignment = NSTextAlignmentLeft;
        orderNOLabel.font = [UIFont systemFontOfSize:16];
        orderNOLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.merchantOrderNO];
        [_headView addSubview:orderNOLabel];
        
        if (!IsStrEmpty(self.memo)) {
            memoLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, orderNOLabel.bottom, payAmountLabel.width, goodsNameLabel.height)];
            memoLabel.textAlignment = NSTextAlignmentLeft;
            memoLabel.font = [UIFont systemFontOfSize:16];
            memoLabel.text = [NSString stringWithFormat:@"备        注：%@",self.memo];
            [_headView addSubview:memoLabel];
            
            _headView.frame = CGRectMake(0, 0, self.view.width, memoLabel.bottom+10);
        }
    }
    
    
    return _headView;
    
}

#pragma mark tableView start

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.height) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
//        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString  *identify = @"payTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 17.5, 25, 25)];
    iconView.image = [UIImage getImageFromBundle:[NSString stringWithFormat:@"%@",payTypeIcon[indexPath.row]]];
    iconView.contentMode = UIViewContentModeRedraw;
    [cell addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.right + 20, 15, self.view.width -120, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = dataSource[indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [cell addSubview:titleLabel];
    
    if (indexPath.row == selectedIndex ) {
        UIImageView *selectView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        selectView.image = [UIImage getImageFromBundle:@"checked"];
        cell.accessoryView = selectView;
    }else{
        cell.accessoryView = nil;
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 1)];
    line.backgroundColor = HEX_RGB(0xe4e4e4);
    [cell addSubview:line];
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    [tableView reloadData];
   
}

#pragma mark tableView end

#pragma mark pay method

//支付宝
-(void)alipay{
    
    [self tradeReturn];
}

//微信
-(void)weixinpay{
    [self tradeReturn];
    
}

//百度钱包
-(void)baidupay{
    
    
    [self tradeReturn];
}

//翼支付
-(void)yipay{

    
    [self tradeReturn];
}


-(void)tradeReturn{
    
    NSDictionary *dict = [[NSDictionary alloc]init];
    if (self.thirdPayDelegate && [self.thirdPayDelegate respondsToSelector:@selector(onPayResult:withInfo:)]) {
        [self.thirdPayDelegate onPayResult:PayStatus_PAYCANCEL withInfo:dict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark pay method



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
