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
#import "BestpaySDK.h"
#import "BestpayNativeModel.h"
#import "WXApi.h"

@interface ShowPayTypeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *headView;
@property(nonatomic, strong)UIButton *payButton;
@property(nonatomic, strong)NSString *orderNO;
@end

@implementation ShowPayTypeViewController
{
    
    NSArray * dataSource;
    NSArray * payTypeIcon;
    int selectedIndex;
    
    UILabel *goodsNameLabel;
    UILabel *payAmountLabel;
    UILabel *orderNOLabel;
    UILabel *memoLabel;
    UILabel *redPocketLabel;
    UILabel *pointLabel;
    PayStatus payStatus;
    NSString *OrderString;
    NSMutableDictionary *_resultDict;
    BOOL isCancel;
    
    UIAlertView *cancelAlert;
    UIAlertView *payingAlert;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付订单";
    
    self.view.backgroundColor =HEX_RGB(0xeeeeee);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    
    dataSource = @[@"翼支付",@"微信支付",@"支付宝支付",@"百度钱包支付",@"Apple Pay"];
    payTypeIcon = @[@"YipayIcon",@"weixinIcon",@"alipayIcon",@"baiIcon",@"applepayIcon"];
    selectedIndex = 0;
//    self.payType = PayType_Alipay;
    _resultDict = [[NSMutableDictionary alloc]init];
    
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.payButton];
    
}

-(void)bookOrder{
//        OrderString = @"MERCHANTID=02440201030132107&SUBMERCHANTID=000000000000001&MERCHANTPWD=975388&ORDERSEQ=0000000000000511&ORDERAMOUNT=0.01&ORDERTIME=20160914162734&ORDERVALIDITYTIME=&PRODUCTDESC=pay&CUSTOMERID=&PRODUCTAMOUNT=0.01&ATTACHAMOUNT=0&CURTYPE=RMB&BACKMERCHANTURL=http://pay.pnrtec.com/receiver/0004/0005/01.html&ATTACH=&PRODUCTID=04&USERIP=192.168.11.130&DIVDETAILS=&ACCOUNTID=&BUSITYPE=04&ORDERREQTRANSEQ=0000000000000511&SERVICE=mobile.security.pay&SIGNTYPE=MD5&SIGN=68AB7FB3EDCA18380D17DF1C27598857&SUBJECT=6&SWTICHACC=true&SESSIONKEY=&OTHERFLOW=&ACCESSTOKEN=";
//    [self yipay];
//    return;
    
    BookOrderRequest *request = [[BookOrderRequest alloc]init];
    request.merchantNO = self.merchantNO;
    request.merchantOrderNO = self.merchantOrderNO;
    
    request.memberNO = self.memberNO;
    request.memo = self.memo;
    request.goodsName = self.goodsName;
    request.goodsDetail = self.goodsDetail;
    request.totalAmount = self.totalAmount;
    request.payAmount = self.payAmount;
    request.memberPoints = self.memberPoints;
    request.redPocket = self.redPocket;
    
    request.payType = self.payType;
    request.notifyURL = self.notifyURL;
    
    BaseResponse *response = [[BaseResponse alloc]init];
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@""
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:self
                                   showBackground:YES];
    [CommonService beginService:request response:response success:^(BaseResponse *response) {
        NSLog(@"response.json......%@",response.jsonDict);
        NSDictionary *data = EncodeDicFromDic(response.jsonDict, @"data");
        
        self.orderNO = EncodeStringFromDic(data, @"ippOrderNo");
        OrderString = EncodeStringFromDic(data, @"transMsg");
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
    
    if (IsStrEmpty(OrderString)) {
        [self tradeReturn];
        return;
    }
    
    payingAlert = [[UIAlertView alloc]initWithTitle:@"支付中。。。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [payingAlert show];
    
    switch (self.payType) {
        case PayType_Alipay:
        {
            [self alipay];
        }
            break;
        case PayType_YiPay:
        {
            [self yipay];
            
        }
            break;
        case PayType_WeichatPay:
        {
            
        }
            break;
        
        case PayType_BaiduPay:
        {
            
        }
            break;
        case PayType_ApplePay:
        {
            [self applePay];
        }
            break;
            
        default:
            break;
    }
    
    
    
}

-(void)Back{
    cancelAlert = [[UIAlertView alloc]initWithTitle:@"取消支付" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    isCancel = YES;
    [cancelAlert show];
    
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
        NSString *money = [self moneyTran:self.payAmount ownType:1];
        [_payButton setTitle:[NSString stringWithFormat:@"确认支付￥%@元",money] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xff9e05)] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xff9e05)] forState:UIControlStateHighlighted];
        _payButton.layer.cornerRadius = 3.5;
        _payButton.clipsToBounds = YES;
        [_payButton addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return _payButton;
}

-(void)payButtonPressed:(UIButton *)button{
    
    switch (selectedIndex) {
        case 0:
        {
            self.payType = PayType_YiPay;
            
        }
            break;
        case 1:
        {
            self.payType = PayType_WeichatPay;
        }
            break;
        case 2:
        {
            self.payType = PayType_Alipay;
        }
            break;
        case 3:
        {
            self.payType = PayType_BaiduPay;
        }
            break;
        case 4:
        {
            self.payType = PayType_ApplePay;
        }
            break;
            
        default:
            break;
    }
    
    [self bookOrder];
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
        NSString *money = [self moneyTran:self.payAmount ownType:1];
        payAmountLabel.text = [NSString stringWithFormat:@"订单金额：￥%@元",money];
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
            
        }else{
            memoLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, orderNOLabel.bottom, payAmountLabel.width, 0)];
        }
        if (!IsStrEmpty(self.redPocket)&&[self.redPocket intValue]>0) {
            redPocketLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, memoLabel.bottom, payAmountLabel.width, goodsNameLabel.height)];
            redPocketLabel.textAlignment = NSTextAlignmentLeft;
            redPocketLabel.font = [UIFont systemFontOfSize:16];
            redPocketLabel.text = [NSString stringWithFormat:@"红包抵扣：%f",[self.redPocket intValue]];
            [_headView addSubview:redPocketLabel];
            
            _headView.frame = CGRectMake(0, 0, self.view.width, redPocketLabel.bottom+10);
        }else{
            redPocketLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, memoLabel.bottom, payAmountLabel.width, 0)];
        }
        if (!IsStrEmpty(self.memberPoints)&&[self.memberPoints intValue]>0) {
            pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, redPocketLabel.bottom, payAmountLabel.width, goodsNameLabel.height)];
            pointLabel.textAlignment = NSTextAlignmentLeft;
            pointLabel.font = [UIFont systemFontOfSize:16];
            pointLabel.text = [NSString stringWithFormat:@"积分抵扣：%f",[self.memberPoints intValue]];
            [_headView addSubview:pointLabel];
            
            _headView.frame = CGRectMake(0, 0, self.view.width, redPocketLabel.bottom+10);
        }else{
            pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, redPocketLabel.bottom, payAmountLabel.width, 0)];
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
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 16, 28, 28)];
    iconView.image = [UIImage getImageFromBundle:[NSString stringWithFormat:@"%@",payTypeIcon[indexPath.row]]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.right + 20, 15, self.view.width -120, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = dataSource[indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [cell addSubview:titleLabel];
    
    if (indexPath.row == selectedIndex ) {
        UIImageView *selectView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
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
    
    if (IsStrEmpty(OrderString)) {
        [self tradeReturn];
        return;
    }

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
        DDLog(@"exception",exception);
    }
    @finally {
        
    }
    
//    [self tradeReturn];
}


//微信
-(void)weixinpay{
    [WXApi registerApp:weixinAppID withDescription:@"demo 2.0"];
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"10000100";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    request.timeStamp= @"1397527777";
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request];
    
    
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp * response=(PayResp*)resp;
        switch(response.errCode){
            caseWXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                DDLog(@"", @"");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

//百度钱包
-(void)baidupay{
    
    
//    [self tradeReturn];
}

//翼支付
-(void)yipay{


// @"MERCHANTID=02440201030132107&SUBMERCHANTID=000000000000001&MERCHANTPWD=975388&ORDERSEQ=0000000000000494&ORDERAMOUNT=0.01&PRODUCTDESC=pay&PRODUCTAMOUNT=0.01&ATTACHAMOUNT=0&CURTYPE=RMB&BACKMERCHANTURL=http://pay.pnrtec.com/receiver/0004/0005/01.html&PRODUCTID=04&USERIP=192.168.11.130&BUSITYPE=04&ORDERREQTRANSEQ=0000000000000494&SERVICE=mobile.security.pay&SIGNTYPE=MD5&SUBJECT=苹果手机6s 正品行货 64G 假一赔十&SWTICHACC=true&ORDERTIME=20160914160316&SIGN=01450EAA04B8648906C7B5872346AF6A
    NSString *orderStr = OrderString;//[self orderInfos];
    DDLog(@"跳转支付页面带入信息:", orderStr);
    
    BestpayNativeModel *order =[[BestpayNativeModel alloc]init];
    order.orderInfo = orderStr;
    order.launchType = launchTypePay1;
    order.scheme = self.appScheme;
    
    //调用sdk的方法
    [BestpaySDK payWithOrder:order fromViewController:self callback:^(NSDictionary *resultDic) {
        //支付成功后回调结果
        NSLog(@"result == %@", resultDic);
        
    }];
    
}


-(void)applePay{

    
    
}



-(Boolean)handleOpenURL:(NSURL *)url withCompletion:(ThirdPayCompletion )complete{
    [payingAlert setHidden:YES];
    switch (self.payType) {
        case PayType_YiPay:{
            [BestpaySDK processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                DDLog(@"bestpay result", resultDic);
                
                NSString *resultCode = EncodeStringFromDic(resultDic, @"resultCode");
                if ([resultCode isEqualToString:@"00"]) {
                    payStatus = PayStatus_PAYSUCCESS;
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"支付成功", @"message");
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
                    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                }else if([resultCode isEqualToString:@"01"]){
                    payStatus = PayStatus_PAYFAIL;
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"支付失败", @"message");
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"0010", @"code");
                    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                    
                }else if([resultCode isEqualToString:@"02"]){
                    
                    payStatus = PayStatus_PAYCANCEL;
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"用户取消", @"message");
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"6001", @"code");
                    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                }
                
            }];
        }
            break;
        case PayType_Alipay:{
            
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
                        EncodeUnEmptyStrObjctToDic(_resultDict, @"0010", @"code");
                        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                    }
                    
                    NSLog(@"reslut = %@",_resultDict);
                    
                    
                }];
                    
            }
        }
            
        default:
            break;
    }
    [self tradeReturn];
    
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
    EncodeUnEmptyStrObjctToDic(dict, self.orderNO, @"ippOrderNO");
    
    return dict;
    
    
    
}

-(void)tradeReturn{
    
    
    if (self.thirdPayDelegate && [self.thirdPayDelegate respondsToSelector:@selector(onPayResult:withInfo:)]) {
        [self.thirdPayDelegate onPayResult:payStatus withInfo:_resultDict];
    }
    if (![_viewType isEqualToString:@"NOVIEW"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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

-(NSString *)moneyTran:(NSString *)yM ownType:(int)type{
    if (!yM) return @"0";
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    
    if(type==0){
        
        if ([yM doubleValue]>DBL_MAX) {
            return @"";
        }
        
        nf.positiveFormat = @"0";
        double h=(double) ([yM doubleValue])*100;
        return  [nf stringFromNumber: [NSNumber numberWithDouble:h]];
    }
    else if(type==1){
        double h=(double) ([yM doubleValue])/100;
        nf.positiveFormat = @"0.00";
        return [nf stringFromNumber: [NSNumber numberWithDouble:h]];
    }else if (type == 2){
        double h=(double) ([yM doubleValue])/100;
        nf.positiveFormat = @"0";
        return [nf stringFromNumber: [NSNumber numberWithDouble:h]];
    }
    else return @"";
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
