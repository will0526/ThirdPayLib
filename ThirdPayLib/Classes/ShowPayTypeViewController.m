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
#import "LJSecurityUtils.h"
#import "QueryOrderRequest.h"
#import <AlipaySDK/AlipaySDK.h>


@interface ShowPayTypeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *headView;
@property(nonatomic, strong)UIButton *payButton;
@property(nonatomic, strong)NSString *orderNO;
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
    
    PayStatus payStatus;
    NSString *OrderString;
    NSMutableDictionary *_resultDict;
    BOOL isCancel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付订单";
    
    self.view.backgroundColor =HEX_RGB(0xeeeeee);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    
    dataSource = @[@"翼支付",@"微信支付",@"支付宝支付",@"百度钱包支付"];
    payTypeIcon = @[@"YipayIcon",@"weixinIcon",@"alipayIcon",@"baiIcon"];
    selectedIndex = 2;
    _resultDict = [[NSMutableDictionary alloc]init];
//    [self bookOrder];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.payButton];
    
}
- (NSString *)formatPrivateKey:(NSString *)privateKey {
    const char *pstr = [privateKey UTF8String];
    int len = (int)[privateKey length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
    int index = 0;
    int count = 0;
    while (index < len) {
        char ch = pstr[index];
        if (ch == '\r' || ch == '\n') {
            ++index;
            continue;
        }
        [result appendFormat:@"%c", ch];
        if (++count == 79)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END PRIVATE KEY-----"];
    return result;
}

-(void)bookOrder{
    
    BookOrderRequest *request = [[BookOrderRequest alloc]init];
    request.merchantNO = self.merchantNO;
    request.merchantOrderNO = self.merchantOrderNO;
//    request.payType = sel
    request.memberNO = self.memberNO;
    request.memo = self.memo;
    request.goodsName = self.goodsName;
    request.goodsDetail = self.goodsDetail;
    request.totalAmount = self.totalAmount;
    request.payAmount = self.payAmount;
    request.memberPoints = self.memberPoints;
    request.transType = @"009";
    request.payType =@"003";
    
    
    BaseResponse *response = [[BaseResponse alloc]init];
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@""
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:self
                                   showBackground:YES];
    [CommonService beginService:request response:response success:^(BaseResponse *response) {
        NSLog(@"response.json......%@",response.jsonDict);
        NSString *orderStringbase64 = EncodeStringFromDic(response.jsonDict, @"data");
        
        NSData *base64Data = [NSData dataWithBase64EncodedString:orderStringbase64];
        
        NSLog(@"base64Data%@",base64Data);
        
        NSString *orderStr = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
        
        NSString *jsonStr = [orderStr URLDecoding];
        
        NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//        解析json数据，使用系统方法 JSONObjectWithData:  options: error:
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic..........%@",dic);
        
        
        OrderString = EncodeStringFromDic(dic, @"transMsg");
        [self gotoPay];
        [[MOPHUDCenter shareInstance]removeHUD];
    } failed:^(NSString *errorCode, NSString *errorMsg) {
        if([errorCode isEqualToString:@"9001"]){
            payStatus = PayStatus_PAYTIMEOUT;
           
        }else{
            payStatus = PayStatus_PAYFAIL;
        }
        EncodeUnEmptyStrObjctToDic(_resultDict, errorMsg, @"message");
        EncodeUnEmptyStrObjctToDic(_resultDict, errorCode, @"code");
        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
        
        
        
        [self tradeReturn];
        [[MOPHUDCenter shareInstance]removeHUD];
    } controller:self];
    
    
    
    
}

-(void)gotoPay{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付中。。。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
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
            [self alipay];
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

-(void)Back{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"取消支付" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    isCancel = YES;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            if (!isCancel) {
                [self queryOrder];
            }
            
            [alertView setHidden:YES];
        }
            break;
        case 1:
        {
            
            [alertView setHidden:YES];
            payStatus = PayStatus_PAYCANCEL;
        
            EncodeUnEmptyStrObjctToDic(_resultDict, @"交易取消", @"message");
            EncodeUnEmptyStrObjctToDic(_resultDict, @"0001", @"code");
            EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
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
    
    [self bookOrder];
    
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
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.height) style:UITableViewStylePlain];
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
    
//    NSString *OrderString = @"biz_content={\"total_amount\":\"0.01\",\"body\":\"%E8%AE%A2%E5%8D%95%E6%8F%8F%E8%BF%B0\",\"product_code\":\"QUICK_MSECURITY_PAY\",\"subject\":\"%E8%AE%A2%E5%8D%95%E6%8F%8F%E8%BF%B0\",\"out_trade_no\":\"20160825173306000090\"}&sign=m2Boi0kVJokWRedHeTcKPqlAG6d7gBEh%2BG5gUc1fYoRWL5sIfdgHVCzOl1cU4x9Q1PDUU1ythBN6JbxNhYVnml1aWF%2BPlqdVJhgHbDKZQB%2FO190lXVO6me1%2FT6uOgYzgXYr5NeMls41iFufRBpJSSE7DDi86uveJxd39J6N4qc4%3D&timestamp=2016-08-25+17%3A32%3A01&sign_type=RSA&notify_url=http%3A%2F%2F114.55.173.244%3A8181%2Fipp.pay%2Freceiver%2F0003%2F0009%2F01.html&charset=utf-8&app_id=2016072801677304&method=alipay.trade.app.pay&version=1.0";
//    self.appScheme = @"ThirdPayDemo";
    
    if (IsStrEmpty(OrderString)) {
        [self tradeReturn];
        return;
    }
     NSLog(@"OrderString%@",self.appScheme);
    @try{
        [[[UIApplication sharedApplication] windows] objectAtIndex:0].hidden = NO;
        [[AlipaySDK defaultService] payOrder:OrderString fromScheme:self.appScheme callback:^(NSDictionary *result) {
            
            NSString *resultStatus = EncodeStringFromDic(result, @"resultStatus");
            if ([resultStatus isEqualToString:@"9000"]) {
                payStatus = PayStatus_PAYSUCCESS;
                EncodeUnEmptyStrObjctToDic(_resultDict, @"支付成功", @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
            }else if ([resultStatus isEqualToString:@"6001"]){
                payStatus = PayStatus_PAYCANCEL;
                EncodeUnEmptyStrObjctToDic(_resultDict, @"交易取消", @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, resultStatus, @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
                
            }else{
                payStatus = PayStatus_PAYFAIL;
                EncodeUnEmptyStrObjctToDic(_resultDict, @"支付失败", @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, resultStatus, @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
                
            }
            
            
            NSLog(@"reslut = %@",_resultDict);
            [self tradeReturn];
        }];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    
//    [self tradeReturn];
}


//微信
-(void)weixinpay{
//    [self tradeReturn];
    
}

//百度钱包
-(void)baidupay{
    
    
//    [self tradeReturn];
}

//翼支付
-(void)yipay{

    
//    [self tradeReturn:];
}

-(Boolean)handleOpenURL:(NSURL *)url withCompletion:(ThirdPayCompletion )complete{
    if ([url.host isEqualToString:@"safepay"]) {
        
        
                //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result = %@",resultDic);
            NSString *resultStatus = EncodeStringFromDic(resultDic, @"resultStatus");
            if ([resultStatus isEqualToString:@"9000"]) {
                payStatus = PayStatus_PAYSUCCESS;
                EncodeUnEmptyStrObjctToDic(_resultDict, @"支付成功", @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
            }else if ([resultStatus isEqualToString:@"6001"]){
                payStatus = PayStatus_PAYCANCEL;
                EncodeUnEmptyStrObjctToDic(_resultDict, @"用户取消", @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, resultStatus, @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
                
            }else{
                payStatus = PayStatus_PAYFAIL;
                EncodeUnEmptyStrObjctToDic(_resultDict, @"支付失败", @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, resultStatus, @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
                
            }
            
            NSLog(@"reslut = %@",_resultDict);
            [self tradeReturn];
            
        }];
            
    }
    return YES;
    
}

-(NSDictionary *)getParamsWrap{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    EncodeUnEmptyStrObjctToDic(dict, self.merchantNO, @"merchantNO");
    EncodeUnEmptyStrObjctToDic(dict, self.merchantOrderNO, @"merchantOrderNO");
    EncodeUnEmptyStrObjctToDic(dict, self.memberPoints, @"memberPoints");
    EncodeUnEmptyStrObjctToDic(dict, self.goodsName, @"goodsName");
    EncodeUnEmptyStrObjctToDic(dict, self.goodsDetail, @"goodsDetail");
    EncodeUnEmptyStrObjctToDic(dict, self.memo, @"memo");
    EncodeUnEmptyStrObjctToDic(dict, self.totalAmount, @"totalAmount");
    EncodeUnEmptyStrObjctToDic(dict, self.payAmount, @"payAmount");
    EncodeUnEmptyStrObjctToDic(dict, self.redPocket, @"redPocket");
    EncodeUnEmptyStrObjctToDic(dict, self.orderNO, @"orderNO");
    
    return dict;
    
    
    
}

-(void)tradeReturn{
    
    
    if (self.thirdPayDelegate && [self.thirdPayDelegate respondsToSelector:@selector(onPayResult:withInfo:)]) {
        [self.thirdPayDelegate onPayResult:payStatus withInfo:_resultDict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark pay method

-(void)queryOrder{
    
    
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@"交易查询中"
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:self
                                   showBackground:YES];
    QueryOrderRequest *request = [[QueryOrderRequest alloc]init];
    request.merchantNO = self.merchantNO;
    request.orderNO = self.orderNO;
    //    reque
    BaseResponse *response = [[BaseResponse alloc]init];
    [CommonService beginService:request response:response success:^(BaseResponse *response) {
        NSLog(@"response.json......%@",response.jsonDict);
        NSDictionary *dict = @{@"message":@"查询成功"};
        [[MOPHUDCenter shareInstance]removeHUD];
        
        
        
    } failed:^(NSString *errorCode, NSString *errorMsg) {
        [[MOPHUDCenter shareInstance]removeHUD];
        NSDictionary *dict = @{@"message":@"查询失败",@"code":@"0001"};
        
    } controller:self];
    
    
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
