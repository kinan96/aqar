import 'package:aqar/controller/forgetPasswordController.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String _email;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: buildCustomAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  "ادخل رقم الجوال",
                  size: 25,
                ),
                SizedBox(
                  height: 8,
                ),
                CustomText(
                  "الرجاء إدخال رقم الجوال الخاص بك لنتمكن من إرسال كود التفعيل",
                  maxLines: 3,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: 70,
                ),
                Form(
                    key: _formKey,
                    child: CustomTextFormField(
                      onSaved: (v) {
                        setState(() {
                          _email = v;
                        });
                      },
                      onValidate: emailValidate,
                      textInputType: TextInputType.emailAddress,
                      lable: "Email",
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
                      await userController.sendCode(context, email: _email);
                    },
                    child: Text("Confirm"),
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
