
var isAndroid,          //是否是安卓
    isiOS,               //是否是iOS
    iosContext,
    merchantNo,         //商户号
    orderAmount,        //订单金额 为分
    payAmount,          //支付金额  为分
    memberAmount,       //会员优惠后金额
    satisfyOrderAmount, //门槛金额 为分
    hasCashVoucher,     //是否有现金券
    hasDiscountVoucher, //是否有折扣券
    hasReduceVoucher,   //是否有满减券
    hasSelectedMember,        //是否有选中会员活动
    hasSelectedCampaign,        //是否有选中活动
    voucherInfos,       //优惠券列表
    campaignInfos,       //活动列表
    memberInfo,         //会员权益
    selectedVoucherInfos,       //被选中优惠券列表
    selectedCampaignInfos,  //被选中活动
    selectedCampaignID,  //被选中活动
    selectedCampaignToolIndex, //被选中的阶梯
    selectedPayTypeID,      //被选中的支付方式
    selectedPayTypeValue,      //被选中的支付方式
    accountNo,
    accountType,
    itemNo,
    paytypeHeight;
    
    


$(document).ready(function(){

    //查询会员
    document.title = getQueryString("title");
    var u = navigator.userAgent;
    isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
    isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
    
                      
    $("#cancelBtn").click(function(){
        $("#alertDiv").hide();
    });
    $("#OKBtn").click(function(){
        $("#alertDiv").hide();
        $("body").show();

    });

    $("#ordersubmit").unbind("click").click(function(){

        if ($(this).hasClass("ableBtn")) {
            $("#payTypeDiv").show();
            var dom = document.getElementById("payTypeDialog");
            // dom.addClass("showStyle");
            dom.style.height=paytypeHeight;
            return;
            
        }
    });

 
    $("#cancelBtnPaytype").click(function(){
        
        var dom = document.getElementById("payTypeDialog");
            dom.style.height="0px";
        $("#payTypeDiv").hide();

    });

    $("#orderAmountInput").keydown(function (event) {
        // 控制只能输入金额
        var str = "";
        if (event.keyCode == 8) {
            return true;
        }else if(event.keyCode == 190){
            str = "."
        }else{
            str = String.fromCharCode(event.keyCode);
        }

        if(! /^-?\d+\.?\d{0,2}$/.test(this.value +str)){
            return false;
        }
        }).change(function () {

            $(this).keyup();
    });

    $("#orderAmountInput").blur(function(){
        var tempAmount = $("#orderAmountInput").val();
        if (tempAmount == ""){
            $("#payAmountValueText").html("￥0");
        }else{
            $("#payAmountValueText").html("￥"+tempAmount);
        }
        
        tempAmount = tempAmount*100;
        if (tempAmount == orderAmount) {
            return;
        }
        orderAmount = tempAmount;
        satisfyOrderAmount = orderAmount;
        memberAmount = orderAmount;
        payAmount = orderAmount;
        if (orderAmount>0) {
            queryVoucherAndCampaign();
            makeMemberable(true);
            $("#ordersubmit").addClass("ableBtn");
        }else{
            makeMemberable(false);
            showVoucher(null);
            showCampaign(null);
            $("#ordersubmit").removeClass("ableBtn");
            
        }
        
    });
    queryMemberCampaign();
});



function queryMemberCampaign(){

    var accountLevel = "1";
    accountType = "3";
    merchantNo = getQueryString("merchantNo");
    
    merchantNo = merchantNo.substring(0,14);

    accountNo = getQueryString("userId");
    var projectNo = getQueryString("mallCode");

    var data = requestMemberCampaign({
                'merchantNo' : merchantNo,
                'accountType' : accountType,
                'accountNo' : accountNo,
                'projectNo' : projectNo,
                'accountLevel' : accountLevel
            },function(data){
                
                if (data.code == "0000"){
                    memberInfo = data.data;
                    if (memberInfo.title != "") {
                        showMemberCampaign();
                        $("#accountDiscountDiv").show();
                    }
                    $("body").show();
                }else {
                    $("body").show();
                    $("#accountDiscountDiv").hide();
                    $("#alertDiv").show();
                }
            });
}

function showMemberCampaign(){


    
    $("#memberDiscount").html(""+memberInfo.title);

    $('#accountDiscountDiv').unbind('click').click(function(){
        if ($('#accountDiscountDiv').attr("value") == "uncheck") {
            $(this).children(".checkIcon").addClass("checked");
            $(this).attr("value","checked");
            hasSelectedMember = true;
            caculateAllAmount();
        }else if ($('#accountDiscountDiv').attr("value") == "enable") {
            return;
        }else{
            hasSelectedMember = false;
            $(this).children(".checkIcon").removeClass("checked");
            $(this).attr("value","uncheck");
            caculateAllAmount();
        }
    });

    $("body").show();
}

function makeMemberable(able){
    if (able) {
        $("#accountDiscountDiv").attr("value","uncheck");
        $("#memberDiscount").removeClass("enableText");
        $("#memberCheckIcon").removeClass("enableIcon");
    }else{

        $("#accountDiscountDiv").attr("value","enable");
        $("#memberDiscount").addClass("enableText")
        $("#memberCheckIcon").addClass("enableIcon")
        
    }
    $("#accountDiscountAmount").html("");
    $("#memberCheckIcon").removeClass("checked");

}

//url 取参数
function getQueryString(name) { 
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i"); 
    var r = window.location.search.substr(1).match(reg); 
    if (r != null) return unescape(r[2]); return null; 
}

function queryVoucherAndCampaign(){
    
    selectedCampaignInfos = null;
    selectedVoucherInfos = null;
    selectedCampaignID = null;
    selectedCampaignToolIndex = null;
    hasSelectedMember = false;
    hasSelectedCampaign = false;
    

//    accountNo = getQueryString("userId");
//    var projectNo = getQueryString("mallCode");
//    var accountType = "3";
    var appType = "01";
    var tradeType = "01";
    itemNo = getQueryString("itemNo");// "01B101N0101";
    var campaignType = "02";

    $("#novoucherTipsDiv").hide();
    $("#voucherNetwork").show();
    var data = requestVoucherAndCampaign({
                'merchantNo' : merchantNo,
                'accountType' : accountType,
                'accountNo' : accountNo,
                'projectNo' : projectNo,
                'orderAmount' : parseInt(orderAmount),
                'itemNo' : itemNo,
                'tradeType' : tradeType,
                'campaignType' : campaignType,
                'appType'   : appType
            },function(data){
                $("#voucherNetwork").hide();
                console.log("CampaignInfo++++"+JSON.stringify(data.data) );
                
                if (data.code == "0000"){

                    voucherInfos = data.data.VoucherInfo;
                    // campaignInfos = data.data.CampaignInfo;

// {"CampaignTool":[
// {"title":"消费满10立减1元","discountType":"1","campaignAmount":1000,"campaignToolMethod":"02","discountAmount":100,"voucherNo":"","discount":100},
// {"title":"消费满15立减2元","discountType":"1","campaignAmount":1500,"campaignToolMethod":"02","discountAmount":200,"voucherNo":"","discount":200}],
// "campaignDesc":"满减100","campaignName":"满减100","campaignNo":"1499331621000720","campaignType":"1","expirationTime":"2018-10-25 18:10:00","participationCount":"1","startTime":"2016-09-07 02:10:00"},
// {"CampaignTool":[{"title":"消费满10立减1元","discountType":"0","campaignAmount":1000,"campaignToolMethod":"02","discountAmount":100,"voucherNo":"","discount":100}],
// "campaignDesc":"满减无限次","campaignName":"满减无限次","campaignNo":"1499395841000572","campaignType":"0","expirationTime":"2018-03-25 00:00:00","participationCount":"0","startTime":"2016-11-27 00:00:00"},
// {"CampaignTool":[{"title":"消费满8立减1元","discountType":"3","campaignAmount":800,"campaignToolMethod":"02","discountAmount":100,"voucherNo":"","discount":100}],
// "campaignDesc":"满减3次","campaignName":"满减3次","campaignNo":"1499395966000238","campaignType":"3","expirationTime":"2019-07-07 10:53:00","participationCount":"3","startTime":"2016-08-28 04:20:00"}
    

//start  转换

                    var tempCampaigns = data.data.CampaignInfo;
                    campaignInfos = new Array();
                    var tempNew = new Array();
                    for (var index in tempCampaigns) {
                        var tempCampaign = tempCampaigns[index];
                        if (tempCampaign.CampaignTool.length>1) {
                            var tempNewTool = new Array();
                            var newdiscountAmount = 0;
                            for(var toolIndex in tempCampaign.CampaignTool){
                                var tempCampaignTool = tempCampaign.CampaignTool[toolIndex];
                                newdiscountAmount += tempCampaignTool.discountAmount; 
                                if (toolIndex != 0) {
                                    tempCampaignTool.title = "消费满"+((tempCampaignTool.campaignAmount)/100).toFixed(0)+"立减"+(newdiscountAmount/100).toFixed(0)+"元";
                                    tempCampaignTool.discountAmount = newdiscountAmount;
                                }
                                tempNewTool.push(tempCampaignTool);
                            }
                            tempCampaign.CampaignTool = tempNewTool;
                        }
                        tempNew.push(tempCampaign);
                    }
                    campaignInfos = tempNew;
//end


                    var payInfos = data.data.PayInfo;
                    showVoucher(voucherInfos);
                    showCampaign(campaignInfos);
                    showPayType(payInfos);

                }else {
                    $("#novoucherTipsDiv").show();
                }
        });
}
//刷新展示优惠券
function showVoucher(vouchers){
    $("#voucherDiscountAmount").html("");
    if (!vouchers || (vouchers.length == 0)) {
        $('#novoucherTipsDiv').show();
        $('#voucherTitleLabel').addClass("enableText");
        $('#voucherListIcon').addClass("enableIcon");
        
        $('#voucherListDiv').html("");
        $('#voucherListDiv').hide();
        $("#voucherlisttitle").attr("value","enable");
        
        return;
    }
    $("#voucherlisttitle").attr("value","normal");
    $('#voucherTitleLabel').removeClass("enableText");
    $('#voucherListIcon').removeClass("enableIcon");

    var voucherListStr = "";
    for (var i in vouchers) {
        var voucher = vouchers[i];
        voucherListStr = voucherListStr 
        + " <div class=\"voucherContent\" id=\""+voucher.voucherId+"\" value=\"able\">";
        if (voucher.voucherType == "5") {
            voucherListStr = voucherListStr
            + "      <div class=\"voucherType\">现金券</div>";
        }else if ("4" == voucher.voucherType) {
            voucherListStr = voucherListStr
            + "      <div class=\"voucherType\">折扣券</div>";
        // }else if ("2" == voucher.voucherType) {
        }else{
            voucherListStr = voucherListStr
            + "      <div class=\"voucherType\">满减券</div>";
        }
        voucherListStr = voucherListStr
        + "          <div class=\"voucherName\">"
        +           voucher.title
        + "         </div>"
        + "         <div class=\"checkIcon\"></div></div>";

    };

    voucherListStr = voucherListStr + "<hr size=\"1\"> "
    $('#voucherListDiv').html(voucherListStr);
    $('#voucherListDiv').show();

    $('#voucherlisttitle').unbind('click').click(function(){
            if ($('#voucherlisttitle').attr("value") == "normal") {
                $(this).children(".listIcon").addClass("listFoldIcon");
                $(this).attr("value","fold");
                $('#voucherListDiv').hide();
            }else if($('#voucherlisttitle').attr("value") == "enable"){
                return;
            }else{
                $(this).children(".listIcon").removeClass("listFoldIcon");
                $(this).attr("value","normal");
                $('#voucherListDiv').show();
            }
            
    });

    $('#voucherListDiv .voucherContent').unbind('click').click(function(){
        if ($(this).attr("value") == "able") {
            $(this).attr("value","checked");
            $(this).children(".checkIcon").addClass("checked");
            caculateAllAmount();
        }else if ($(this).attr("value") == "enable") {

            return;
        }else if ($(this).attr("value") == "checked") {
            $(this).attr("value","able");
            $(this).children(".checkIcon").removeClass("checked");
            caculateAllAmount();
        }
    });
}
//刷新展示活动
function showCampaign(campaigns){
    
    if (!campaigns || (campaigns.length == 0)) {
        $('#campainDiscountAmount').html("");
        $('#noCampaignTipsDiv').show();
        $('#campaignListDiv').html("");
        $('#campaignListDiv').hide();
        $('#campaignTitleLabel').addClass("enableText");
        $('#campaignListIcon').addClass("enableIcon");
        $("#campaignlisttitle").attr("value","enable");
        
        return;
    }
    $("#campaignlisttitle").attr("value","normal");
    
    $('#campaignTitleLabel').removeClass("enableText");
    $('#campaignListIcon').removeClass("enableIcon");
    $('#noCampaignTipsDiv').hide();

    var campaignInfosListStr = "";

    if (hasSelectedMember) {
        $('#campainDiscountAmount').html("");
        for (var i in campaigns) {
            var campaign = campaigns[i];
            var showName = "";

            var tempCampaignTools = campaign.CampaignTool;
            for(var i=tempCampaignTools.length-1;i>=0;i--) {
                var CampaignTool = tempCampaignTools[i];
                if (satisfyOrderAmount>=CampaignTool.campaignAmount){
                    showName = CampaignTool.title;
                    break;
                }
            }   
            if (showName == "") {
                var i=tempCampaignTools.length-1;
                var CampaignTool = tempCampaignTools[i];
                showName = CampaignTool.title;
            }

            campaignInfosListStr = campaignInfosListStr
            + " <div class=\"voucherContent\" id=\""+campaign.campaignNo+"\" value=\"enable\">";
            
                campaignInfosListStr = campaignInfosListStr
                + "      <div class=\"voucherType\">满减</div>";
            
            campaignInfosListStr = campaignInfosListStr
            + "          <div class=\"voucherName enableText\">"
            +           showName
            + "         </div>"
            + "         <div class=\"checkIcon enableIcon\"></div></div>";
        }
    }else if (hasSelectedCampaign) {
        for (var i in campaigns) {
            var campaign = campaigns[i];
            var showName = "";
            if (selectedCampaignID == campaign.campaignNo) {
                
                var tempCampaignTools = campaign.CampaignTool;
                var CampaignTool = tempCampaignTools[selectedCampaignToolIndex];
                showName = CampaignTool.title;
                

                campaignInfosListStr = campaignInfosListStr
                + " <div class=\"voucherContent\" id=\""+campaign.campaignNo+"\" value=\"checked\">";
                    campaignInfosListStr = campaignInfosListStr
                    + "      <div class=\"voucherType\">满减</div>";
               

                campaignInfosListStr = campaignInfosListStr
                + "          <div class=\"voucherName \">"
                +           showName
                + "         </div>"
                + "         <div class=\"checkIcon checked\"></div></div>";
            }else{

                var tempCampaignTools = campaign.CampaignTool;
                for(var i=tempCampaignTools.length-1;i>=0;i--) {
                    var CampaignTool = tempCampaignTools[i];
                    if (satisfyOrderAmount>=CampaignTool.campaignAmount){
                        showName = CampaignTool.title;
                        break;
                    }
                }   
                if (showName == "") {
                    var i=tempCampaignTools.length-1;
                    var CampaignTool = tempCampaignTools[i];
                    showName = CampaignTool.title;
                }

                campaignInfosListStr = campaignInfosListStr
                + " <div class=\"voucherContent\" id=\""+campaign.campaignNo+"\" value=\"enable\">";
                    campaignInfosListStr = campaignInfosListStr
                    + "      <div class=\"voucherType\">满减</div>";
                

                campaignInfosListStr = campaignInfosListStr
                + "          <div class=\"voucherName enableText\">"
                +           showName
                + "         </div>"
                + "         <div class=\"checkIcon enableIcon\"></div></div>";
            }
        }
    }else{
        $('#campainDiscountAmount').html("");
        for (var i in campaigns) {
            var campaign = campaigns[i];
            var showName = "";
            var tempCampaignTools = campaign.CampaignTool;
            for(var i=tempCampaignTools.length-1;i>=0;i--) {
                var CampaignTool = tempCampaignTools[i];
                if (satisfyOrderAmount>=CampaignTool.campaignAmount){
                    showName = CampaignTool.title;
                    break;
                }
            }   
            if (showName == "") {
                var i=tempCampaignTools.length-1;
                var CampaignTool = tempCampaignTools[i];
                showName = CampaignTool.title;
            }
            campaignInfosListStr = campaignInfosListStr
            + " <div class=\"voucherContent\" id=\""+campaign.campaignNo+"\" value=\"able\">";
                campaignInfosListStr = campaignInfosListStr
                + "      <div class=\"voucherType\">满减</div>";
           

            campaignInfosListStr = campaignInfosListStr
            + "          <div class=\"voucherName\">"
            +           showName
            + "         </div>"
            + "         <div class=\"checkIcon\"></div></div>";
        }
    }
    
    campaignInfosListStr = campaignInfosListStr + "<hr size=\"1\"> "
    $('#campaignListDiv').html(campaignInfosListStr);
    $('#campaignListDiv').show();
    $('#campaignlisttitle').unbind('click').click(function(){
        if ($('#campaignlisttitle').attr("value") == "normal") {
            $(this).children(".listIcon").addClass("listFoldIcon");
            $(this).attr("value","fold");
            $('#campaignListDiv').hide();
        }else if($('#campaignlisttitle').attr("value") == "enable"){
                return;
        }else{
            $(this).children(".listIcon").removeClass("listFoldIcon");
            $(this).attr("value","normal");
            $('#campaignListDiv').show();
        }
    });

    $('#campaignListDiv .voucherContent').unbind('click').click(function(){
        if ($(this).attr("value") == "able") {
            $(this).attr("value","checked");
            $(this).children(".checkIcon").addClass("checked");
            hasSelectedCampaign = true;
            selectedCampaignID = $(this).attr("id");
            caculateAllAmount();
            
        }else if ($(this).attr("value") == "enable") {

            return;
        }else if ($(this).attr("value") == "checked") {
            selectedCampaignID = "";
            $(this).attr("value","able");
            hasSelectedCampaign = false;
            $(this).children(".checkIcon").removeClass("checked");
            caculateAllAmount();
        }
    });
}
//展示支付方式
function showPayType(payinfos){

    var paytypeHtmlStr = "";
    for (var i in payinfos) {
        var tempay = payinfos[i];
        var payvalue = "";
        var iconValue = "";
        if (tempay.payType == "0002") {
            payvalue = '4';//微信
            iconValue = 'weichatIcon';
        }else if (tempay.payType == "0003") {
            iconValue = 'aliIcon';
            payvalue = '3';//支付宝
        }else if (tempay.payType == "0004") {
            iconValue = 'aliIcon';
            payvalue = '4';//翼支付
        }else if (tempay.payType == "0006") {
            iconValue = 'baiduIcon';
            payvalue = '6';//百度
        }

        var payName = tempay.payName;
        var payCampaign = tempay.payCampaign;
        var payTypeID = "type"+tempay.payType;
        paytypeHtmlStr += "<div class='payType' value='"+payvalue+"' >";
        if (i==0) {
            paytypeHtmlStr += "<div  id='"+payTypeID+"' class='paytypeuncheck paytypechecked'></div>";
            selectedPayTypeID = payTypeID;
            selectedPayTypeValue = payvalue;
        }else{
            paytypeHtmlStr += "<div id='"+payTypeID+"' class='paytypeuncheck'></div>";
        }
        paytypeHtmlStr += "<div class='paytypeicon "+iconValue +"'></div><div class='paytypename'>"+payName+"</div><div class='paytypecapaigntitle'>"+payCampaign+"</div></div>";

    };

    $("#payInfos").html(paytypeHtmlStr);
    var typeCount = payinfos.length;
    paytypeHeight = ""+(125+50*typeCount)+"px";
    $("#payTypeDiv .payType").unbind("click").click(function(){

        var temDom = $("#"+selectedPayTypeID);
        temDom.removeClass("paytypechecked");
        $(this).children(".paytypeuncheck").addClass("paytypechecked");
        selectedPayTypeID = $(this).children(".paytypeuncheck").attr("id");
        selectedPayTypeValue = $(this).attr("value");
    });

    $("#bookOrder").unbind("click").click(function(){

            
            var discountType = 0;
            if (hasSelectedMember) {
                discountType = 1;
            }else if (hasSelectedCampaign) {
                memberAmount = orderAmount;
                discountType = 2;
            }else{
                memberAmount = orderAmount;
                discountType = 0;
            }
            var coupons = '';
            if (selectedVoucherInfos != null && selectedVoucherInfos.length>0) {
                coupons = JSON.stringify(selectedVoucherInfos);
            }

            var activities = '';
            if (selectedCampaignInfos != null) {
                activities = JSON.stringify(selectedCampaignInfos);
            }

            
            var temp = {
                    'totalAmount':''+orderAmount,//订单总金额
                    'orderAmount':''+memberAmount,//会员优惠后金额
                    'coupons':coupons,//优惠券
                    'accountNo':accountNo,//用户ID
                    'accountType':accountType,//用户类型
                    'itemNo':itemNo,//货号
                    'activities':activities,//选择的活动
                    'payAmount':''+payAmount,//实际支付金额
                    'mallCode':projectNo,
                    'merchantNo':merchantNo,
                    'payType':selectedPayTypeValue,
                    'discountType':discountType
                };
            alert(JSON.stringify(temp));
            if (isAndroid) {
                    AndroidWebInterface.onBookOrder(JSON.stringify(temp));
            }else if (isiOS) {
                    window.webkit.messageHandlers.onBookOrder.postMessage({orderInfo:JSON.stringify(temp)});
            }
            
                
            

    });


}

function caculateAllAmount(){
    satisfyOrderAmount = orderAmount;
    payAmount = orderAmount;
    hasDiscountVoucher = false;
    
    hasSelected = false;
    selectedVoucherInfos = new Array();
    caculateMemberAmount();
    caculateVoucherAmount();
    caculateCampaignAmount();
    $("#payAmountValueText").html("￥"+(payAmount/100).toFixed(2));
    refreshAllView();
}

function caculateMemberAmount(){
    if (hasSelectedMember) {
        payAmount = (orderAmount*memberInfo.discount);
        satisfyOrderAmount = payAmount;
        memberAmount = payAmount;
                  
        $("#accountDiscountAmount").html("-￥"+((orderAmount-payAmount)/100).toFixed(2));
    }else{
        $("#accountDiscountAmount").html("");
    }
}

function caculateVoucherAmount(){
    var tempPayAmount = payAmount;
    hasDiscountVoucher = false;
    hasCashVoucher = false;
    hasReduceVoucher = false;
    hasSelected = false;
    selectedVoucherInfos = new Array();

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
                  if ((payAmount - voucher.voucherAmount)>0) {
                  
                    voucherAmountStr = voucher.voucherAmount;
                    payAmount = payAmount - voucher.voucherAmount;
                  }else{
                  
                    voucherAmountStr = payAmount;
                    payAmount = 0;
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

                  if ((payAmount - voucher.voucherAmount)>0) {
                    voucherAmountStr = voucher.voucherAmount;
                    payAmount = payAmount - voucher.voucherAmount;
                  }else{
                    voucherAmountStr = payAmount;
                    payAmount = 0;
                  }
                }
            }
            var voucherData = {"voucherId":voucherIdStr,"voucherType":voucherTypeStr,"voucherAmount":voucherAmountStr};
            selectedVoucherInfos.push(voucherData);
        }
        if (payAmount<0) {
            payAmount =0;
            break;
        }  
    }
    if (tempPayAmount != payAmount) {
        $("#voucherDiscountAmount").html("-￥"+((tempPayAmount - payAmount)/100).toFixed(2));
    }else{
        $("#voucherDiscountAmount").html("");
    }
}

function caculateCampaignAmount(){
// {"CampaignTool":[
// {"title":"消费满10立减1元","discountType":"1","campaignAmount":1000,"campaignToolMethod":"02","discountAmount":100,"voucherNo":"","discount":100},
// {"title":"消费满15立减2元","discountType":"1","campaignAmount":1500,"campaignToolMethod":"02","discountAmount":200,"voucherNo":"","discount":200}],
// "campaignDesc":"满减100","campaignName":"满减100","campaignNo":"1499331621000720","campaignType":"1","expirationTime":"2018-10-25 18:10:00","participationCount":"1","startTime":"2016-09-07 02:10:00"},
// {"CampaignTool":[{"title":"消费满10立减1元","discountType":"0","campaignAmount":1000,"campaignToolMethod":"02","discountAmount":100,"voucherNo":"","discount":100}],
// "campaignDesc":"满减无限次","campaignName":"满减无限次","campaignNo":"1499395841000572","campaignType":"0","expirationTime":"2018-03-25 00:00:00","participationCount":"0","startTime":"2016-11-27 00:00:00"},
// {"CampaignTool":[{"title":"消费满8立减1元","discountType":"3","campaignAmount":800,"campaignToolMethod":"02","discountAmount":100,"voucherNo":"","discount":100}],
// "campaignDesc":"满减3次","campaignName":"满减3次","campaignNo":"1499395966000238","campaignType":"3","expirationTime":"2019-07-07 10:53:00","participationCount":"3","startTime":"2016-08-28 04:20:00"}
    
    
    if (hasSelectedCampaign) {
        selectedCampaignToolIndex =null;
        var tempPayAmount = payAmount;
        for (var i in campaignInfos) {
            var campaign = campaignInfos[i];
            if ($("#"+campaign.campaignNo).attr("value") == "checked"){
                var tempCampaignTools = campaign.CampaignTool;
                
                selectedCampaignToolIndex = 0;
                if (campaign.campaignType == 0) {
                    var CampaignTool = campaign.CampaignTool[0];
                    //每满无次数
                    for(var i=0;i<0;i++){
                        if (satisfyOrderAmount>=CampaignTool.campaignAmount) {
                            payAmount = (payAmount - CampaignTool.discountAmount).toFixed(2);
                            satisfyOrderAmount = (satisfyOrderAmount - CampaignTool.campaignAmount).toFixed(2);
                        }else{
                            break;
                        }
                    }
                }else if (campaign.campaignType == 1) {
                    //阶梯
                    for(var i=tempCampaignTools.length-1;i>=0;i--){
                        var CampaignTool = campaign.CampaignTool[i];
                        if (satisfyOrderAmount>=CampaignTool.campaignAmount) {
                            selectedCampaignToolIndex = i;
                            payAmount = (payAmount - CampaignTool.discountAmount).toFixed(2);
                            satisfyOrderAmount = (satisfyOrderAmount - CampaignTool.campaignAmount).toFixed(2);
                            break;
                        }
                    }
                }else if (campaign.campaignType>1) {
                    var CampaignTool = campaign.CampaignTool[0];
                    selectedCampaignToolIndex = 0;
                    //每满有次数的
                    for(var i=0;i<campaign.campaignType;i++){
                        if (satisfyOrderAmount>=CampaignTool.campaignAmount) {
                            payAmount = (payAmount - CampaignTool.discountAmount).toFixed(2);
                            satisfyOrderAmount = (satisfyOrderAmount - CampaignTool.campaignAmount).toFixed(2);
                        }else{
                            break;
                        }
                        
                        
                    }
                }

            }
        }
        selectedCampaignInfos = {
            campaignNo:selectedCampaignID,
            campaignAmount:(tempPayAmount -payAmount)
        };
        if (tempPayAmount != payAmount) {
            $("#campainDiscountAmount").html("-￥"+((tempPayAmount -payAmount)/100).toFixed(2));
        }else{
            $("#campainDiscountAmount").html("");
        }
        

    }else{
        $("#campainDiscountAmount").html("");
    }

}

function refreshAllView(){
    refreshMemberView();
    refreshVoucherView();
    refreshCampaignView();
}

function refreshMemberView(){
    if (hasSelectedMember) {
        return;
    }else if (hasSelectedCampaign) {
        makeMemberable(false);
    }else {
        if (checkAble(true,null,null)) {
            makeMemberable(true);
        }else{
            makeMemberable(false);
        }
    }
}

function refreshVoucherView(){

    //更新页面UI
    for (var i in voucherInfos) {

        var voucher = voucherInfos[i];
        var docElement = $("#"+voucher.voucherId);

        if (docElement.attr("value") != "checked") {

            docElement.children(".voucherName").removeClass("enableText");
            docElement.children(".checkIcon").removeClass("enableIcon");
             
            if(!checkAble(null,i,null)){
                //券不可用
                docElement.children(".voucherName").addClass("enableText");
                docElement.children(".checkIcon").addClass("enableIcon");
                docElement.attr("value","enable");
                
            }else{
                //券可用
                docElement.attr("value","able");
            }
        }
    }
}

function refreshCampaignView(){

    if (hasSelectedMember || hasSelectedCampaign) {
        showCampaign(campaignInfos);
    }else {
        showCampaign(campaignInfos);
        for(var index in campaignInfos){
            var campaign = campaignInfos[index];
            var docElement = $("#"+campaign.campaignNo);

            docElement.children(".voucherName").removeClass("enableText");
            docElement.children(".checkIcon").removeClass("enableIcon");

            if (!checkAble(null,null,index)) {
                docElement.children(".voucherName").addClass("enableText");
                docElement.children(".checkIcon").addClass("enableIcon");
                docElement.attr("value","enable"); 
            }else{
                docElement.attr("value","able");
            }
        }     
    }
}


function checkAble(member,voucherIndex,campaignIndex){
    var tempsatisfyOrderAmount = orderAmount;
    var temppayAmount = orderAmount;

    if (hasSelectedMember || member != null) {
        temppayAmount = (temppayAmount*memberInfo.discount).toFixed(2);
        tempsatisfyOrderAmount = temppayAmount;
    }

    if (voucherIndex) {
        var temp = voucherInfos[voucherIndex];
        if ( ("2" == temp.voucherType) && hasCashVoucher && hasReduceVoucher) {
            return false;
            //现金券和满减券叠加使用时，可以使用多张现金券仅限叠加使用一张满减券
        }
    }

    for (var i in voucherInfos) {
        var voucher = voucherInfos[i];
        if ($("#"+voucher.voucherId).attr("value") == "checked" || voucherIndex == i) {
            if ("5" == voucher.voucherType) {
                if (tempsatisfyOrderAmount<=voucher.satisfyOrderAmount) {
                    return false;
                }else{
                    temppayAmount = temppayAmount - voucher.voucherAmount;
                    tempsatisfyOrderAmount = satisfyOrderAmount - voucher.voucherAmount;
                }
            }else if ("4" == voucher.voucherType) {     
                if (tempsatisfyOrderAmount<voucher.satisfyOrderAmount) {
                    return false;
                }else{
                    temppayAmount = (temppayAmount*voucher.discount)/100;
                    if (voucher.satisfyOrderAmount == 0) {
                        tempsatisfyOrderAmount = satisfyOrderAmount - (temppayAmount*(100 -voucher.discount))/100;
                    }else{
                        tempsatisfyOrderAmount = satisfyOrderAmount - voucher.satisfyOrderAmount;    
                    }  
                } 
            }else if ("2" == voucher.voucherType) {
                if (tempsatisfyOrderAmount<voucher.satisfyOrderAmount) {
                    return false;
                }else{
                    temppayAmount = temppayAmount - voucher.voucherAmount;
                    if (voucher.satisfyOrderAmount == 0) {
                        tempsatisfyOrderAmount = tempsatisfyOrderAmount - voucher.voucherAmount;
                    }else{
                        tempsatisfyOrderAmount = tempsatisfyOrderAmount - voucher.satisfyOrderAmount;    
                    }
                }
            }
        }
    }
    

    if (hasSelectedCampaign || campaignIndex!=null) {
        for (var i in campaignInfos) {
            var tempCampaign = campaignInfos[i];
            if ($("#"+tempCampaign.campaignNo).attr("value") == "checked" ) {
                var CampaignTool = tempCampaign.CampaignTool[selectedCampaignToolIndex];
                if (tempsatisfyOrderAmount<CampaignTool.campaignAmount) {
                    return false;
                }
                break;
            }else if (campaignIndex == i) {
                var tempCampaignTools = tempCampaign.CampaignTool;
                for (var i=tempCampaignTools.length-1;i>=0;i--) {
                    var CampaignTool = tempCampaign.CampaignTool[i];
                   if (tempsatisfyOrderAmount>=CampaignTool.campaignAmount) {

                        return true;
                    }
                } 
                return false;
            }
        }
    }
    return true;
}

