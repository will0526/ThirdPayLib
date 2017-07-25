

$(document).ready(function(){

        // var url = window.location.search;
       
        // var btn1 = document.getElementById("submit");
        // btn1.addEventListener("click", function() {
        //     gotoPay();
        // });

        // $("#submit").click(function  () {
        //     gotoPay();

        // });

        // var gotoPay = function  () {
                
        // }
        
        $('#bookSubmit').click(function(){

            var memberNO = $("#memberNo").val();
            var merchantNO = $("#merchantNO").val();
            var merchantOrderNO = $("#merchantOrderNO").val();
            var goodsName = $("#goodsName").val();            
            var goodsDetail = $("#goodsDetail").val();
            var totalAmount = $("#totalAmount").val();
            var payAmount = $("#payAmount").val();
            var redPocket = $("#redPocket").val();
            var memberPoint = $("#point").val();
            var memo = $("#memo").val();
            
            var openID = "oC6cQxNQ235JweYQAk5f1nloKJPs";

            var data = bookOrder({
                'merchantNO' : merchantNO,
                'openID' : openID,
                'memberNO' : memberNo,
                'merchantOrderNO' : merchantOrderNO,
                'goodsName' : goodsName,
                'goodsDetail' : goodsDetail,
                'totalAmount' : totalAmount,
                'payAmount' : payAmount,
                'redPocket' : redPocket,
                'memberPoint' : memberPoint,
                'memo' : memo
            },function(data){
                alert(JSON.stringify(data));
            });
        });

        $('#querySubmit').click(function(){
            
            var memberNO = $("#memberNo").val();
            var merchantNO = $("#merchantNO").val();
            var ippOrderNO = $("#ippOrderNO").val();
            var data = queryOrder({
                'merchantNO' : merchantNO,
                'memberNO' : memberNO,
                'ippOrderNO' : ippOrderNO
            },function(data){
                alert(JSON.stringify(data));
            });
        });

});

