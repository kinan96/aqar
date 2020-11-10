import 'package:aqar/controller/forgetPasswordController.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String _password ;
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
                  "Enter New Password",
                  size: 25,
                ),
                // SizedBox(
                //   height: 8,
                // ),
                // CustomText(
                //   "الرجاء إدخال كلمة مرور جديدة لتتمكن من تسجيل الدخول مرة أخرى",
                //   maxLines: 3,
                //   fontWeight: FontWeight.w600,
                // ),
                SizedBox(
                  height: 70,
                ),
                Form(
                    key: _formKey,
                    child: CustomTextFormField(
                      isPassword: true,
                      onSaved:(v){setState(() {
                        _password=v;
                      });},
                      onValidate: passwordValidate,
                      textInputType: TextInputType.text,
                      lable: "New Password",
                    )),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () async{
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
await userController.forgetPassword(context,_password);
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
