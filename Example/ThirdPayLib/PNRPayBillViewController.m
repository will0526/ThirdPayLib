//
//  PNRPayBillViewController.m
//  ThirdPayLib
//
//  Created by will on 2017/7/18.
//  Copyright © 2017年 王英永. All rights reserved.
//

#import "PNRPayBillViewController.h"

 #import <WebKit/WebKit.h>


#import <ThirdPayLib/ThirdPay.h>
#import <ThirdPayLib/PNROrderInfo.h>
#import <ThirdPayLib/PNRVoucherInfo.h>
#import <ThirdPayLib/PNRGoodsInfo.h>
#import <ThirdPayLib/PNRMemberInfo.h>

@interface PNRPayBillViewController ()<UIWebViewDelegate,JSOCProtocol,WKUIDelegate,WKNavigationDelegate, WKScriptMessageHandler,ThirdPayDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)WKWebView *wkwebView;

@end

@implementation PNRPayBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //uiwebview
//    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"payBill" ofType:@"html" inDirectory:@"test"];
//    
//    NSURL *payUrl = [NSURL URLWithString:@"?userId=7ddb06174c8c455bb4c9a9d1125de6ca&mallCode=0402D101&merchantNO=01B101N01&itemNo=01B101N0101" relativeToURL:[NSURL fileURLWithPath:path]];
//    NSURLRequest* request = [NSURLRequest requestWithURL:payUrl] ;
//    _webView.delegate =self;
//    [_webView loadRequest:request];
//    [self.view addSubview:self.webView];
    
    //wkwebview
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"onBookOrder"];
    [userContentController addScriptMessageHandler:self name:@"mixcAppGetCoupons"];
    config.userContentController = userContentController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    config.preferences = preferences;
    
    self.wkwebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)configuration:config];
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"payBill" ofType:@"html" inDirectory:@"test"];
    
    NSString *param = @"?userId=7ddb06174c8c455bb4c9a9d1125de6ca&mallCode=0402D101&merchantNO=01B101N01&itemNo=null";
    param = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *payUrl = [NSURL URLWithString:param relativeToURL:[NSURL fileURLWithPath:path]];
    NSURLRequest* request = [NSURLRequest requestWithURL:payUrl] ;

    _wkwebView.backgroundColor = [UIColor redColor];
    [self.wkwebView loadRequest:request];
    self.wkwebView.UIDelegate = self;
    self.wkwebView.navigationDelegate = self;
    [self.view addSubview:self.wkwebView];
    
}

#pragma mark -- WKScriptMessageHandler start
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS调用OC方法
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@",message.body);
    
    if ([message.name isEqualToString:@"onBookOrder"]) {
        [self onBookOrder:message.body];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    

}




#pragma mark -- WKScriptMessageHandler end

#pragma mark -- webview start



- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"start");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"ok");
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    context[@"iosContext"] = self;
    
    

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"fail");
}

#pragma mark -- webview end

-(void)onBookOrder:(NSDictionary *)orderInfoDic{
    
    NSLog(@"test%@",orderInfoDic);
    
    
    
    NSString *orderStr = [orderInfoDic objectForKey:@"orderInfo"];
    NSDictionary *orderDic = [[NSDictionary alloc]init];
    
    if (![orderStr isEqualToString:@""]) {
        NSData *jsonData = [orderStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        orderDic = dic;
    }else{
        return;
    }
    
    
    
    PNROrderInfo *orderInfo = [[PNROrderInfo alloc]init];
    
    orderInfo.merchantNo = [orderDic objectForKey:@"merchantNo"];
    orderInfo.projectNo = [orderDic objectForKey:@"mallCode"];
    orderInfo.totalAmount = [orderDic objectForKey:@"totalAmount"];
    
    NSString *payType = [orderDic objectForKey:@"payType"];
    
    if ([payType isEqualToString:@"4"]) {
        orderInfo.paytype = PayType_WeichatPay;
    }else if([payType isEqualToString:@"3"]){
        orderInfo.paytype = PayType_Alipay;
    }else if([payType isEqualToString:@"5"]){
        
    }else if([payType isEqualToString:@"6"]){
        orderInfo.paytype = PayType_BaiduPay;
    }
    
    NSString *voucherStr = [orderDic objectForKey:@"coupons"];
    
    NSMutableArray *voucherArr = [[NSMutableArray alloc]init];
    if (![voucherStr isEqualToString:@""]) {
        NSData *jsonData = [voucherStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSArray *tempdic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        
        for(NSDictionary *dic in tempdic){
            PNRVoucherInfo *voucher = [[PNRVoucherInfo alloc]init];
            voucher.voucherId = [dic objectForKey:@"voucherId"];
            voucher.voucherAmount = [dic objectForKey:@"voucherAmount"];
            voucher.voucherType = [dic objectForKey:@"voucherType"];
            [voucherArr addObject:voucher];
            
        }
    }else{
        
    }
    
    
    
    
    orderInfo.voucherInfo = voucherArr;
    
    
    NSString *campaignStr = [orderDic objectForKey:@"activities"];
    
    NSMutableArray *campaignArr = [[NSMutableArray alloc]init];
    if (![campaignStr isEqualToString:@""]) {
        NSData *jsonData = [campaignStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        NSString *campaignID = [dic objectForKey:@"campaignNo"];
        [campaignArr addObject:campaignID];
    }else{
        
    }
    
    NSDate *datenow = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    NSString *merchantOrder = [dateFormatter stringFromDate:datenow];
    
    orderInfo.campaignsInfo = campaignArr;
    
    NSString *payAmount = [orderDic objectForKey:@"payAmount"];
    orderInfo.orderAmount = [orderDic objectForKey:@"orderAmount"];
    orderInfo.payAmount = payAmount;
    
    orderInfo.orderSubject = @"买单测试";
    orderInfo.accountNo = [orderDic objectForKey:@"accountNo"];
    orderInfo.accountType =[orderDic objectForKey:@"accountType"];
    orderInfo.merchantOrderNo = merchantOrder;
    orderInfo.orderDescription = @"买单测试";
    orderInfo.memo=@"买单测试";
    orderInfo.appVer = @"01";
    orderInfo.appSchemeStr = @"ThirdPayDemo";
    orderInfo.voucherNotifyURL =@"https://www.baidu.com/";
    orderInfo.notifyURL=@"https://www.baidu.com/";
    orderInfo.tradeType = TradeType_Offline;
    PNRGoodsInfo *goods = [[PNRGoodsInfo alloc]init];
    goods.itemNo = [orderDic objectForKey:@"itemNo"];
    goods.goodsName = @"测试";
    goods.goodsAmount = payAmount;
    goods.goodsNo = @"0000001";
    NSMutableArray *goodsArr = [[NSMutableArray alloc]init];
    [goodsArr addObject:goods];
    orderInfo.goodsInfo = goodsArr;
    
    [ThirdPay payWithTradeInfo:orderInfo ViewController:self Delegate:self];
    
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
