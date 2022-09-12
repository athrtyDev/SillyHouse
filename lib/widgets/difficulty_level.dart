import 'package:flutter/material.dart';
import 'package:sillyhouseorg/utils/utils.dart';
import 'package:sillyhouseorg/widgets/difficulty_progress.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'package:sillyhouseorg/widgets/weekly_progress_bar.dart';

class DifficultyLevel extends StatelessWidget {
  final String level;
  const DifficultyLevel({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MyText.small("Даалгавар: ", textColor: Styles.textColor70),
            MyText.medium(Utils.getDifficultyName(level), fontWeight: Styles.wBold),
          ],
        ),
        SizedBox(height: 10),
        DifficultyProgress(level: level),
      ],
    );
  }
}
