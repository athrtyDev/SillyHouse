import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/viewmodels/gallery_model.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/widgets/gallery_post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:sillyhouseorg/ui/widgets/top_post_panel.dart';

class GalleryView extends StatefulWidget {
  GalleryView({Key? key}) : super(key: key);

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  ScrollController? scrollViewController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
    /*scrollViewController.addListener(() {
      if (scrollViewController.position.maxScrollExtent == scrollViewController.offset)
        loadMorePosts();
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    if (scrollViewController != null) scrollViewController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GalleryModel>(
      onModelReady: (model) => model.loadPostsByUser(context),
      builder: (context, model, child) => ListView(
        children: [
          model.state == ViewState.Busy
              ? Container(height: 400, child: Center(child: CircularProgressIndicator()))
              : model.listPosts == null
                  ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350))
                  : Container(
                      padding: EdgeInsets.all(8),
                      color: AppColors.backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopPostPanel(),
                          SizedBox(height: 15),
                          _allPosts(model.listPosts!),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  _allPosts(List<Post> listPosts) {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_a_photo_outlined, color: AppColors.textColor, size: 23),
              SizedBox(width: 8),
              Text('Бүх бүтээлүүд',
                  style: GoogleFonts.kurale(
                    fontSize: 18,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  )),
            ],
          ),
          SizedBox(height: 6),
          GridView.count(
            controller: scrollViewController,
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 0.75,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 6,
            mainAxisSpacing: 8,
            children: listPosts.map((Post post) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(context, '/post_detail', arguments: post);
                    });
                  },
                  child: GalleryPostWidget(post: post));
            }).toList(),
          ),
        ],
      ),
    );
  }

  loadMorePosts() async {
    if (!isLoading) {
      setState(() => isLoading = true);
      print('loooooooooooooooooooooading...');
      /*if (datas.length >= 79) {
        await Future.delayed(Duration(seconds: 3));
        setState(() => isLoading = false);
        await makeAnimation();
        scaffoldKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Get max data!'),
          ),
        );
        return;
      }*/
      /*final newDatas = await fetchDatas(datas.length + 1, datas.length + 21);
      datas.addAll(newDatas);*/
      isLoading = false;
      setState(() {});
    }
  }
}
