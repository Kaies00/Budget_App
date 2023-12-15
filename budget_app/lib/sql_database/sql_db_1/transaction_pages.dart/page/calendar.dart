// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late DateTime _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _resetSelectedDate();
//   }

//   void _resetSelectedDate() {
//     _selectedDate = DateTime.now().add(const Duration(days: 2));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF333A47),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'Calendar Timeline',
//                 style: Theme.of(context)
//                     .textTheme
//                     .headline6!
//                     .copyWith(color: Colors.tealAccent[100]),
//               ),
//             ),
//             CalendarTimeline(
//               showYears: true,
//               initialDate: _selectedDate,
//               firstDate: DateTime.now().subtract(const Duration(days: 365 * 8)),
//               lastDate: DateTime.now().add(const Duration(days: 365 * 8)),
//               onDateSelected: (date) => setState(() => _selectedDate = date),
//               leftMargin: 20,
//               monthColor: Colors.white70,
//               dayColor: Colors.teal[200],
//               dayNameColor: const Color(0xFF333A47),
//               activeDayColor: Colors.white,
//               activeBackgroundDayColor: Colors.redAccent[100],
//               dotsColor: const Color(0xFF333A47),
//               // selectableDayPredicate: (date) => date.day != 23,
//               locale: 'en',
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.only(left: 16),
//               child: TextButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.teal[200]),
//                 ),
//                 child: const Text(
//                   'RESET',
//                   style: TextStyle(color: Color(0xFF333A47)),
//                 ),
//                 onPressed: () => setState(() => _resetSelectedDate()),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: Text(
//                 'Selected date is $_selectedDate',
//                 style: const TextStyle(color: Colors.white),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CalendarTimeline {
// }
