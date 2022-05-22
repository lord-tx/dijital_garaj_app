import 'package:dijital_garaj_app/get_hash_string.dart';
import 'package:dijital_garaj_app/put_request.dart';
import 'package:dijital_garaj_app/put_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dijital Garaj',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dijital Garaj'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool requestLoading = false;
  bool mailLoading = false;
  bool requestLoaded = false;
  bool mailLoaded = false;
  String hiddenEmail = "";
  PutResponse? response;
  String hashString = "";
  String myEmail = "johnpaulmuoneme@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            requestLoaded ?  Container(
              margin: const EdgeInsets.all(10),
              child: Text(hashString),
            ) : Container(),
            requestLoading ? const LinearProgressIndicator() : MaterialButton(
              color: Colors.blue,
              disabledColor: Colors.grey,
              onPressed: requestLoaded ? null : () async {
                setState(() {
                  requestLoading = true;
                });
                /// Get information
                response = await sendPutRequest();
                setState(() {
                  requestLoading = false;
                  if(response?.hash != null){
                    Fluttertoast.showToast(
                        msg: "Hash Retrieved",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    requestLoaded = true;
                    hashString = response?.hash ?? "";
                  }
                });
              },
              child: const Text(
                "Tap to send PUT Request",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(),
            /// If hiddenMail is done decrypting
            mailLoaded ? Container(
              margin: const EdgeInsets.all(10),
              child: Text(hiddenEmail),
            ) : Container(),
            /// While mail is loading show a Circle Progress Bar
            mailLoading ? const LinearProgressIndicator() : MaterialButton(
              disabledColor: Colors.grey,
              color: Colors.blue,
              onPressed: requestLoaded ? () async {
                print("Pressed");
                setState(() {
                  mailLoading = true;
                });
                getHash(hashString, myEmail);
              } : null,
              child: const Text("Convert Hash", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void getHash(String hashString, String email) {
    Map<String, String> myValues = {
      "md5Hash" : hashString,
      "email": email
    };
    compute(getHashString, myValues).then((value){
      setState(() {
        Fluttertoast.showToast(
            msg: "Hash Deciphered",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
        hiddenEmail = value;
        mailLoading = false;
        mailLoaded = true;
        requestLoaded = false;
      });
    });
  }
}

