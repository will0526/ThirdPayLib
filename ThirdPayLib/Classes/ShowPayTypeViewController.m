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
#import "VoucherTableViewCell.h"
#import "QueryMemberRequest.h"
#import <BaiduWallet_Portal/BDWalletSDKMainManager.h>

#import "ThirdPayManager.h"



@interface ShowPayTypeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,WXApiDelegate,QRCodeDelegate,BDWalletSDKMainManagerDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UITableView *backtableView;
@property(nonatomic, strong)UITableView *vouchertableView;


@property(nonatomic, strong)UIView *headView;
@property(nonatomic, strong)UIButton *payButton;
@property(nonatomic, strong)NSString *orderNO;
@property(nonatomic, strong)NSMutableArray *voucherArr;
@end

@implementation ShowPayTypeViewController
{
    
    NSArray * payDataSource;
    NSArray * payTypeIcon;
    int payCellHeight;
    int voucherHeight;
    NSInteger selectedPayType;
    
    UILabel *orderTitleLabel;
    UILabel *payAmountLabel;
    int payAmount;
    UILabel *orderNOLabel;
    UILabel *memoLabel;
    UILabel *redPocketLabel;
    UILabel *pointLabel;
    PayStatus payStatus;
    NSString *OrderString;
    NSMutableDictionary *_resultDict;
    BOOL isCancel;
    BOOL hasSelected;//是否选择可重用优惠券
    UIAlertView *cancelAlert;
    UIAlertView *payingAlert;
    NSMutableArray *vouchDataSource;
    
    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单确认";
    payCellHeight = 50;
    voucherHeight = 100;
    
    payAmount = [self.orderInfo.totalAmount intValue];
    vouchDataSource = [[NSMutableArray alloc]init];
    _voucherArr = [[NSMutableArray alloc]init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    
//    payDataSource = @[@"翼支付",@"微信支付",@"支付宝支付",@"百度钱包支付",@"Apple Pay"];
    payDataSource = @[@"微信支付",@"支付宝支付",@"百度钱包",@"翼支付",];
    payTypeIcon = @[@"weixinIcon",@"alipayIcon",@"baiIcon",@"YipayIcon",@"applepayIcon"];
    selectedPayType = 0;
    _resultDict = [[NSMutableDictionary alloc]init];
    if (![_viewType isEqualToString:@"NOVIEW"]) {
        [self queryVoucherInfo];
    }
   
    
}

-(void)queryVoucherInfo{
    
    
    NSString *merchantNo = self.orderInfo.merchantNo;
    NSString *orderAmount = self.orderInfo.totalAmount;
    NSString *accountNo = self.orderInfo.accountNo;
    NSString *accountType = self.orderInfo.accountType;
    
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@"订单生成中"
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:self
                                   showBackground:YES];
    QueryMemberRequest *request = [[QueryMemberRequest alloc]init];
    request.merchantNo = merchantNo;
    request.accountType = accountType;
    request.accountNo = accountNo;
    request.orderAmount = orderAmount;
    request.projectNo = self.orderInfo.projectNo;
    
    BaseResponse *response = [[BaseResponse alloc]init];
    
    [CommonService beginService:request response:response success:^(BaseResponse *response) {
        
        NSLog(@"response.json......%@",response.jsonDict);
        
        NSDictionary *dict = response.jsonDict;
        
        NSArray *tempArr = EncodeArrayFromDic(EncodeDicFromDic(dict, @"data"), @"VoucherInfo");
        
        for (NSDictionary *temp in tempArr) {
            VoucherData *voucher = [VoucherData initWithDict:temp];
            [vouchDataSource addObject:voucher];
        }
        
        [[MOPHUDCenter shareInstance]removeHUD];
        
        [self showView];
        
    } failed:^(NSString *errorCode, NSString *errorMsg) {
        
        [[MOPHUDCenter shareInstance]removeHUD];
        [self showView];
        
    } controller:self showProgressBar:NO];


    

}


-(void)showView{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 500)];
    backView.backgroundColor = [UIColor clearColor];
    [backView addSubview:self.headView];
    self.tableView.frame = CGRectMake(0, self.headView.bottom, self.view.width, self.tableView.height);
    [backView addSubview:self.tableView];
    backView.frame = CGRectMake(0, 0, self.view.width, self.tableView.bottom);
    self.backtableView.tableHeaderView = backView;
    
    [self.view addSubview:self.backtableView];
    [self.view addSubview:self.payButton];
}


-(void)bookOrder{
//    
//    OrderString = @"sp_no=9000100005&version=2&currency=1&order_no=918712297565&pay_type=2&goods_desc=%C9%CC%C6%B7%C3%E8%CA%F6&goods_name=%C9%CC%C6%B7%C3%FB%B3%C6&return_url=http%3A%2F%2Fipp.pnrtec.com%2Freceiver%2F0006%2F0005%2F01.html&sign_method=1&service_code=1&total_amount=1&input_charset=1&order_create_time=20170508190137&sign=544046f1c97a60629b4f736902f33a4e";
//    [self gotoPay];
//    return;
    
    
    BOOL background = YES;
    if ([_viewType isEqualToString:@"NOVIEW"]) {
        background = NO;
    }
    
    BookOrderRequest *request = [[BookOrderRequest alloc]init];
    
    request.merchantNo = self.orderInfo.merchantNo;
    
    request.projectNo = self.orderInfo.projectNo;
    request.merchantOrderNo = self.orderInfo.merchantOrderNo;
    request.tradeTpye = self.orderInfo.tradeType;
    request.orderAmount = self.orderInfo.orderAmount;
    request.appVer = self.orderInfo.appVer;
    request.accountNo = self.orderInfo.accountNo;
    request.accountType = self.orderInfo.accountType;
    request.memo = self.orderInfo.memo;
    request.orderTitle = self.orderInfo.orderSubject;
    request.orderDetail = self.orderInfo.orderDescription;
    request.totalAmount = self.orderInfo.totalAmount;
    if([_viewType isEqualToString:@"NOVIEW"]){
        request.payAmount = self.orderInfo.payAmount;
        request.voucherInfo = self.orderInfo.voucherInfo;
    }else{
        request.payAmount = [NSString stringWithFormat:@"%d",payAmount] ;
        request.voucherInfo = self.voucherArr;
    }
    
    request.goodsInfo   = self.orderInfo.goodsInfo;
    request.campaignsInfo = self.orderInfo.campaignsInfo;
    
    request.payType = self.orderInfo.paytype;
    request.notifyURL = self.orderInfo.notifyURL;
    request.voucherNotifyURL = self.orderInfo.voucherNotifyURL;
    
    BaseResponse *response = [[BaseResponse alloc]init];
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@""
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:self
                                   showBackground:background];
    
    [CommonService beginService:request response:response success:^(BaseResponse *response) {
        
        NSLog(@"response.json......%@",response.jsonDict);
        
        NSDictionary *data = EncodeDicFromDic(response.jsonDict, @"data");
        NSString *respcode = EncodeStringFromDic(response.jsonDict, @"code");
        self.orderNO = EncodeStringFromDic(data, @"ippOrderNo");
        
        
        if([@"0000" isEqualToString:respcode]){
            OrderString = EncodeStringFromDic(data, @"transMsg");
            [self gotoPay];
        }else if([@"9999" isEqualToString:respcode]){
            [self payComplete];
            
        }
        
        
        [[MOPHUDCenter shareInstance]removeHUD];
        
    } failed:^(NSString *errorCode, NSString *errorMsg) {
        
        if([errorCode isEqualToString:@"9001"]){
            
            payStatus = PayStatus_PAYTIMEOUT;
           
        }else{
            
            payStatus = PayStatus_PAYFAIL;
        }
        
        EncodeUnEmptyStrObjctToDic(_resultDict, errorMsg, @"message");
        EncodeUnEmptyStrObjctToDic(_resultDict, errorCode, @"code");
        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
        
        [self tradeReturn];
        
        [[MOPHUDCenter shareInstance]removeHUD];
    } controller:self showProgressBar:NO];
    
    
}

-(void)payComplete{
    
    //TODO
    [self getParamsWrapForPay];
    EncodeUnEmptyStrObjctToDic(_resultDict, @"支付成功", @"message");
    EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
    [self tradeReturn];
    
    
}


- (void)testPay{
    
    ThirdPayType payType = ThirdPayType_YiPay;
    switch (self.orderInfo.paytype) {
        case PayType_Alipay:
        {
            payType = ThirdPayType_Alipay;
            
        }
            break;
        case PayType_YiPay:
        {
            payType = ThirdPayType_YiPay;
            
            
        }
            break;
        case PayType_WeichatPay:
        {
            payType = ThirdPayType_WeichatPay;
        }
            break;
            
        case PayType_BaiduPay:
        {
            payType = ThirdPayType_BaiduPay;
            
        }
            break;
        case PayType_ApplePay:
        {
            payType = ThirdPayType_ApplePay;
        }
            break;
            
        default:
            break;
    }
    
    [ThirdPayManager pay:OrderString payType:payType CallBack:^(ThirdPayResult code, NSString *message, NSString *alipaySign) {
        
        switch (code) {
            case ThirdPayResult_CANCEL:
                payStatus = PayStatus_PAYCANCEL;
                break;
            case ThirdPayResult_SUCCESS:
                payStatus = PayStatus_PAYSUCCESS;
                break;
            case ThirdPayResult_EXCEPTION:
                payStatus = PayStatus_PAYTIMEOUT;
                break;
            case ThirdPayResult_UNKNOWTYPE:
                payStatus = PayStatus_PAYTIMEOUT;
                break;
            case ThirdPayResult_PAYING:
                payStatus = PayStatus_PAYTIMEOUT;
                break;
            case ThirdPayResult_FAILED:
                payStatus = PayStatus_PAYFAIL;
                break;
            default:
                break;
        }
        if (IsStrEmpty(alipaySign)) {
            [self tradeReturn];
        }else{
            [self tradeReturn:alipaySign];
        }
        
    }];
    
}

-(void)gotoPay{
    
    
    [self testPay];
    return;
    
    if (IsStrEmpty(OrderString)) {
        [self tradeReturn];
        return;
    }
    
    payingAlert = [[UIAlertView alloc]initWithTitle:@"支付中。。。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [payingAlert show];
    
    switch (self.orderInfo.paytype) {
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
            [self baiduPay];
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
            EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
            [self tradeReturn];
        }
            break;
            
        default:
            break;
    }
}

-(UIButton *)payButton{
    
    if (_payButton == nil) {
        _payButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
        
        NSString *money = [self moneyTran:self.orderInfo.totalAmount ownType:1];
        [_payButton setTitle:[NSString stringWithFormat:@"确认支付￥%@元",money] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xf6a31c)] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xf6a31c)] forState:UIControlStateHighlighted];
//        _payButton.layer.cornerRadius = 3.5;
//        _payButton.clipsToBounds = YES;
        [_payButton addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _payButton;
}

-(void)payButtonPressed:(UIButton *)button{
    
    switch (selectedPayType) {
        case 0:
        {
            self.orderInfo.paytype = PayType_WeichatPay;;
            
        }
            break;
        case 1:
        {
            self.orderInfo.paytype = PayType_Alipay;
        }
            break;
        case 2:
        {
            self.orderInfo.paytype = PayType_BaiduPay;
        }
            break;
        
        case 3:
        {
            self.orderInfo.paytype = PayType_YiPay;
        }
            break;
        case 4:
        {
            self.orderInfo.paytype = PayType_ApplePay;
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
        
        orderTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.width - 60, 30)];
        orderTitleLabel.textAlignment = NSTextAlignmentLeft;
        orderTitleLabel.font = [UIFont systemFontOfSize:16];
        orderTitleLabel.text = [NSString stringWithFormat:@"订单详情：%@",self.orderInfo.orderSubject];
        [_headView addSubview:orderTitleLabel];
        
        payAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderTitleLabel.left, orderTitleLabel.bottom, orderTitleLabel.width, orderTitleLabel.height)];
        payAmountLabel.textAlignment = NSTextAlignmentLeft;
        payAmountLabel.font = [UIFont systemFontOfSize:16];
        NSString *money = [self moneyTran:self.orderInfo.totalAmount ownType:1];
        payAmountLabel.text = [NSString stringWithFormat:@"订单金额：￥%@元",money];
        [_headView addSubview:payAmountLabel];
        
        
        orderNOLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, payAmountLabel.bottom, payAmountLabel.width, orderTitleLabel.height)];
        orderNOLabel.textAlignment = NSTextAlignmentLeft;
        orderNOLabel.font = [UIFont systemFontOfSize:16];
        orderNOLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.orderInfo.merchantOrderNo];
        [_headView addSubview:orderNOLabel];
        
        
        [_headView addSubview: self.vouchertableView];
        
        _headView.frame = CGRectMake(0, 0, self.view.width, self.vouchertableView.bottom+10);
    }
    return _headView;
    
}

-(UITableView *)vouchertableView{
    if (_vouchertableView == nil) {
        _vouchertableView = [[UITableView alloc]initWithFrame:CGRectMake(0, orderNOLabel.bottom, self.view.width, voucherHeight*vouchDataSource.count)];
        _vouchertableView.dataSource = self;
        _vouchertableView.delegate = self;
        _vouchertableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    return _vouchertableView;
    
}


-(UITableView *)backtableView{
    if (_backtableView == nil) {
        self.backtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.height - 50 -64) style:UITableViewStylePlain];
        
        self.backtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _backtableView;
}


#pragma mark tableView start



-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, payCellHeight*payDataSource.count) style:UITableViewStylePlain];
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
    if (tableView != self.tableView) {
        return vouchDataSource.count;
    }
    return payDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView != self.tableView) {
        //优惠券列表
        static NSString  *vouchidentify = @"voucherInfoCell";
        VoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vouchidentify];
        if (cell == nil) {
            cell= [[VoucherTableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vouchidentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
        cell.voucher = (VoucherData*)vouchDataSource[indexPath.row];
        [cell loadContent];
        
        return cell;
    }else{
        //支付方式列表
        static NSString  *identify = @"payTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 16, 25, 25)];
            iconView.image = [UIImage getImageFromBundle:[NSString stringWithFormat:@"%@",payTypeIcon[indexPath.row]]];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            [cell addSubview:iconView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.right + 20, 15, self.view.width -120, 30)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.text = payDataSource[indexPath.row];
            titleLabel.font = [UIFont systemFontOfSize:16];
            [cell addSubview:titleLabel];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 49, self.view.frame.size.width, 1)];
            line.backgroundColor = HEX_RGB(0xebebeb);
            [cell addSubview:line];
            
            
        }
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        if (indexPath.row == selectedPayType ) {
            
            UIImageView *selectView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 30, 30)];
            selectView.contentMode = UIViewContentModeScaleAspectFit;
            selectView.image = [UIImage getImageFromBundle:@"checked"];
            [back addSubview:selectView];
            cell.accessoryView = back;
        }else{
            cell.accessoryView = nil;
        }
        
        
        return cell;
    
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView != self.tableView) {
        return voucherHeight;
    }
    return payCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView != self.tableView) {
        VoucherTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        VoucherData *voucher = cell.voucher;
        
        voucher.selected = !voucher.selected;
//        if (voucher.selected) {
//            
//            return;
//        }
//        
//        if (voucher.superposeType) {//可以重用优惠券
//            
//            if (!(payAmount>[voucher.satisfyOrderAmount intValue]) && hasSelected) {
//                [self presentSheet:@"不满足优惠券使用条件"];
//                return;
//            }
//            
//            for (VoucherData *temp in vouchDataSource) {
//                
//                
//                if (temp.superposeType == NO) {
//                    temp.selected = NO;
//                }
//            }
//            voucher.selected = YES;
//            hasSelected = YES;
//            
//        }else{
//            NSInteger i=0;
//            hasSelected = NO;
//            for (VoucherData *temp in vouchDataSource) {
//                if (i != indexPath.row) {
//                    temp.selected = NO;
//                }else{
//                    temp.selected = YES;
//                }
//                i++;
//            }
//        }
        [tableView reloadData];
        [self resetPayAmount];
        
        
    
    }else{
        if (selectedPayType != indexPath.row) {
            selectedPayType = indexPath.row;
            
            [tableView reloadData];
        }
        
    }
    
}

-(void)resetPayAmount{
    
    payAmount = [self.orderInfo.totalAmount intValue];
    [self.voucherArr removeAllObjects];
    for (VoucherData *temp in vouchDataSource) {
        
        if (temp.selected) {
            
            if ([temp.voucherType isEqualToString:@"4"]) {
                payAmount = payAmount*[temp.discount floatValue];
            }else{
                
                payAmount = payAmount - [temp.voucherAmount intValue];
                if (payAmount < 0) {
                    payAmount = 0;
                }
            }
            PNRVoucherInfo *voucher = [[PNRVoucherInfo alloc]init];
            voucher.voucherAmount = temp.voucherAmount;
            voucher.voucherId = temp.voucherId;
            voucher.voucherType = temp.voucherType;
            [self.voucherArr addObject:voucher];
            
        }
        
    }
    NSString *money = [self moneyTran:[NSString stringWithFormat:@"%d",payAmount] ownType:1];
    [_payButton setTitle:[NSString stringWithFormat:@"确认支付￥%@元",money] forState:UIControlStateNormal];


}

#pragma mark tableView end

#pragma mark pay method

//百度钱包

-(void)baiduPay{

    
    BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
    [payMainManager setDelegate:self];
    [payMainManager setRootViewController:self];
   BDWalletSDKErrorType type = [payMainManager doPayWithOrderInfo:OrderString params:nil delegate:self];
    //调用支付接口
    [payMainManager doPayWithOrderInfo:OrderString params:nil delegate:self];
    
}

-(void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString*)payDescs{
    if (statusCode == 0) {
        payStatus = PayStatus_PAYSUCCESS;
        EncodeUnEmptyStrObjctToDic(_resultDict, TRADESUCCESS, @"message");
        EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
        NSLog(@"成功");
    } else if (statusCode == 1) {
        NSLog(@"支付中");
        payStatus = PayStatus_PAYSUCCESS;
        EncodeUnEmptyStrObjctToDic(_resultDict, TRADESUCCESS, @"message");
        EncodeUnEmptyStrObjctToDic(_resultDict, @"0000", @"code");
        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
        NSLog(@"取消");
    } else if (statusCode == 2) {
        payStatus = PayStatus_PAYCANCEL;
        EncodeUnEmptyStrObjctToDic(_resultDict, TRADECANCEL, @"message");
        EncodeUnEmptyStrObjctToDic(_resultDict, @"2", @"code");
        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
        NSLog(@"取消");
    }
    
    [self tradeReturn];
    
}



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
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
                
            }else if ([resultStatus isEqualToString:@"6001"]){
                payStatus = PayStatus_PAYCANCEL;
                EncodeUnEmptyStrObjctToDic(_resultDict, TRADECANCEL, @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, resultStatus, @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
                
                
            }else{
                payStatus = PayStatus_PAYFAIL;
                EncodeUnEmptyStrObjctToDic(_resultDict, TRADEFAILED, @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, resultStatus, @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
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
    

}


//微信
-(void)weixinpay{
    
    NSData *jsonData = [OrderString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    [WXApi registerApp:weixinAppID withDescription:@"thirdPay"];
    
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
        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
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
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
                
            }
                break;
            case WXErrCodeUserCancel:
            {
                payStatus = PayStatus_PAYCANCEL;
                EncodeUnEmptyStrObjctToDic(_resultDict, TRADECANCEL, @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, [NSString stringWithFormat:@"%d",response.errCode], @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
                
            }
                break;
            default:
            {
                payStatus = PayStatus_PAYFAIL;
                EncodeUnEmptyStrObjctToDic(_resultDict, [NSString stringWithFormat:@"%@:%@",TRADEFAILED,response.errStr], @"message");
                EncodeUnEmptyStrObjctToDic(_resultDict, [NSString stringWithFormat:@"%d",response.errCode], @"code");
                EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
                DDLog(@"支付失败", response.errStr);
            }
                break;
        }
    }
}


//翼支付
-(void)yipay{

    DDLog(@"跳转支付页面带入信息:", OrderString);
    
    NSString *scheml = self.orderInfo.appSchemeStr;
//    NSString *orderStr = @"SERVICE=mobile.security.pay&MERCHANTID=01320103025740000&MERCHANTPWD=288330&SUBMERCHANTID=&BACKMERCHANTURL=http://127.0.0.1:8040/wapBgNotice.action=yzf&SIGNTYPE=MD5&MAC=A540F34032ECA7E9245DA0C5B7517F58&ORDERSEQ=2016110118425134&ORDERREQTRNSEQ=20161101184251340001&ORDERTIME=20161101184251&ORDERVALIDITYTIME=&ORDERAMOUNT=0.01&CURTYPE=RMB&PRODUCTID=04&PRODUCTDESC=联想手机&PRODUCTAMOUNT=0.01&ATTACHAMOUNT=0.00&ATTACH=88888&DIVDETAILS=&ACCOUNTID=&CUSTOMERID=gehudedengluzhanghao&USERIP=228.112.116.118&BUSITYPE=04";
    
    BestpayNativeModel *order =[[BestpayNativeModel alloc]init];
    order.orderInfo = OrderString;
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
    
    
    [ThirdPayManager handleOpenURL:url];
    return YES;
    
    
    [payingAlert setHidden:YES];
    switch (self.orderInfo.paytype) {
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
                    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
                }else if([resultCode isEqualToString:@"01"]){
                    payStatus = PayStatus_PAYFAIL;
                    EncodeUnEmptyStrObjctToDic(_resultDict, TRADEFAILED, @"message");
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"0010", @"code");
                    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
                    
                }else if([resultCode isEqualToString:@"02"]){
                    
                    payStatus = PayStatus_PAYCANCEL;
                    EncodeUnEmptyStrObjctToDic(_resultDict,TRADECANCEL, @"message");
                    EncodeUnEmptyStrObjctToDic(_resultDict, @"6001", @"code");
                    EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
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
                        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
                        
                    }else if ([resultStatus isEqualToString:@"6001"]){
                        payStatus = PayStatus_PAYCANCEL;
                        EncodeUnEmptyStrObjctToDic(_resultDict, TRADECANCEL, @"message");
                        EncodeUnEmptyStrObjctToDic(_resultDict, resultStatus, @"code");
                        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
                        
                    }else{
                        payStatus = PayStatus_PAYFAIL;
                        EncodeUnEmptyStrObjctToDic(_resultDict, TRADEFAILED, @"message");
                        EncodeUnEmptyStrObjctToDic(_resultDict, @"0010", @"code");
                        EncodeUnEmptyDicObjctToDic(_resultDict, [self getParamsWrapForPay], @"content");
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


-(NSDictionary *)getParamsWrapForTransInfo{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.merchantNo, @"ippTransNo");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.merchantOrderNo, @"payMethod");
    
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.orderSubject, @"payTransNo");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.orderDescription, @"tradeAmount");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.memo, @"payAmount");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.totalAmount, @"transStatus");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.payAmount, @"transFinishTime");
    EncodeUnEmptyStrObjctToDic(dict, self.orderNO, @"tradeDesc");
    EncodeUnEmptyStrObjctToDic(dict, self.orderNO, @"settleDate");
    
    return dict;
    
}


-(NSDictionary *)getParamsWrapForPay{
    
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

-(NSDictionary *)getParamsWrapForPay:(NSString *)alipaySign{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.merchantNo, @"merchantNo");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.merchantOrderNo, @"merchantOrderNo");
    
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.orderSubject, @"orderTitle");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.orderDescription, @"orderDetail");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.memo, @"memo");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.totalAmount, @"totalAmount");
    EncodeUnEmptyStrObjctToDic(dict, self.orderInfo.payAmount, @"payAmount");
    
    EncodeUnEmptyStrObjctToDic(dict, alipaySign, @"alipaySign");
    EncodeUnEmptyStrObjctToDic(dict, self.orderNO, @"ippOrderNo");
    
    return dict;
    
}

-(NSDictionary *)getParamsWrapForQuery{
    
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
    _resultDict = [self getParamsWrapForPay];
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

-(void)tradeReturn:(NSString *)alipaySign{
    _resultDict = [self getParamsWrapForPay:alipaySign];
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
