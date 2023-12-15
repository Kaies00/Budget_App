import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../../typedefs.dart';
import 'date_cell.dart';

class HorizentalDatesListView extends StatefulWidget {
  const HorizentalDatesListView({super.key});

  @override
  State<HorizentalDatesListView> createState() =>
      _HorizentalDatesListViewState();
}

class _HorizentalDatesListViewState extends State<HorizentalDatesListView> {
  late ListObserverController observerController;
  final _scrollController = ScrollController();
  DateTime now = DateTime.now();
  DateTime dateElement = DateTime.now();
  bool datesListIsReady = true;
  final yearNbr = 1;
  int _selectedDateIndex = 0;
  int _hitIndex = 0;
  late DateTime lastDayOfMonth;
  late List<DateTime> _listDates;
  Future refreshDatesList() async {
    setState(() => datesListIsReady = false);
    final firstDayOfWeek = now.subtract(Duration(days: 30 * yearNbr ~/ 2));
    final lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
    _listDates = List<DateTime>.generate(
        yearNbr * 30, (index) => firstDayOfWeek.add(Duration(days: index)));

    setState(() => datesListIsReady = true);
    int closestIndex = _listDates.indexWhere((date) {
      return date.difference(dateElement).inSeconds >= 0;
    });

    if (closestIndex == -1) {
      closestIndex = _listDates.length - 1;
    }
    _selectedDateIndex = _listDates.indexOf(dateElement);
    debugPrint('visible -- ${closestIndex}');
    observerController = ListObserverController(controller: _scrollController)
      // ..jumpTo(index: closestIndex);
      ..initialIndexModel = ObserverIndexPositionModel(index: closestIndex);
    ambiguate(WidgetsBinding.instance)?.endOfFrame.then(
      (_) {
        // After layout
        if (mounted) {
          observerController.dispatchOnceObserve();
        }
      },
    );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.animateTo(
    //     closestIndex.toDouble() * 40,
    //     duration:
    //         Duration(milliseconds: 500), // The duration of the scroll animation
    //     curve: Curves.easeInOut, // The easing curve of the scroll animation
    //   );
    //   _scrollController.jumpTo(closestIndex.toDouble());
    // });
  }

  List<DateTime> addTenDates(DateTime referenceDate, bool isOnLeft) {
    if (isOnLeft) {
      final firstDate = referenceDate.subtract(const Duration(days: 10));
      final _listAdditionalDates = List<DateTime>.generate(
          10, (index) => firstDate.add(Duration(days: index)));
      return _listAdditionalDates;
    } else {
      final firstDate = referenceDate.add(const Duration(days: 10));
      final _listAdditionalDates = List<DateTime>.generate(
          10, (index) => firstDate.add(Duration(days: index)));
      return _listAdditionalDates;
    }
  }

  @override
  void initState() {
    super.initState();

    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    refreshDatesList();
  }

  @override
  void dispose() {
    observerController.controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!datesListIsReady) {
      return Center(child: const CircularProgressIndicator());
    } else {
      return Container(
        width: double.infinity,
        height: 70,
        child: ListViewObserver(
          child: _buildLisViewHorizentalDates(),
          autoTriggerObserveTypes: const [
            ObserverAutoTriggerObserveType.scrollEnd,
          ],
          triggerOnObserveType: ObserverTriggerOnObserveType.directly,
          controller: observerController,
          onObserve: (resultModel) {
            debugPrint('visible -- ${resultModel.visible}');
            debugPrint('firstChild.index -- ${resultModel.firstChild?.index}');
            debugPrint('displaying -- ${resultModel.displayingChildIndexList}');

            for (var item in resultModel.displayingChildModelList) {
              debugPrint(
                  'item - ${item.index} - ${item.leadingMarginToViewport} - ${item.trailingMarginToViewport}');
              if (resultModel.firstChild?.index != null &&
                  resultModel.firstChild!.index < 10) {
                debugPrint('___you should add 10 item in left side___');
                int jumpToIndex = resultModel.firstChild!.index;
                setState(() {
                  _listDates = addTenDates(_listDates[0], true) + _listDates;
                  observerController.jumpTo(index: jumpToIndex + 10);
                });
              }
              if (_listDates.length -
                      resultModel.displayingChildIndexList.last <
                  10) {
                debugPrint("___you should add 10 item in rght side___");
                setState(() {
                  _listDates = _listDates + addTenDates(_listDates[0], true);
                });
              }
            }

            setState(() {
              _hitIndex = resultModel.firstChild?.index ?? 0;
            });
          },
        ),
      );
    }
  }

  _buildLisViewHorizentalDates() {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        dateElement = _listDates[index];
        return InkWell(
          onTap: () {
            _selectedDateIndex = index;
          },
          child: DateCell(dateElement: dateElement),
        );
      },
    );
  }
}
