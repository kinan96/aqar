import 'package:aqar/controller/confirmController.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  bool changePass;
  Confirm({this.changePass});
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        // color: appDesign.white.withOpacity(0.6),
        // borderRadius: BorderRadius.circular(15.0),
        );
  }
  GlobalKey<ScaffoldState> _scc = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scc,
        appBar: buildCustomAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  "Enter your activation code",
                  size: 25,
                ),
                // SizedBox(
                //   height: 8,
                // ),
                // CustomText(
                //   "سوف يتم إرسال كود التفعيل إلى رقم الجوال الخاص بك",
                //   maxLines: 3,
                //   fontWeight: FontWeight.w600,
                // ),
                SizedBox(
                  height: 70,
                ),
                Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _pinPutController,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      validator: codeValidate,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 30, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
                      if (_pinPutController.text !=
                          userController.userModel.activationCode.toString())
                        _scc.currentState.showSnackBar(
                            SnackBar(content: Text("كود التفعيل غير صحيح")));
                      else
                        await userController.activate(
                            context, _pinPutController.text,
                            changePassword: widget.changePass);
                      // confirmController.navigateToNewPassword(context);
                    },
                    child: Text("Confirm"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () async {
                      _scc.currentState.showSnackBar(SnackBar(
                          content: Text(
                              userController.userModel.activationCode.toString() ?? "")));
// await userController.sendCode(context);
                    },
                    color: appDesign.bg,
                    child: Text("Resend"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
