/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_scrollview_observer
 * @Date: 2022-08-08 00:20:03
 */
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../custom_scrollview/custom_scrollview_demo/custom_scrollview_demo_page.dart';
import '../custom_scrollview/sliver_appbar_demo/sliver_appbar_demo_page.dart';
import '../gridview/gridview_ctx_demo/gridview_ctx_demo_page.dart';
import '../gridview/gridview_demo/gridview_demo_page.dart';
import '../gridview/horizontal_gridview_demo/horizontal_gridview_demo_page.dart';
import '../gridview/sliver_grid_demo/sliver_grid_demo_page.dart';
import '../listview/horizontal_listview_demo/horizontal_listview_page.dart';
import '../listview/listview_ctx_demo/listview_ctx_demo_page.dart';
import '../listview/listview_demo/listview_demo_page.dart';
import '../listview/listview_dynamic_offset/listview_dynamic_offset_page.dart';
import '../listview/listview_fixed_height_demo/listview_fixed_height_demo_page.dart';
import '../listview/sliver_list_demo/sliver_list_demo_page.dart';
import '../scene/anchor_demo/anchor_page.dart';
import '../scene/chat_demo/page/chat_page.dart';
import '../scene/image_tab_demo/image_tab_page.dart';
import '../scene/video_auto_play_list/video_list_auto_play_page.dart';

typedef PageBuilder = Widget Function();

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rowDataArr = _buildListViewRows(context);
    return Scaffold(
      appBar: AppBar(title: const Text("ScrollView Observer Example")),
      body: ListView.separated(
        itemCount: rowDataArr.length,
        itemBuilder: (context, index) {
          final rowData = rowDataArr[index];
          return ListTile(
            title: Text(rowData.item1),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return rowData.item2();
                  },
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return Container(color: Colors.grey, height: 0.5);
        },
      ),
    );
  }

  List<Tuple2<String, PageBuilder>> _buildListViewRows(
    BuildContext context,
  ) {
    return [
      Tuple2<String, PageBuilder>(
        "ListView",
        () {
          return const ListViewDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "ListView - Context",
        () {
          return const ListViewCtxDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "ListView - Fixed Height",
        () {
          return const ListViewFixedHeightDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "ListView - Horizontal",
        () {
          return const HorizontalListViewPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "ListView - Dynamic Offset",
        () {
          return const ListViewDynamicOffsetPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "SliverListView",
        () {
          return const SliverListViewDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "GridView",
        () {
          return const GridViewDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "GridView - Context",
        () {
          return const GridViewCtxDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "GridView - Horizontal",
        () {
          return const HorizontalGridViewDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "SliverGridView",
        () {
          return const SliverGridViewDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "CustomScrollView",
        () {
          return const CustomScrollViewDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "SliverAppBar",
        () {
          return const SliverAppBarDemoPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "VideoList AutoPlay",
        () {
          return const VideoListAutoPlayPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "AnchorList",
        () {
          return const AnchorListPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "ImageTab",
        () {
          return const ImageTabPage();
        },
      ),
      Tuple2<String, PageBuilder>(
        "Chat",
        () {
          return const ChatPage();
        },
      ),
    ];
  }
}
