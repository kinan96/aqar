import 'package:aqar/controller/forgetPasswordController.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  String _currentPassword;
  String _newPassword;
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
                  "Do you want to change password ?",
                  size: 25,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 70,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          isPassword: true,
                          onSaved: (v) {
                            setState(() {
                              _currentPassword = v;
                            });
                          },
                          onValidate: passwordValidate,
                          textInputType: TextInputType.text,
                          lable: "Current Password",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          isPassword: true,
                          onSaved: (v) {
                            setState(() {
                              _newPassword = v;
                            });
                          },
                          onValidate: passwordValidate,
                          textInputType: TextInputType.text,
                          lable: "New Password",
                        ),
                      ],
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
                      await userController.updatePassword(
                          context, _currentPassword, _newPassword);
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
