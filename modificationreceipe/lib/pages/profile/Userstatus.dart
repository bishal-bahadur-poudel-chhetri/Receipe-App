import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logins/config/color_code.dart';

import '../../blocs/Profile/Profile_bloc.dart';
import '../../models/receipeDetail.dart';

class EmailVerificationSection extends StatelessWidget {
  final bool userstatus;
  final List<User> checklists;
  final ProfileBloc profileBloc;

  final VoidCallback onVerify;

  EmailVerificationSection({
    required this.userstatus,
    required this.checklists,
    required this.onVerify,
    required this.profileBloc,
  });

  @override
  Widget build(BuildContext context) {
    if (userstatus) {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 2,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.email_rounded,
                  size: 24,
                  color: Color(0xff000080),
                ),
                SizedBox(width: 10),

                Text(
                  '${checklists[0].email.toString()}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

    } else {

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.email_rounded,
                  size: 24,
                  color: Color(0xff000080),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      '${checklists[0].email.toString()}',
                      style: FontStyles.midHeader,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: ElevatedButton(
              onPressed: onVerify,
              child: Text('Verify Email',style: FontStyles.button_color_text,),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff000080)),
              ),
            ),
          ),
        ],
      );


    }
  }
}
