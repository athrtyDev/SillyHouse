import 'package:flutter/material.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'package:sillyhouseorg/widgets/weekly_progress_bar.dart';

class DifficultyProgress extends StatelessWidget {
  final String level;
  const DifficultyProgress({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return level == "easy"
        ? WeeklyProgressBar(
            total: 5,
            done: 1,
            width: MediaQuery.of(context).size.width * 0.5,
            height: 2,
            activeColor: Styles.greenColor,
            inactiveColor: Styles.backgroundColor,
          )
        : level == "medium"
            ? WeeklyProgressBar(
                total: 2,
                done: 1,
                width: MediaQuery.of(context).size.width * 0.5,
                height: 2,
                activeColor: Styles.baseColor1,
                inactiveColor: Styles.backgroundColor,
              )
            : level == "hard"
                ? WeeklyProgressBar(
                    total: 1,
                    done: 1,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 2,
                    activeColor: Styles.baseColor2,
                    inactiveColor: Styles.backgroundColor,
                  )
                : SizedBox();
  }
}
