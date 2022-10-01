import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../utils/theme.dart';
import '../utils/validator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const secureStorage = FlutterSecureStorage();
  String? theme = await secureStorage.read(key: "theme");
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(theme: int.parse(theme ?? "5")),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        title: 'BMI Calculator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
                suffixIconColor: themeProvider.getColor,
                prefixIconColor: themeProvider.getColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: themeProvider.getColor, width: 2.0),
                ),
                focusColor: themeProvider.getColor),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.white,
                sizeConstraints:
                const BoxConstraints(minWidth: 80, minHeight: 80),
                extendedPadding: const EdgeInsets.all(50),
                foregroundColor: themeProvider.getColor,
                extendedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w300)),

            //F48221
            primaryColor: themeProvider.getColor,
            textTheme: const TextTheme(
                button: TextStyle(
                  color: Color.fromRGBO(254, 79, 5, 1),
                ),
                subtitle1: TextStyle(color: Colors.black38, fontSize: 14),
                headline5:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                bodyText2: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.red),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(color: Colors.black)),
                )),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 20)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      themeProvider.getColor),
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.orange,
            ).copyWith(secondary: Colors.grey.shade600)),
        home: const MyHomePage(title: 'BMI Calculator'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String userName = "";
  String height = "";
  String weight = "";
  bool _onProcess = false;
  bool isNameSet = false;
  bool isHeightSet = false;
  bool isWeightSet = false;
  var message = "hey! Have nice day.";
  String buildMessage(){
    if(isNameSet && !isHeightSet && !isWeightSet){
      setState((){
        message = '$message $userName how you doing\n Please fill bellow form';
      });
    }
    return  "";
  }

  late ThemeProvider themeProvider;
  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    //prepareRequest(context, 1, 0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(widget.title,style: TextStyle(color: ColorProvider().white),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _registerFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //_navItems(),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.2,
                                color: Theme.of(context).primaryColor.withOpacity(0.5),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text(message,
                                    style: TextStyle(color: ColorProvider().white),)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.black),
                                  controller: _userNameController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(style: BorderStyle.solid)),
                                      hintText: "Your Name",
                                      labelStyle: TextStyle(color: Colors.grey)),
                                  onChanged: (value) {
                                    setState(() {
                                      userName = value;
                                    });
                                  },
                                  validator: (value) =>
                                      Sanitizer().isValidField(value!, "Name"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  style: TextStyle(color: Colors.black),
                                  controller: _heightController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(style: BorderStyle.solid)),
                                      hintText: "Your Height in m.",
                                      labelStyle: TextStyle(color: Colors.grey)),
                                  validator: (value) => Sanitizer().isValidHeightWeight(value!, "Height"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  style: TextStyle(color: Colors.black),
                                  controller: _weightController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(style: BorderStyle.solid)),
                                      hintText: "Your Weight in kg.",
                                      labelStyle: TextStyle(color: Colors.grey)),
                                  validator: (value) => Sanitizer().isValidHeightWeight(value!, "Weight"),
                                ),
                              ),
                              _actionButton(),
                            ],
                          ),
                                         ),
                  ),
                  _themeUi(),
                ],
              ),
          )
        ),
      )
    );
  }
  Padding  _actionButton(){
    return Padding(
      padding: const EdgeInsets.all(40),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 40,
        child: Container(
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
            child: ElevatedButton(
              onPressed: _onProcess
                  ? null
                  : () {
                final _form =
                    _registerFormKey.currentState;
                if (_form!.validate()) {
                  setState(() {
                    _onProcess = true;
                  });
                  _form.save();
                  var name = _userNameController.text;
                  var height = _heightController.text;
                  var weight = _weightController.text;
                  _displayResult(name,double.parse(height),double.parse(weight));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text("Calculate",
                      style: TextStyle(color: Colors.white)),
                  const Spacer(),
                  Align(
                    widthFactor: 2,
                    alignment: Alignment.centerRight,
                    child: _onProcess
                        ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Container _themeUi(){
    return Container(
      padding: const EdgeInsets.only(
          left: 10, bottom: 20, top: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: () {
                  themeProvider.changeTheme(0);
                },
                child: Container(
                  //color: ColorProvider().primaryDeepOrange,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: ColorProvider()
                        .primaryDeepOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: () {
                  themeProvider.changeTheme(1);
                },
                child: Container(
                  //color: ColorProvider().primaryDeepBlue,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color:
                    ColorProvider().primaryDeepBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: () {
                  themeProvider.changeTheme(3);
                },
                child: Container(
                  //color: ColorProvider().primaryDeepTeal,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color:
                    ColorProvider().primaryDeepTeal,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  _displayResult(String name, double height, double weight){
    var bmiResult = _bmiResult(height, weight);
    var createMessage = '$name,';
    setState(() {
      _onProcess = false;
      //message = createMessage;
      if (bmiResult< 18.5) {
        message = "$createMessage You are underweight";
      } else if (25 > bmiResult) {
        message = '$createMessage You body is fine';
      } else if (bmiResult< 30) {
        message = '$createMessage You are overweight';
      } else {
        message = '$createMessage You are obese';
      }
    });
  }
   double _bmiResult(double height, double weight){
    return weight / (height * height);
  }
}
