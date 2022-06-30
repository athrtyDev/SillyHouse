import 'package:flutter/material.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:sillyhouseorg/core/classes/story_type.dart';
import 'package:sillyhouseorg/ui/widgets/on_image_text.dart';

class MyStoryView extends StatefulWidget {
  final List<StoryType> listStoryType;
  final int startingIndex;

  const MyStoryView({required this.listStoryType, this.startingIndex = 0});

  @override
  State<MyStoryView> createState() => _MyStoryViewState();
}

class _MyStoryViewState extends State<MyStoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Story(
          onFlashForward: Navigator.of(context).pop,
          onFlashBack: Navigator.of(context).pop,
          momentCount: widget.listStoryType.length,
          momentDurationGetter: (index) => const Duration(seconds: 5),
          momentBuilder: (context, index) => Stack(
            fit: StackFit.expand,
            children: [
              widget.listStoryType[index].media!,
              _topShadow(),
              Positioned(
                left: 15,
                top: 50,
                child: OnImageText(text: widget.listStoryType[index].title, textSize: 30),
              ),
            ],
          ),
          startAt: widget.startingIndex,
          progressSegmentBuilder: (context, index, progress, gap) => _progressSegment(context, index, progress, gap),
        ),
      ),
    );
  }

  Widget _topShadow() {
    return Positioned(
      top: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0),
                Colors.black.withOpacity(0.8),
              ],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(0.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
    );
  }

  Widget _progressSegment(BuildContext context, int index, double progress, double gap) {
    return Container(
      height: 4,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: gap / 2, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}
