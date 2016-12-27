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
#import "UIColor+SNAdditions.h"
#import "UIImage+SNAdditions.h"
#import "QueryOrderRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import "BestpaySDK.h"
#import "BestpayNativeModel.h"
#import "WXApi.h"
#import "QRCodeViewController.h"
#import "MerchantViewController.h"

@interface ShowPayTypeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,WXApiDelegate,QRCodeDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UITableView *backtableView;
@property(nonatomic, strong)UIView *headView;
@property(nonatomic, strong)UIButton *payButton;
@property(nonatomic, strong)NSString *orderNO;
@end

@implementation ShowPayTypeViewController
{
    
    NSArray * dataSource;
    NSArray * payTypeIcon;
    int selectedIndex;
    
    UILabel *orderTitleLabel;
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
    self.title = @"订单确认";
    
    self.view.backgroundColor =HEX_RGB(0xeeeeee);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    
    dataSource = @[@"翼支付",@"微信支付",@"支付宝支付",@"百度钱包支付",@"Apple Pay"];
    payTypeIcon = @[@"YipayIcon",@"weixinIcon",@"alipayIcon",@"baiIcon",@"applepayIcon"];
    selectedIndex = 0;
//    self.payType = PayType_Alipay;
    _resultDict = [[NSMutableDictionary alloc]init];
    
    
    
    self.tableView.tableHeaderView = self.headView;
    self.backtableView.tableHeaderView = self.tableView;
    
    [self.view addSubview:self.backtableView];
    [self.view addSubview:self.payButton];
    
}

-(void)bookOrder{
//        OrderString = @"MERCHANTID=02440201030132107&SUBMERCHANTID=000000000000001&MERCHANTPWD=975388&ORDERSEQ=0000000000000511&ORDERAMOUNT=0.01&ORDERTIME=20160914162734&ORDERVALIDITYTIME=&PRODUCTDESC=pay&CUSTOMERID=&PRODUCTAMOUNT=0.01&ATTACHAMOUNT=0&CURTYPE=RMB&BACKMERCHANTURL=http://pay.pnrtec.com/receiver/0004/0005/01.html&ATTACH=&PRODUCTID=04&USERIP=192.168.11.130&DIVDETAILS=&ACCOUNTID=&BUSITYPE=04&ORDERREQTRANSEQ=0000000000000511&SERVICE=mobile.security.pay&SIGNTYPE=MD5&SIGN=68AB7FB3EDCA18380D17DF1C27598857&SUBJECT=6&SWTICHACC=true&SESSIONKEY=&OTHERFLOW=&ACCESSTOKEN=";
//    [self weixinpay];
//    return;
    BOOL background = YES;
    if ([_viewType isEqualToString:@"NOVIEW"]) {
        background = NO;
    }
    
    BookOrderRequest *request = [[BookOrderRequest alloc]init];
    
    request.merchantNo = self.orderInfo.merchantNo;
    request.merchantOrderNo = self.orderInfo.merchantOrderNo;
    
    request.accountNo = self.orderInfo.accountNo;
    request.memo = self.orderInfo.memo;
    request.orderTitle = self.orderInfo.orderSubject;
    request.orderDetail = self.orderInfo.orderDescription;
    request.totalAmount = self.orderInfo.totalAmount;
    request.payAmount = self.orderInfo.payAmount;
    request.otherPayInfo = self.orderInfo.otherPayInfo;
    request.goodsInfo   = self.orderInfo.goodsInfo;
    request.payType = self.payType;
    request.notifyURL = self.orderInfo.notifyURL;
    
    BaseResponse *response = [[BaseResponse alloc]init];
    
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@""
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:self
                                   showBackground:background];
    
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
    } controller:self showProgressBar:NO];
    
    
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
            [self weixinpay];
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
        
            EncodeUnEmptyStrObjctToDic(_resultDict, TRADECANCEL, @"message");
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
        _payButton = [[UIButton alloc]initWithFrame:CGRectMake(30, self.view.height - 60, self.view.width - 60, 50)];
        
        NSString *money = [self moneyTran:self.orderInfo.payAmount ownType:1];
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
        
        orderTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, self.view.width - 60, 40)];
        orderTitleLabel.textAlignment = NSTextAlignmentLeft;
        orderTitleLabel.font = [UIFont systemFontOfSize:16];
        orderTitleLabel.text = [NSString stringWithFormat:@"订单详情：%@",self.orderInfo.orderSubject];
        [_headView addSubview:orderTitleLabel];
        
        payAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderTitleLabel.left, orderTitleLabel.bottom, orderTitleLabel.width, orderTitleLabel.height)];
        payAmountLabel.textAlignment = NSTextAlignmentLeft;
        payAmountLabel.font = [UIFont systemFontOfSize:16];
        NSString *money = [self moneyTran:self.orderInfo.payAmount ownType:1];
        payAmountLabel.text = [NSString stringWithFormat:@"订单金额：￥%@元",money];
        [_headView addSubview:payAmountLabel];
        
        
        orderNOLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, payAmountLabel.bottom, payAmountLabel.width, orderTitleLabel.height)];
        orderNOLabel.textAlignment = NSTextAlignmentLeft;
        orderNOLabel.font = [UIFont systemFontOfSize:16];
        orderNOLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.orderInfo.merchantOrderNo];
        [_headView addSubview:orderNOLabel];
        
        if (!IsStrEmpty(self.orderInfo.memo)) {
            memoLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, orderNOLabel.bottom, payAmountLabel.width, orderTitleLabel.height)];
            memoLabel.textAlignment = NSTextAlignmentLeft;
            memoLabel.font = [UIFont systemFontOfSize:16];
            memoLabel.text = [NSString stringWithFormat:@"备        注：%@",self.orderInfo.memo];
            [_headView addSubview:memoLabel];
            
        }else{
            
            memoLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, orderNOLabel.bottom, payAmountLabel.width, 0)];
        }
        
        if (IsArrEmpty(self.orderInfo.goodsInfo)) {
            redPocketLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, memoLabel.bottom, payAmountLabel.width, orderTitleLabel.height)];
            redPocketLabel.textAlignment = NSTextAlignmentLeft;
            redPocketLabel.font = [UIFont systemFontOfSize:16];
           // redPocketLabel.text = [NSString stringWithFormat:@"红包抵扣：%d",[self.redPocket intValue]];
            [_headView addSubview:redPocketLabel];
            
            _headView.frame = CGRectMake(0, 0, self.view.width, redPocketLabel.bottom+10);
        }else{
            redPocketLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, memoLabel.bottom, payAmountLabel.width, 0)];
        }
        
        if (IsArrEmpty(self.orderInfo.otherPayInfo)) {
            pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, redPocketLabel.bottom, payAmountLabel.width, orderTitleLabel.height)];
            pointLabel.textAlignment = NSTextAlignmentLeft;
            pointLabel.font = [UIFont systemFontOfSize:16];
            //pointLabel.text = [NSString stringWithFormat:@"积分抵扣：%d",[self.memberPoints intValue]];
            [_headView addSubview:pointLabel];
            
            _headView.frame = CGRectMake(0, 0, self.view.width, redPocketLabel.bottom+10);
        }else{
            pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, redPocketLabel.bottom, payAmountLabel.width, 0)];
        }
        
    }
    return _headView;
    
}

-(UITableView *)backtableView{
    if (_backtableView == nil) {
        self.backtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.height) style:UITableViewStylePlain];
        
        self.backtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _backtableView;
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
        
        [[AlipaySDK defaultService] payOrder:OrderString fromScheme:self.orderInfo.appSchemeStr callback:^(NSDictionary *result) {
            
            NSString *resultStatus = EncodeStringFromDic(result, @"resultStatus");
            if ([resultStatus isEqualToString:@"9000"]) {
                payStatus = PayStatus_PAYSUCCESS;
                EncodeUnEmptyStrObjctToDic(_resultDict, TRADESUCCESS, @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
            }else if ([resultStatus isEqualToString:@"6001"]){
                payStatus = PayStatus_PAYCANCEL;
                EncodeUnEmptyStrObjctToDic(_resultDict, TRADECANCEL, @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, resultStatus, @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
                
            }else{
                payStatus = PayStatus_PAYFAIL;
                EncodeUnEmptyStrObjctToDic(_resultDict, TRADEFAILED, @"message");
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
    
//    OrderString = @"{\"appid\":\"wxd74f10be104372ab\",\"package\":\"Sign=WXPay\",\"partnerid\":\"1391276302\",\"noncestr\":\"201609211755412159251494\",\"timestamp\":\"1474451741\",\"prepayid\":\"wx201609211755403eafc71e6a0694025503\",\"sign\":\"B65F04F54911515697F88711CF3DB886\"}";
//    "{\"appid\":\"wxd74f10be104372ab\",\"package\":\"Sign=WXPay\",\"partnerid\":\"1391276302\",\"noncestr\":\"201609221322534043900560\",\"timestamp\":\"1474521773\",\"prepayid\":\"wx20160922132253e23d44d1e50249159091\",\"sign\":\"E5E7F53D2DFC4C90006F8F458038DCC2\"}"
    
    NSData *jsonData = [OrderString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    [WXApi registerApp:weixinAppID withDescription:@"demo 2.0"];
    
    NSString *partnerId = EncodeStringFromDic(dic, @"partnerid");
    
    NSString *prepayId = EncodeStringFromDic(dic, @"prepayid");
    NSString *package = EncodeStringFromDic(dic, @"package");
    NSString *nonceStr= EncodeStringFromDic(dic, @"noncestr");
    NSString *timeSp = EncodeStringFromDic(dic, @"timestamp");
    
    NSString *sign= EncodeStringFromDic(dic, @"sign");
    
    if (IsStrEmpty(partnerId) || IsStrEmpty(prepayId) || IsStrEmpty(package) || IsStrEmpty(nonceStr) || IsStrEmpty(timeSp) || IsStrEmpty(sign)) {
        payStatus = PayStatus_PAYFAIL;
        EncodeUnEmptyStrObjctToDic(_resultDict, BOOKORDERFAILED, @"message");
        EncodeUnEmptyStrObjctToDic(_resultDict, @"9000", @"code");
        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
        [self tradeReturn];
    }else{
        
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = partnerId;
        request.prepayId= prepayId;
        request.package = package;
        request.nonceStr= nonceStr;
        request.timeStamp= [timeSp intValue];
        request.sign= sign;
        [WXApi sendReq:request];
    }
    
    
    
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp * response=(PayResp*)resp;
        
        switch(response.errCode){
            case WXSuccess:
            {
                payStatus = PayStatus_PAYSUCCESS;
                EncodeUnEmptyStrObjctToDic(_resultDict, TRADESUCCESS, @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
            }
                break;
            case WXErrCodeUserCancel:
            {
                payStatus = PayStatus_PAYCANCEL;
                EncodeUnEmptyStrObjctToDic(_resultDict, TRADECANCEL, @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, [NSString stringWithFormat:@"%d",response.errCode], @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
                
            }
                break;
            default:
            {
                payStatus = PayStatus_PAYFAIL;
                EncodeUnEmptyStrObjctToDic(_resultDict, [NSString stringWithFormat:@"%@:%@",TRADEFAILED,response.errStr], @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, [NSString stringWithFormat:@"%d",response.errCode], @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                
                DDLog(@"支付失败", response.errStr);
            }
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

    DDLog(@"跳转支付页面带入信息:", OrderString);
    
    NSString *scheml = self.orderInfo.appSchemeStr;
//    NSString *orderStr = @"SERVICE=mobile.security.pay&MERCHANTID=01320103025740000&MERCHANTPWD=288330&SUBMERCHANTID=&BACKMERCHANTURL=http://127.0.0.1:8040/wapBgNotice.action=yzf&SIGNTYPE=MD5&MAC=A540F34032ECA7E9245DA0C5B7517F58&ORDERSEQ=2016110118425134&ORDERREQTRNSEQ=20161101184251340001&ORDERTIME=20161101184251&ORDERVALIDITYTIME=&ORDERAMOUNT=0.01&CURTYPE=RMB&PRODUCTID=04&PRODUCTDESC=联想手机&PRODUCTAMOUNT=0.01&ATTACHAMOUNT=0.00&ATTACH=88888&DIVDETAILS=&ACCOUNTID=&CUSTOMERID=gehudedengluzhanghao&USERIP=228.112.116.118&BUSITYPE=04";
    
    BestpayNativeModel *order =[[BestpayNativeModel alloc]init];
    order.orderInfo = OrderString;
//    order.orderInfo = orderStr;
    order.launchType = launchTypePay1;
    order.scheme = scheml;
    
    
    @try {
        [BestpaySDK payWithOrder:order fromViewController:self callback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
        }];

    } @catch (NSException *exception) {
        NSLog(@"exception%@",exception);
        
    } @finally {
        
    }
    
    
}


-(void)applePay{

    
    
}



-(Boolean)handleOpenURL:(NSURL *)url withCompletion:(ThirdPayCompletion )complete{
    [payingAlert setHidden:YES];
    switch (self.payType) {
        case PayType_YiPay:{
            [BestpaySDK processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"确保结果显示不会出错：%@",resultDic);
            }];

                NSString* params =[url absoluteString];
                NSDictionary *dic = [self paramsFromString:params];
                NSString *resultCode = EncodeStringFromDic(dic, @"resultCode");
                if ([resultCode isEqualToString:@"00"]) {
                    payStatus = PayStatus_PAYSUCCESS;
                    EncodeUnEmptyStrObjctToDic(_resultDict, TRADESUCCESS, @"message");
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
                    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                }else if([resultCode isEqualToString:@"01"]){
                    payStatus = PayStatus_PAYFAIL;
                    EncodeUnEmptyStrObjctToDic(_resultDict, TRADEFAILED, @"message");
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"0010", @"code");
                    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                    
                }else if([resultCode isEqualToString:@"02"]){
                    
                    payStatus = PayStatus_PAYCANCEL;
                    EncodeUnEmptyStrObjctToDic(_resultDict,TRADECANCEL, @"message");
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"6001", @"code");
                    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                }
            
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
                        EncodeUnEmptyStrObjctToDic(_resultDict, TRADESUCCESS, @"message");
                        EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
                        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                        
                    }else if ([resultStatus isEqualToString:@"6001"]){
                        payStatus = PayStatus_PAYCANCEL;
                        EncodeUnEmptyStrObjctToDic(_resultDict, TRADECANCEL, @"message");
                        EncodeUnEmptyStrObjctToDic(_resultDict, resultStatus, @"code");
                        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                        
                    }else{
                        payStatus = PayStatus_PAYFAIL;
                        EncodeUnEmptyStrObjctToDic(_resultDict, TRADEFAILED, @"message");
                        EncodeUnEmptyStrObjctToDic(_resultDict, @"0010", @"code");
                        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrap], @"content");
                    }
                    
                    NSLog(@"reslut = %@",_resultDict);
                    
                    
                }];
                
            }
        }
        case PayType_WeichatPay:{
            
            [WXApi handleOpenURL:url delegate:self];
        }
        default:
            break;
    }
    [self tradeReturn];
    
    return YES;
    
}

- (NSDictionary *)paramsFromString:(NSString *)urlStr
{
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (urlStr == nil || [urlStr isEqualToString:@""] || ![urlStr hasPrefix:self.orderInfo.appSchemeStr])
    {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *str = [urlStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://",self.orderInfo.appSchemeStr] withString:@""];
    
    if ([str isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *array = [str componentsSeparatedByString:@"&"];
    
    
    
    //此处针对2.0.0版本及后续版本的数据处理
    if ([array count])
    {
        NSDictionary *tmpDic = [[self class] paramsFromKeyValueStr:str];
        [dic setDictionary:tmpDic];
    }
    
    return dic;
}

+ (NSDictionary *)paramsFromKeyValueStr:(NSString *)str
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray *array = [str componentsSeparatedByString:@"&"];
    
    if ([array count]) {
        for (int i = 0; i < [array count]; i ++) {
            NSString *pStr = [array objectAtIndex:i];
            NSArray *kvArray = [pStr componentsSeparatedByString:@"="];
            if ([kvArray count] != 2) {
                continue;
            }
            NSString *key = [kvArray objectAtIndex:0];
            key = [key stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            NSString *value = [kvArray objectAtIndex:1];
            value = [value stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            
            [dic setObject:value forKey:key];
        }
    }
    
    return dic;
}

-(NSDictionary *)getParamsWrap{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.merchantNo, @"merchantNo");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.merchantOrderNo, @"merchantOrderNo");
    
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.orderSubject, @"orderTitle");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.orderDescription, @"orderDetail");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.memo, @"memo");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.totalAmount, @"totalAmount");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.payAmount, @"payAmount");
    
    EncodeUnEmptyStrObjctToDic(dict, self.orderNO, @"ippOrderNo");
    
    return dict;
    
}

-(void)tradeReturn{
    
    if (self.thirdPayDelegate && [self.thirdPayDelegate respondsToSelector:@selector(onPayResult:withInfo:)]) {
        [self.thirdPayDelegate onPayResult:payStatus withInfo:_resultDict];
    }
    
    if (![_viewType isEqualToString:@"NOVIEW"]) {
        if (_viewController) {
            [_viewController.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


#pragma mark pay method

-(void)queryOrder{
    
    
//    [[MOPHUDCenter shareInstance]showHUDWithTitle:@"交易查询中"
//                                             type:MOPHUDCenterHUDTypeNetWorkLoading
//                                       controller:self
//                                   showBackground:YES];
//    QueryOrderRequest *request = [[QueryOrderRequest alloc]init];
//    request.merchantNo = self.merchantNo;
//    request.orderNO = self.orderNO;
//    //    reque
//    BaseResponse *response = [[BaseResponse alloc]init];
//    [CommonService beginService:request response:response success:^(BaseResponse *response) {
//        NSLog(@"response.json......%@",response.jsonDict);
//        NSDictionary *dict = @{@"message":@"查询成功"};
//        [[MOPHUDCenter shareInstance]removeHUD];
//        
//    } failed:^(NSString *errorCode, NSString *errorMsg) {
//        [[MOPHUDCenter shareInstance]removeHUD];
//        NSDictionary *dict = @{@"message":@"查询失败",@"code":@"0001"};
//        
//    } controller:self];
//    
//    
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

-(void)scanCode:(UIViewController *)controller {
    
    QRCodeViewController *qrcode = [[QRCodeViewController alloc]init];
    
//    MerchantViewController *merchant = [[MerchantViewController alloc]init];
//    
//    
    [controller.navigationController pushViewController:qrcode animated:YES];
    
    
}

-(void)QRCode:(NSString *)code
{
    //[self.webView resetCallback:@"getBarCode"];
    NSDictionary *respDic = @{@"barCode": [NSString stringWithFormat:@"%@",code]};
    
    MerchantViewController *merchant = [[MerchantViewController alloc]init];
    [self.navigationController pushViewController:merchant animated:YES];
    
    
    
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
