import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPage extends StatefulWidget {
  const RazorPayPage({super.key});

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount)async{
    amount = amount * 100;
    var options = {
      'key' : 'rzp_test_T58VEeN8QEFog2',//Testing api
      'amount' : amount,
      'name' : "Donation for Future's",
      'prefill' : {'contact' : '9943372040', 'email' : 'test@gmail.com'},
      'external' : {
        'wallets' : ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : ${e}'); 
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(msg: "Payment Succesful "+response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }
  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: "Payment Fail "+response.message!, toastLength: Toast.LENGTH_SHORT);
  }
  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: "External Wallet "+response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet); 
  }
  
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
     // backgroundColor: Colors.grey[800],
      body: Container(
        height: h,
        width: w,
          padding: EdgeInsets.only(top: 65, left: 15, right: 15),
          decoration: BoxDecoration(
            image: DecorationImage(
             // colorFilter: ColorFilter.mode(const Color.fromARGB(255, 0, 0, 0), BlendMode.color),
                image: AssetImage("assets/bg_2.jpg"),
                fit: BoxFit.cover),),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100,),
              Text("Welcome to Razorpay Payment Gateway Integration",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,),
              SizedBox(height: 200,),
              Padding(padding: EdgeInsets.all(8.0),
              child: Container(
                color: Colors.black45,
                child: TextFormField(
                  cursorColor: const Color.fromARGB(255, 255, 255, 255),
                  autofocus: true,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),),
                    decoration: InputDecoration(
                      labelText: 'Enter Amount to be paid',
                      labelStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        )
                      ),
                      errorStyle:   TextStyle(color: Colors.redAccent, fontSize: 15),
                      
                        
                    ),
                    controller: amtController,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Amount to be paid';
                      }
                      return null;
                    },
                  ),
              ),
        
              ),
        
              SizedBox(height: 130,),
              ElevatedButton(onPressed: (){
                if (amtController.text.toString().isNotEmpty) {
                  setState(() {
                    int amount = int.parse(amtController.text.toString());
                    openCheckout(amount);
                  });
                }
              }, child: Padding(padding: EdgeInsets.all(8.0),
              child: Text('Make a Payment',style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),),),
              
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),)
            ],
          ),
        ),
      ),
    );
    
  }
}