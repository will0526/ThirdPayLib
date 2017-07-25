
var isAndroid,          //是否是安卓
    isiOS,               //是否是iOS
    orderAmount,        //订单金额 全为分
    payAmount,          //支付金额
    satisfyOrderAmount, //门槛金额
    totalDisAmount,     //总优惠金额
    hasCashVoucher,     //是否有现金券
    hasDiscountVoucher, //是否有折扣券
    hasReduceVoucher,   //是否有满减券
    hasSelected,        //是否有选中券
    voucherInfos,       //优惠券列表
    selectedVoucherInfos;  //被选中优惠券列表
    

$(document).ready(function(){

    
    
    var u = navigator.userAgent;
    isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
    isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
    selectedVoucherInfos = new Array();
    getVoucherInfos(null);
    if (isAndroid) {
        AndroidWebInterface.mixcAppGetCoupons();
    }else if (isiOS) {
        window.webkit.messageHandlers.mixcAppGetCoupons.postMessage();
    };

});

function getQueryString(name) { 
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i"); 
    var r = window.location.search.substr(1).match(reg); 
    if (r != null) return unescape(r[2]); return null; 
} 
function getVoucherInfos(vouchers){
    alert("vouchers"+vouchers);
    // var voucherData = [{'voucherId':'VEHX3ATXNK4AFMB8TEKE','voucherType':'002','voucherAmount':'100'},
    // {'voucherId':'W65MPYQU7RJA9SSNQ9MV','voucherType':'002','voucherAmount':'100'},
    // {'voucherId':'R3BUWWTXR3TL5T3KTCG3','voucherType':'002','voucherAmount':'100'}];
    // var tempStr = JSON.stringify(voucherData);
    if (vouchers) {
        selectedVoucherInfos = JSON.parse(vouchers);
    }
    
    queryVoucherInfos();      
}

function queryVoucherInfos(){

    var accountNo = getQueryString("userId");//"13524689245";
    var accountType = "3";
    var merchantNo = getQueryString("merchantNo");
    //TODO
    merchantNo = merchantNo.substring(0,14);
    var projectNo = getQueryString("mallNo");
    orderAmount = parseInt(getQueryString("orderAmount"));
    payAmount = orderAmount;
    var appType = "01";
    var tradeType = "01";
    if ( merchantNo == null || projectNo== null || orderAmount == null || appType==null ||tradeType==null) {
        alert("参数异常");
        return;
    }
    
    var temp = {
                'merchantNO' : merchantNo,
                'accountType' : accountType,
                'accountNo' : accountNo,
                'projectNo' : projectNo,
                'orderAmount' : orderAmount,
                'tradeType' : tradeType,
                'appType'   : appType
            };
    
    console.log("h5.....data",temp);
    var data = queryVoucher({
                'merchantNO' : merchantNo,
                'accountType' : accountType,
                'accountNo' : accountNo,
                'projectNo' : projectNo,
                'orderAmount' : orderAmount,
                'tradeType' : tradeType,
                'appType'   : appType
            },function(data){
                
                $("#pageTitle").html("使用优惠");
                if (data.code == "0000"){
                    console.log("voucher ....data",data.data);
                    voucherInfos = data.data.VoucherInfo;
                    showVoucher(voucherInfos);
                }else {
                    alert("获取优惠券失败，请稍后再试");
                }
            });
}

//展示优惠券
function showVoucher(data){

    if(voucherInfos.length == 0){
        $('#content').html("<div class =\"noContent\"><p>当前订单无可用优惠券</p></div>");
        return;
    }

    var voucherListStr = "<div class=\"voucherList\">";
    
    for (var i in voucherInfos) {
        var voucher = voucherInfos[i];

        voucherListStr = voucherListStr 
        + "    <div class=\"voucher\" id=\""+voucher.voucherId+"\" value=\"able\">"
        + "        <div class=\"voucherContent unChecked\">"
        + "        <div class=\"retangle checked \"></div>"


        + "        <div class= \"amount\">";

        if (voucher.voucherType == "5") {
            voucherListStr = voucherListStr
            + "             <div class=\"voucherAmount\">"
            + "               <div  class = \"currency\">￥</div>";
            if (((voucher.voucherAmount/100).toFixed(2) - (voucher.voucherAmount/100).toFixed(0))>0) {
                voucherListStr+= (voucher.voucherAmount/100).toFixed(2);
            }else{
                voucherListStr+= (voucher.voucherAmount/100).toFixed(0);
            }
            voucherListStr = voucherListStr
            + "             </div>"
            + "             <div class=\"satisfyOrderAmount\">"
            + "                   无门槛使用"
            + "              </div>";

        }else if ("4" == voucher.voucherType) {
            voucherListStr = voucherListStr
            + "             <div class=\"voucherAmount\">"
            + "                 "+(voucher.discount/10).toFixed(1)+"折"
            + "             </div>"
            + "             <div class=\"satisfyOrderAmount\">"
            + "                   满";
            if (((voucher.satisfyOrderAmount/100).toFixed(2) - (voucher.satisfyOrderAmount/100).toFixed(0))>0) {
                voucherListStr+= (voucher.satisfyOrderAmount/100).toFixed(2);
            }else{
                voucherListStr+= (voucher.satisfyOrderAmount/100).toFixed(0);
            }
            voucherListStr = voucherListStr+"元可用"
            + "              </div>";
        // }else if ("2" == voucher.voucherType) {
        }else{
            voucherListStr = voucherListStr
            + "             <div class=\"voucherAmount\">"
            + "                 <div  class = \"currency\">￥</div>";
            if (((voucher.voucherAmount/100).toFixed(2) - (voucher.voucherAmount/100).toFixed(0))>0) {
                voucherListStr+= (voucher.voucherAmount/100).toFixed(2);
            }else{
                voucherListStr+= (voucher.voucherAmount/100).toFixed(0);
            }
            voucherListStr = voucherListStr
            + "             </div>"
            + "             <div class=\"satisfyOrderAmount\">"
            + "                   满";
            if (((voucher.satisfyOrderAmount/100).toFixed(2) - (voucher.satisfyOrderAmount/100).toFixed(0))>0) {
                voucherListStr+= (voucher.satisfyOrderAmount/100).toFixed(2);
            }else{
                voucherListStr+= (voucher.satisfyOrderAmount/100).toFixed(0);
            }
            voucherListStr = voucherListStr+"元可用"
            + "              </div>";
            
        }

        voucherListStr = voucherListStr
        + "          </div>"
        + "         <div class=\"voucherTitle\">"
        +           voucher.subTitle
        + "         </div>"
        + "         <div class=\"voucherDesc\">"
        +           voucher.voucherName
        + "         </div>"
        + "         <div class=\"voucherLimit\">";

        var useLimitStr = "限";
        for (var i in voucher.UseTradeType) {
            if (i != 0) {
                useLimitStr = useLimitStr+"、"
            };
            var tempTradeType = voucher.UseTradeType[i];
            if (tempTradeType.tradeType == "01") {
                useLimitStr = useLimitStr+"线上购物";
            }else if (tempTradeType.tradeType == "02") {
                useLimitStr = useLimitStr+"线下买单";
            }
        }

        voucherListStr = voucherListStr+useLimitStr+"使用"
        + "         </div>"
        + "         <hr size=1>"
        + "         <div class=\"voucherExpire\">"
        + "             有效期："+voucher.startTime +"-"+voucher.expirationTime
        + "         </div>"
        + "     </div> </div>"

        if (i == 10) break;

    };

    voucherListStr = voucherListStr + "</div> "

    var voucherSubmitStr = "<div class=\"property submitBtn enableBtn\" id=\"vouchersubmitBtn\" value=\"enable\"><p id=\"vouchersubmit\">确定</p></div>"
    voucherListStr = voucherListStr + voucherSubmitStr;
    $('#content').html(voucherListStr);
    refreshView();

    $('.voucher').click(function (){
        if ($(this).attr("value") == "able") {
            $(this).attr("value","checked");

            $(this).children(".voucherContent").children(".retangle").attr("style","display:inline;");

            caculateAmount();
            refreshView();

        }else if ($(this).attr("value") == "enable") {

            return;
        }else if ($(this).attr("value") == "checked") {

            $(this).children(".voucherContent").children(".retangle").attr("style","display: none;");
            $(this).attr("value","able");
            
            caculateAmount();
            refreshView();
        }
    });
    if (selectedVoucherInfos && selectedVoucherInfos.length>0) {
        markVouchers();
    }

    $('#vouchersubmitBtn').click(function(){
        if ($('#vouchersubmitBtn').attr("value") == "enable") {

        }else if($('#vouchersubmitBtn').attr("value") == "able"){
            var data = {
                'amount':totalDisAmount,
                'coupons':selectedVoucherInfos
            };

            console.log(".......select...... voucher ....data",JSON.stringify(data));
            totalDisAmount = (totalDisAmount/100).toFixed(2);
            if (isAndroid) {
                AndroidWebInterface.onCouponSelect(totalDisAmount,JSON.stringify(selectedVoucherInfos));
            }else if (isiOS) {
                window.webkit.messageHandlers.onCouponSelect.postMessage({amount:totalDisAmount,coupons:JSON.stringify(selectedVoucherInfos)});
            };

        }
    });
}

//标记已选优惠券
function markVouchers(){
    if (selectedVoucherInfos.length>0) {
        for (var i in selectedVoucherInfos) {
            var voucher = selectedVoucherInfos[i];
            $("#"+voucher.voucherId).attr("value","checked");
            $("#"+voucher.voucherId).children(".voucherContent").children(".retangle").attr("style","display:inline;");
        }
        caculateAmount();
        refreshView();
    }

}

function caculateAmount(){
    satisfyOrderAmount = orderAmount;
    payAmount = orderAmount;
    totalDisAmount = 0;
    hasDiscountVoucher = false;
    hasCashVoucher = false;
    hasReduceVoucher = false;
    hasSelected = false;
    selectedVoucherInfos = new Array();

//因业务需要计算顺序有要求，顾需要遍历

    for (var i in voucherInfos) {

        var voucher = voucherInfos[i];
        if ($("#"+voucher.voucherId).attr("value") == "checked") {
            hasSelected = true;
            
            var voucherIdStr = voucher.voucherId;
            var voucherTypeStr = voucher.voucherType;
            var voucherAmountStr;
            


            if ("5" == voucher.voucherType) {
                //现金券
                if (satisfyOrderAmount<voucher.satisfyOrderAmount) {
                    return false;
                }else{

                    hasCashVoucher = true;
                    payAmount = payAmount - voucher.voucherAmount;
                    satisfyOrderAmount = satisfyOrderAmount - voucher.voucherAmount;
                    if (payAmount>0) {
                        voucherAmountStr = voucher.voucherAmount;
                    }else{
                        voucherAmountStr = payAmount;

                    }
                }
                
            }else if ("4" == voucher.voucherType) {  
                   //折扣券
                if (satisfyOrderAmount<voucher.satisfyOrderAmount) {
                    return false;
                }else{
                    
                    hasDiscountVoucher = true;
                    var discountAmount = payAmount - ((payAmount*voucher.discount)/100).toFixed(0);
                    payAmount = ((payAmount*voucher.discount)/100).toFixed(0);
                    if (voucher.satisfyOrderAmount == 0) {
                        satisfyOrderAmount = satisfyOrderAmount - (payAmount*(100 -voucher.discount))/100;
                    }else{
                        satisfyOrderAmount = satisfyOrderAmount - voucher.satisfyOrderAmount;    
                    }
                    voucherAmountStr = discountAmount;

                    
                }         
                
            }else if ("2" == voucher.voucherType) {
                //满减券
                if (satisfyOrderAmount<voucher.satisfyOrderAmount) {
                    return false;
                }else{
                    hasReduceVoucher = true;
                    payAmount = payAmount - voucher.voucherAmount;
                    if (voucher.satisfyOrderAmount == 0) {
                        satisfyOrderAmount = satisfyOrderAmount - voucher.voucherAmount;
                    }else{
                        satisfyOrderAmount = satisfyOrderAmount - voucher.satisfyOrderAmount;    
                    }

                    if (payAmount>0) {
                        voucherAmountStr = voucher.voucherAmount;
                    }else{
                        voucherAmountStr = payAmount;

                    }
                }
                
            }
            var voucherData = {"voucherId":voucherIdStr,"voucherType":voucherTypeStr,"voucherAmount":voucherAmountStr};
            selectedVoucherInfos.push(voucherData);
        }
        payAmount = (payAmount*100/100).toFixed(0);

        if (payAmount<0) {
            payAmount =0;
            break;
        }
        
    }
    
    totalDisAmount = orderAmount - payAmount;

}

function refreshView(){


    //更新页面UI
    // $("#vouchersubmit").text("金额:￥"+(payAmount/100).toFixed(2)+"元");

    if (hasSelected) {
        $("#vouchersubmitBtn").removeClass("enableBtn");
        $("#vouchersubmitBtn").attr("value","able")
    }else{
        $("#vouchersubmitBtn").addClass("enableBtn");
        $("#vouchersubmitBtn").attr("value","enable");
    }

    for (var i in voucherInfos) {

        var voucher = voucherInfos[i];
        var docElement = $("#"+voucher.voucherId);

        if (docElement.attr("value") != "checked") {

            docElement.removeClass("disable");
            if(!checkVoucher(i)){
                //券不可用
                docElement.addClass("disable");
                docElement.attr("value","enable");
                
            }else{
                //券可用
                docElement.attr("value","able");
            }
        }
    }

}

function checkVoucher(index){
    //检查券是否可用
    satisfyOrderAmount = orderAmount;
    payAmount = orderAmount;

    var temp = voucherInfos[index];
    if ( ("2" == temp.voucherType) && hasCashVoucher && hasReduceVoucher) {
        return false;
        //现金券和满减券叠加使用时，可以使用多张现金券仅限叠加使用一张满减券
    }

    for (var i in voucherInfos) {
        var voucher = voucherInfos[i];
        if ($("#"+voucher.voucherId).attr("value") == "checked" || index == i) {
            if ("5" == voucher.voucherType) {
                if (satisfyOrderAmount<voucher.satisfyOrderAmount) {
                    return false;
                }else{
                    payAmount = payAmount - voucher.voucherAmount;
                    satisfyOrderAmount = satisfyOrderAmount - voucher.voucherAmount;
                }
                
            }else if ("4" == voucher.voucherType) {     
                if (satisfyOrderAmount<voucher.satisfyOrderAmount) {
                    return false;
                }else{
                    payAmount = (payAmount*voucher.discount)/100;
                    if (voucher.satisfyOrderAmount == 0) {
                        satisfyOrderAmount = satisfyOrderAmount - (payAmount*(100 -voucher.discount))/100;
                    }else{
                        satisfyOrderAmount = satisfyOrderAmount - voucher.satisfyOrderAmount;    
                    }
                    
                }         
                
            }else if ("2" == voucher.voucherType) {
                if (satisfyOrderAmount<voucher.satisfyOrderAmount) {
                    return false;
                }else{
                    payAmount = payAmount - voucher.voucherAmount;
                    if (voucher.satisfyOrderAmount == 0) {
                        satisfyOrderAmount = satisfyOrderAmount - voucher.voucherAmount;
                    }else{
                        satisfyOrderAmount = satisfyOrderAmount - voucher.satisfyOrderAmount;    
                    }
                }
                
            }
        }
        
        
    }
    return true;

}
