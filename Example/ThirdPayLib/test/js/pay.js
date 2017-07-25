var batchNO,
    merchantNO,
    projectNo,
    time,
    seqNo,
    appId,
    timeStampParam,
    nonceStr,
    packageParam,
    signType,
    transType,
    terminalNo,
    version,
    paySign;



//查询优惠券，线上购物
function queryVoucher(queryVoucherObject,callback){

    merchantNO = queryVoucherObject.merchantNO;
    projectNo = queryVoucherObject.projectNo;
    transType = "1006";
    payType = "0000";
    
    terminalNo = "000011";
    version = "1.0";

    batchNO = getBatchNO();
    time = getOrderTime();
    seqNo = getTimeStamp();

    var paramsStr = JSON.stringify({
        "accountNo":queryVoucherObject.accountNo,
        "accountType":queryVoucherObject.accountType,
        "merchantNo":queryVoucherObject.merchantNO,
        "orderAmount":parseInt(queryVoucherObject.orderAmount),
        "appType":queryVoucherObject.appType,
        "tradeType":queryVoucherObject.tradeType
    });

    var b = new Base64();  
    var str = b.encode(paramsStr);  
    paramsStr = str;
    var paramsSign = getParamSign(paramsStr);
    doPost(paramsStr,paramsSign,function(data){
            callback(data);
    });


}

//查询优惠券和活动，线上买单
function queryVoucherAndCampaign(queryVoucherAndCampaignObject,callback){

    merchantNO = queryVoucherAndCampaignObject.merchantNO;
    projectNo = queryVoucherAndCampaignObject.projectNo;
    transType = "1024";
    payType = "0000";
    
    terminalNo = "000011";
    version = "1.0";

    batchNO = getBatchNO();
    time = getOrderTime();
    seqNo = getTimeStamp();

    var paramsStr = JSON.stringify({
        "accountNo":queryVoucherAndCampaignObject.accountNo,
        "accountType":queryVoucherAndCampaignObject.accountType,
        "merchantNo":queryVoucherAndCampaignObject.merchantNO,
        "orderAmount":queryVoucherAndCampaignObject.orderAmount,
        "appType":queryVoucherAndCampaignObject.appType,
        "tradeType":queryVoucherAndCampaignObject.tradeType,
        "itemNo":queryVoucherAndCampaignObject.itemNo,
        "campaignType":queryVoucherAndCampaignObject.campaignType
        
    });

    var b = new Base64();  
    var str = b.encode(paramsStr);  
    paramsStr = str;
    var paramsSign = getParamSign(paramsStr);
    doPost(paramsStr,paramsSign,function(data){
            callback(data);
    });


}
//查询会员活动，线上买单
function queryMemberCampaign(queryMemberCampaignObject,callback){

    merchantNO = queryMemberCampaignObject.merchantNO;
    projectNo = queryMemberCampaignObject.projectNo;
    transType = "1025";
    payType = "0000";
    var accountLevel = queryMemberCampaignObject.accountLevel;
    terminalNo = "000011";
    version = "1.0";

    batchNO = getBatchNO();
    time = getOrderTime();
    seqNo = getTimeStamp();

    var paramsStr = JSON.stringify({
        "accountNo":queryMemberCampaignObject.accountNo,
        "accountType":queryMemberCampaignObject.accountType,
        "accountLevel":queryMemberCampaignObject.accountLevel
    });

    var b = new Base64();  
    var str = b.encode(paramsStr);  
    paramsStr = str;
    var paramsSign = getParamSign(paramsStr);
    doPost(paramsStr,paramsSign,function(data){
            callback(data);
    });


}


function bookOrder(payrequestObject, callback) {

    var message = veryfyBookOrderParams(payrequestObject);
    if (message !== 'success') {
        var data = {'code': '0002','data':'','message':message};
        callback(data);
        return ;
    }
    merchantNO = payrequestObject.merchantNO;
    transType = "0020";
    payType = "0002";
    
    terminalNo = "000011";
    version = "1.0";
    batchNO = getBatchNO();
    time = getOrderTime();
    seqNo = getTimeStamp();

    var paramsStr = getpayParamStr(payrequestObject);
    var paramsSign = getParamSign(paramsStr);
    
    $.ajax({
        type: "POST",
        url: "http://ipp.pnrtec.com/ipp-front/pay/onlineGateway.json",
        contentType:"multipart/form-data",
        dataType: "json",
        data:JSON.stringify({
            "batchNo":batchNO,
            "merchantNo": merchantNO,
            "projectNo": projectNo,
            "params":paramsStr,
            "payType":payType,
            "seqNo":seqNo,
            "terminalNo":terminalNo,
            "time":time,
            "transType":transType,
            "version":version,
            "sign": paramsSign
    }),
        success: function(data){
            
            var jsonText = JSON.stringify(data);
            var code = data.code;
            if (code == '0000') {
                alert("下单成功");
                var transMsg = data.data.transMsg;
                pay(transMsg,callback);
                
            }else{
                alert("下单失败");
                alert(jsonText);
            }
            
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert("下单失败");
            alert(XMLHttpRequest.status);
            alert(XMLHttpRequest.readyState);
            alert(textStatus);
            alert(errorThrown);
        }

    });
}


function doPost(paramsStr,paramsSign,callback){


    $.ajax({
        type: "POST",
        url: "https://ipp.pnrtec.com/front/gateway/sdk/interface.json",
        contentType:"multipart/form-data",
        dataType: "json",
        data:JSON.stringify({
            "batchNo":batchNO,
            "projectNo": projectNo,
            "merchantNo": merchantNO,
            "params":paramsStr,
            "payType":payType,
            "seqNo":seqNo,
            "terminalNo":terminalNo,
            "time":time,
            "transType":transType,
            "version":version,  
            "sign": paramsSign
    }),
        success: function(data){
            
            var jsonText = JSON.stringify(data);
            var code = data.code;
            callback(data);
            
            
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert("网络异常");
        }

    });

}



function veryfyBookOrderParams(payrequestObject){

    var merchantNO = payrequestObject.merchantNO;
    if (veryfyParamNull(merchantNO)) { 
         return '商户号不能为空';
    }

    var openID = payrequestObject.openID;
    if (veryfyParamNull(openID)) {
        return 'openID不能为空';
    }

    var merchantOrderNO = payrequestObject.merchantOrderNO;
    if (veryfyParamNull(merchantOrderNO)) {
        return '商户订单号不能为空';
    }
    var goodsName = payrequestObject.goodsName;
    if (veryfyParamNull(goodsName)) { 
         return '商品名称不能为空';
    }
    var totalAmount = payrequestObject.totalAmount;
    if (veryfyParamNull(totalAmount)) { 
         return '交易金额不能为空';
    }
    var payAmount = payrequestObject.payAmount;
    if (veryfyParamNull(payAmount)) { 
         return '支付金额不能为空';
    }
    var redPocket = payrequestObject.redPocket;
    if (veryfyParamNull(redPocket)) { 
         return '红包金额不能为空';
    }
    var memberPoint = payrequestObject.memberPoint;
    if (veryfyParamNull(memberPoint)) { 
         return '积分不能为空';
    }

    return 'success'
}

function veryfyParamNull(paramsStr){
    if (paramsStr == null || paramsStr == undefined || paramsStr == '' || paramsStr.replace(/(^s*)|(s*$)/g, "").length ==0) { 
        return true;
    }else{
        return false;
    }
}


function pay(transMsg,callback){

    // var jsonStr = '{"appId":"wx19783cdd5801fa65","nonceStr":"201610311759121657292970","signType":"MD5","timeStamp":"1477907952","package":"prepay_id=wx20161031175912704d0553900379879792","paySign":"2C5E199ACF0080E28F91F3583CAF7664"}';
    // var jsonStr = "{\"appId\":\"wx19783cdd5801fa65\",\"nonceStr\":\"201610200936571150266599\",\"signType\":\"MD5\",\"timeStamp\":\"1476927417\",\"package\":\"prepay_id=wx20161020093657f0b6ab61b60205500054\",\"paySign\":\"1FD00CA050296428EC605B60241C525A\"}";
    
    var jsonObj = JSON.parse(transMsg);
    
    appId = jsonObj.appId;
    timeStampParam = jsonObj.timeStamp;
    nonceStr = jsonObj.nonceStr;
    
    packageParam = jsonObj.package;
    signType = jsonObj.signType;
    paySign = jsonObj.paySign;

    alert('appId:'+appId+'timeStampParam:'+timeStampParam+'nonceStr:'+nonceStr+'packageParam:'+packageParam+'signType:'+signType+'paySign:'+paySign);

    if (typeof WeixinJSBridge == "undefined"){
        if( document.addEventListener ){
         document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
        }else if (document.attachEvent){
         document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
         document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
        }
    }else{
        onBridgeReady(callback);
    }

}

function onBridgeReady(callback){
    WeixinJSBridge.invoke(
        'getBrandWCPayRequest',
        {
            "appId" : appId,     //公众号名称，由商户传入     
            "timeStamp" : timeStampParam,         //时间戳，自1970年以来的秒数     
            "nonceStr" : nonceStr, //随机串     
            "package" : packageParam,     
            "signType": signType,         //微信签名方式：     
            "paySign" : paySign //微信签名 
        },
        function(res){
            alert(res.err_msg);
            if(res.err_msg == "get_brand_wcpay_request：ok" ) {
                if (typeof callback === "function"){
                    callback(data); 
                }
                
            }else if (res.err_msg == "get_brand_wcpay_request：cancel") {
                if (typeof callback === "function"){
                    callback(data); 
                }
            

            }else if (res.err_msg == "get_brand_wcpay_request：fail") {
                callback(data); 

            } 
        }
    ); 
}


function getParamSign(paramsStr){
    var paramsSign = 
    "batchNo="+batchNO
    +"&merchantNo="+merchantNO
    +"&params="+paramsStr
    +"&payType="+payType
    +"&projectNo="+projectNo
    +"&seqNo="+seqNo
    +"&terminalNo="+terminalNo
    +"&time="+time
    +"&transType="+transType
    +"&version="+version;
    var hash = hex_md5(paramsSign+"fTWFH3QRH7gSs3DE");

    return hash.toUpperCase();
}
function getqueryParamStr(queryrequestObject){
    var paramsStr = JSON.stringify({
        "ippOrderNo":queryrequestObject.ippOrderNO
        
    });

    alert(paramsStr);
    var b = new Base64();  
    var str = b.encode(paramsStr);  
    return str;
}
function getpayParamStr(payrequestObject){
    var paramsStr = JSON.stringify({
        "accountNo":payrequestObject.memberNo,
        "attach":payrequestObject.memo,
        "backURL":"http\\:www.baidu.com",
        "ip":"169.254.91.171",
        "memberPoints":payrequestObject.memberPoint,
        "openId":payrequestObject.openID,
        "orderAmount":payrequestObject.totalAmount,
        "orderDescription":payrequestObject.goodsDetail,
        "orderNo":payrequestObject.merchantOrderNO,
        "orderSubject":payrequestObject.goodsName,
        "goodsInfo":' ',
        "redPocket":payrequestObject.redPocket,
        "sdkVer":"1.1",
        "currency":"CNY",
        "tradeAmount":payrequestObject.payAmount,
        "tradeType":"online"
    });

    alert(paramsStr);
    var b = new Base64();  
    var str = b.encode(paramsStr);  
    return str;
}

function getBatchNO(){
    var date = new Date();
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
      month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
      strDate = "0" + strDate;
    }
    var batchStr = date.getYear()+""+month+""+strDate;
    batchStr = batchStr.substring(1,batchStr.length);
    return batchStr;
  

}

function getOrderTime(){
    var date = new Date();
    // var seperator1 = "";
    // var seperator2 = "";
    // var month = date.getMonth() + 1;
    // var strDate = date.getDate();
    // if (month >= 1 && month <= 9) {
    //     month = "0" + month;
    // }
    // if (strDate >= 0 && strDate <= 9) {
    //     strDate = "0" + strDate;
    // }
    // var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
    // + "" + date.getHours() + seperator2 + date.getMinutes()
    // + seperator2 + date.getSeconds();
    return new Date().getTime(); 
}

function getTimeStamp(){
    var date = new Date();
    return new Date().getTime();

}



/**
*
*  Base64 encode / decode
*
*  @author haitao.tu
*  @date   2010-04-26
*  @email  tuhaitao@foxmail.com
*
*/
 
function Base64() {
 
    // private property
    _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
 
    // public method for encoding
    this.encode = function (input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;
        input = _utf8_encode(input);
        while (i < input.length) {
            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);
            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;
            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }
            output = output +
            _keyStr.charAt(enc1) + _keyStr.charAt(enc2) +
            _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
        }
        return output;
    }
 
    // public method for decoding
    this.decode = function (input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;
        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
        while (i < input.length) {
            enc1 = _keyStr.indexOf(input.charAt(i++));
            enc2 = _keyStr.indexOf(input.charAt(i++));
            enc3 = _keyStr.indexOf(input.charAt(i++));
            enc4 = _keyStr.indexOf(input.charAt(i++));
            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;
            output = output + String.fromCharCode(chr1);
            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }
        }
        output = _utf8_decode(output);
        return output;
    }
 
    // private method for UTF-8 encoding
    _utf8_encode = function (string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
 
        }
        return utftext;
    }
 
    // private method for UTF-8 decoding
    _utf8_decode = function (utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;
        while ( i < utftext.length ) {
            c = utftext.charCodeAt(i);
            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i+1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i+1);
                c3 = utftext.charCodeAt(i+2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }
        }
        return string;
    }
}



/*
 * A JavaScript implementation of the RSA Data Security, Inc. MD5 Message
 * Digest Algorithm, as defined in RFC 1321.
 * Version 2.1 Copyright (C) Paul Johnston 1999 - 2002.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for more info.
 */

/*
 * Configurable variables. You may need to tweak these to be compatible with
 * the server-side, but the defaults work in most cases.
 */
var hexcase = 0;  /* hex output format. 0 - lowercase; 1 - uppercase        */
var b64pad  = ""; /* base-64 pad character. "=" for strict RFC compliance   */
var chrsz   = 8;  /* bits per input character. 8 - ASCII; 16 - Unicode      */

/*
 * These are the functions you'll usually want to call
 * They take string arguments and return either hex or base-64 encoded strings
 */
function hex_md5(s){ return binl2hex(core_md5(str2binl(s), s.length * chrsz));}
function b64_md5(s){ return binl2b64(core_md5(str2binl(s), s.length * chrsz));}
function str_md5(s){ return binl2str(core_md5(str2binl(s), s.length * chrsz));}
function hex_hmac_md5(key, data) { return binl2hex(core_hmac_md5(key, data)); }
function b64_hmac_md5(key, data) { return binl2b64(core_hmac_md5(key, data)); }
function str_hmac_md5(key, data) { return binl2str(core_hmac_md5(key, data)); }

/*
 * Perform a simple self-test to see if the VM is working
 */
function md5_vm_test()
{
  return hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72";
}

/*
 * Calculate the MD5 of an array of little-endian words, and a bit length
 */
function core_md5(x, len)
{
  /* append padding */
  x[len >> 5] |= 0x80 << ((len) % 32);
  x[(((len + 64) >>> 9) << 4) + 14] = len;

  var a =  1732584193;
  var b = -271733879;
  var c = -1732584194;
  var d =  271733878;

  for(var i = 0; i < x.length; i += 16)
  {
    var olda = a;
    var oldb = b;
    var oldc = c;
    var oldd = d;

    a = md5_ff(a, b, c, d, x[i+ 0], 7 , -680876936);
    d = md5_ff(d, a, b, c, x[i+ 1], 12, -389564586);
    c = md5_ff(c, d, a, b, x[i+ 2], 17,  606105819);
    b = md5_ff(b, c, d, a, x[i+ 3], 22, -1044525330);
    a = md5_ff(a, b, c, d, x[i+ 4], 7 , -176418897);
    d = md5_ff(d, a, b, c, x[i+ 5], 12,  1200080426);
    c = md5_ff(c, d, a, b, x[i+ 6], 17, -1473231341);
    b = md5_ff(b, c, d, a, x[i+ 7], 22, -45705983);
    a = md5_ff(a, b, c, d, x[i+ 8], 7 ,  1770035416);
    d = md5_ff(d, a, b, c, x[i+ 9], 12, -1958414417);
    c = md5_ff(c, d, a, b, x[i+10], 17, -42063);
    b = md5_ff(b, c, d, a, x[i+11], 22, -1990404162);
    a = md5_ff(a, b, c, d, x[i+12], 7 ,  1804603682);
    d = md5_ff(d, a, b, c, x[i+13], 12, -40341101);
    c = md5_ff(c, d, a, b, x[i+14], 17, -1502002290);
    b = md5_ff(b, c, d, a, x[i+15], 22,  1236535329);

    a = md5_gg(a, b, c, d, x[i+ 1], 5 , -165796510);
    d = md5_gg(d, a, b, c, x[i+ 6], 9 , -1069501632);
    c = md5_gg(c, d, a, b, x[i+11], 14,  643717713);
    b = md5_gg(b, c, d, a, x[i+ 0], 20, -373897302);
    a = md5_gg(a, b, c, d, x[i+ 5], 5 , -701558691);
    d = md5_gg(d, a, b, c, x[i+10], 9 ,  38016083);
    c = md5_gg(c, d, a, b, x[i+15], 14, -660478335);
    b = md5_gg(b, c, d, a, x[i+ 4], 20, -405537848);
    a = md5_gg(a, b, c, d, x[i+ 9], 5 ,  568446438);
    d = md5_gg(d, a, b, c, x[i+14], 9 , -1019803690);
    c = md5_gg(c, d, a, b, x[i+ 3], 14, -187363961);
    b = md5_gg(b, c, d, a, x[i+ 8], 20,  1163531501);
    a = md5_gg(a, b, c, d, x[i+13], 5 , -1444681467);
    d = md5_gg(d, a, b, c, x[i+ 2], 9 , -51403784);
    c = md5_gg(c, d, a, b, x[i+ 7], 14,  1735328473);
    b = md5_gg(b, c, d, a, x[i+12], 20, -1926607734);

    a = md5_hh(a, b, c, d, x[i+ 5], 4 , -378558);
    d = md5_hh(d, a, b, c, x[i+ 8], 11, -2022574463);
    c = md5_hh(c, d, a, b, x[i+11], 16,  1839030562);
    b = md5_hh(b, c, d, a, x[i+14], 23, -35309556);
    a = md5_hh(a, b, c, d, x[i+ 1], 4 , -1530992060);
    d = md5_hh(d, a, b, c, x[i+ 4], 11,  1272893353);
    c = md5_hh(c, d, a, b, x[i+ 7], 16, -155497632);
    b = md5_hh(b, c, d, a, x[i+10], 23, -1094730640);
    a = md5_hh(a, b, c, d, x[i+13], 4 ,  681279174);
    d = md5_hh(d, a, b, c, x[i+ 0], 11, -358537222);
    c = md5_hh(c, d, a, b, x[i+ 3], 16, -722521979);
    b = md5_hh(b, c, d, a, x[i+ 6], 23,  76029189);
    a = md5_hh(a, b, c, d, x[i+ 9], 4 , -640364487);
    d = md5_hh(d, a, b, c, x[i+12], 11, -421815835);
    c = md5_hh(c, d, a, b, x[i+15], 16,  530742520);
    b = md5_hh(b, c, d, a, x[i+ 2], 23, -995338651);

    a = md5_ii(a, b, c, d, x[i+ 0], 6 , -198630844);
    d = md5_ii(d, a, b, c, x[i+ 7], 10,  1126891415);
    c = md5_ii(c, d, a, b, x[i+14], 15, -1416354905);
    b = md5_ii(b, c, d, a, x[i+ 5], 21, -57434055);
    a = md5_ii(a, b, c, d, x[i+12], 6 ,  1700485571);
    d = md5_ii(d, a, b, c, x[i+ 3], 10, -1894986606);
    c = md5_ii(c, d, a, b, x[i+10], 15, -1051523);
    b = md5_ii(b, c, d, a, x[i+ 1], 21, -2054922799);
    a = md5_ii(a, b, c, d, x[i+ 8], 6 ,  1873313359);
    d = md5_ii(d, a, b, c, x[i+15], 10, -30611744);
    c = md5_ii(c, d, a, b, x[i+ 6], 15, -1560198380);
    b = md5_ii(b, c, d, a, x[i+13], 21,  1309151649);
    a = md5_ii(a, b, c, d, x[i+ 4], 6 , -145523070);
    d = md5_ii(d, a, b, c, x[i+11], 10, -1120210379);
    c = md5_ii(c, d, a, b, x[i+ 2], 15,  718787259);
    b = md5_ii(b, c, d, a, x[i+ 9], 21, -343485551);

    a = safe_add(a, olda);
    b = safe_add(b, oldb);
    c = safe_add(c, oldc);
    d = safe_add(d, oldd);
  }
  return Array(a, b, c, d);

}

/*
 * These functions implement the four basic operations the algorithm uses.
 */
function md5_cmn(q, a, b, x, s, t)
{
  return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s),b);
}
function md5_ff(a, b, c, d, x, s, t)
{
  return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t);
}
function md5_gg(a, b, c, d, x, s, t)
{
  return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t);
}
function md5_hh(a, b, c, d, x, s, t)
{
  return md5_cmn(b ^ c ^ d, a, b, x, s, t);
}
function md5_ii(a, b, c, d, x, s, t)
{
  return md5_cmn(c ^ (b | (~d)), a, b, x, s, t);
}

/*
 * Calculate the HMAC-MD5, of a key and some data
 */
function core_hmac_md5(key, data)
{
  var bkey = str2binl(key);
  if(bkey.length > 16) bkey = core_md5(bkey, key.length * chrsz);

  var ipad = Array(16), opad = Array(16);
  for(var i = 0; i < 16; i++)
  {
    ipad[i] = bkey[i] ^ 0x36363636;
    opad[i] = bkey[i] ^ 0x5C5C5C5C;
  }

  var hash = core_md5(ipad.concat(str2binl(data)), 512 + data.length * chrsz);
  return core_md5(opad.concat(hash), 512 + 128);
}

/*
 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
 * to work around bugs in some JS interpreters.
 */
function safe_add(x, y)
{
  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
  return (msw << 16) | (lsw & 0xFFFF);
}

/*
 * Bitwise rotate a 32-bit number to the left.
 */
function bit_rol(num, cnt)
{
  return (num << cnt) | (num >>> (32 - cnt));
}

/*
 * Convert a string to an array of little-endian words
 * If chrsz is ASCII, characters >255 have their hi-byte silently ignored.
 */
function str2binl(str)
{
  var bin = Array();
  var mask = (1 << chrsz) - 1;
  for(var i = 0; i < str.length * chrsz; i += chrsz)
    bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (i%32);
  return bin;
}

/*
 * Convert an array of little-endian words to a string
 */
function binl2str(bin)
{
  var str = "";
  var mask = (1 << chrsz) - 1;
  for(var i = 0; i < bin.length * 32; i += chrsz)
    str += String.fromCharCode((bin[i>>5] >>> (i % 32)) & mask);
  return str;
}

/*
 * Convert an array of little-endian words to a hex string.
 */
function binl2hex(binarray)
{
  var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
  var str = "";
  for(var i = 0; i < binarray.length * 4; i++)
  {
    str += hex_tab.charAt((binarray[i>>2] >> ((i%4)*8+4)) & 0xF) +
           hex_tab.charAt((binarray[i>>2] >> ((i%4)*8  )) & 0xF);
  }
  return str;
}

/*
 * Convert an array of little-endian words to a base-64 string
 */
function binl2b64(binarray)
{
  var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  var str = "";
  for(var i = 0; i < binarray.length * 4; i += 3)
  {
    var triplet = (((binarray[i   >> 2] >> 8 * ( i   %4)) & 0xFF) << 16)
                | (((binarray[i+1 >> 2] >> 8 * ((i+1)%4)) & 0xFF) << 8 )
                |  ((binarray[i+2 >> 2] >> 8 * ((i+2)%4)) & 0xFF);
    for(var j = 0; j < 4; j++)
    {
      if(i * 8 + j * 6 > binarray.length * 32) str += b64pad;
      else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
    }
  }
  return str;
}

