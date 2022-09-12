import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/widgets/button.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen({Key? key}) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffedeff4),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("lib/assets/update.gif", height: 300),
              Text('Silly House', style: GoogleFonts.kurale(fontSize: 30, color: Styles.baseColor1, fontWeight: FontWeight.bold)),
              Text('апп-аа шинэчлээрэй!',
                  style: GoogleFonts.kurale(fontSize: 30, color: Styles.baseColor1, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              RichText(
                text: new TextSpan(
                  style: GoogleFonts.kurale(fontSize: 18, color: Colors.grey),
                  children: <TextSpan>[
                    new TextSpan(text: 'Заавар: '),
                    new TextSpan(text: 'Шинэчлэх ', style: new TextStyle(fontWeight: FontWeight.bold, color: Styles.baseColor1)),
                    new TextSpan(text: 'товчийг дарж, дараа нь '),
                    new TextSpan(text: 'Update ', style: new TextStyle(fontWeight: FontWeight.bold, color: Styles.baseColor1)),
                    new TextSpan(text: 'дарна.'),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Button(
                text: 'Шинэчлэх',
                onTap: () {
                  //OpenAppstore.launch(androidAppId: "com.education.sillyhouse", iOSAppId: "284882215");
                  // TODO open stores
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
