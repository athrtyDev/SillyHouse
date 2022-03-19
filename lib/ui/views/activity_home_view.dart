import 'package:cached_network_image/cached_network_image.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/viewmodels/activity_home_model.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/ui/widgets/activity_tile.dart';

class ActivityHomeView extends StatefulWidget {
  final List<ActivityType> listType;
  ActivityType selectedType;

  ActivityHomeView({@required this.listType, this.selectedType});

  @override
  _ActivityHomeViewState createState() => _ActivityHomeViewState();
}

class _ActivityHomeViewState extends State<ActivityHomeView> {
  ScrollController scrollViewController;
  List<Widget> listTab;
  String selectedTab;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
    selectedTab = widget.listType[0].type;
    if (widget.selectedType == null) widget.selectedType = widget.listType[0];

    for (int i = 0; i < widget.listType.length; i++)
      if (widget.listType[i].id == widget.selectedType.id) {
        selectedTab = widget.listType[i].type;
        break;
      }
  }

  @override
  void dispose() {
    super.dispose();
    scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ActivityHomeModel>(
      onModelReady: (model) => model.getActivityList(widget.selectedType.type),
      builder: (context, model, child) => WillPopScope(
          onWillPop: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false);
            return new Future.value(true);
          },
          child: SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              appBar: AppBar(
                backgroundColor: AppColors.whiteColor,
                leading: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.mainTextColor),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var type in widget.listType)
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedTab = type.type;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                margin: EdgeInsets.only(right: 8, bottom: 0),
                                decoration: BoxDecoration(
                                  color: selectedTab == type.type ? Colors.grey[100] : Colors.transparent,
                                  border: selectedTab == type.type
                                      ? Border(bottom: BorderSide(color: AppColors.baseColor, width: 2))
                                      : null,
                                ),
                                child: Column(
                                  children: [
                                    Opacity(
                                      opacity: selectedTab == type.type ? 1 : 0.7,
                                      child: CachedNetworkImage(
                                        height: 25,
                                        imageUrl: type.image,
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(type.name,
                                        style: GoogleFonts.kurale(
                                          fontSize: 13,
                                          color: selectedTab == type.type ? AppColors.mainTextColor : Colors.black54,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              body: model.state == ViewState.Busy
                  ? Container(child: Center(child: CircularProgressIndicator()))
                  : model.mapActivity[selectedTab] == null
                      ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 450))
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Column(
                            children: [
                              GridView.count(
                                controller: scrollViewController,
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                children: model.mapActivity[selectedTab].map((Activity activity) {
                                  return ActivityTile(
                                    activity: activity,
                                    color: AppColors.whiteColor,
                                    onTap: () {
                                      Navigator.pushNamed(context, '/activity_instruction', arguments: activity);
                                    },
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
            ),
          )),
    );
  }
}
