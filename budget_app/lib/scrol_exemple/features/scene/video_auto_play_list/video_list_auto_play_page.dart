/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_scrollview_observer
 * @Date: 2022-07-03 15:46:45
 */
import 'package:budget_app/scrol_exemple/features/scene/video_auto_play_list/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class VideoListAutoPlayPage extends StatefulWidget {
  const VideoListAutoPlayPage({Key? key}) : super(key: key);

  @override
  State<VideoListAutoPlayPage> createState() => _VideoListAutoPlayPageState();
}

class _VideoListAutoPlayPageState extends State<VideoListAutoPlayPage> {
  BuildContext? _ctx1;

  int _hitIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Auto Play")),
      body: ListViewObserver(
        child: _buildListView(),
        sliverListContexts: () {
          return [if (_ctx1 != null) _ctx1!];
        },
        onObserveAll: (resultMap) {
          final model = resultMap[_ctx1];
          if (model == null) return;

          if (_hitIndex != model.firstChild?.index) {
            _hitIndex = model.firstChild?.index ?? 0;
            setState(() {});
          }
        },
        leadingOffset: 200,
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        _ctx1 = ctx;
        return _buildListItemView(index);
      },
      separatorBuilder: (ctx, index) {
        return _buildSeparatorView();
      },
      itemCount: 50,
    );
  }

  Widget _buildListItemView(int index) {
    return SizedBox(
      height: 300,
      child: _hitIndex == index
          ? const VideoWidget(
              url:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            )
          : Container(
              color: Colors.blue[100],
              child: const Center(child: Text('placeholder')),
            ),
    );
  }

  Container _buildSeparatorView() {
    return Container(
      color: Colors.white,
      height: 8,
    );
  }
}
