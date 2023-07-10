import 'package:app/app/controllers/exchange_controller.dart';
import 'package:app/app/models/exchange_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime _date = DateTime.now();
  EventController _eventController = EventController();
  final exchangeController = ExchangeController();
  late Map groupedExchanges = {};

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  refreshData() {
    loadExchanges().then((itens) {
      setState(() {
        groupedExchanges = itens;
      });
    });
  }

  List<CalendarEventData> getEvents() {
    List<CalendarEventData> events = [];

    if (groupedExchanges.isNotEmpty) {
      for (var e in groupedExchanges.entries) {
        events.add(CalendarEventData(
            date: e.value["date"],
            event: e.value["value"].toString(),
            title: NumberFormat.simpleCurrency(locale: "pt-BR").format(e.value["value"]),
            description: "aaaa",
            startTime: DateTime(e.value["date"].year, e.value["date"].month, e.value["date"].day, 0, 0),
            endTime: DateTime(e.value["date"].year, e.value["date"].month, e.value["date"].day, 0, 0),
            color: e.value["value"] < 0 ? Colors.red : Colors.blue));
      }
    }

    return events;
  }

  Future<Map<String, dynamic>> loadExchanges() async {
    return await exchangeController.getGroupedExchangesByMonth(_date.month, _date.year);
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController..addAll(getEvents()),
      child: MaterialApp(
        home: Scaffold(body: MonthView(
          onPageChange: (date, pageIndex) {
            setState(() {
              _date = date;
              refreshData();
            });
          },
        )),
      ),
    );
  }
}

// [
//   CalendarEventData(
//     date: _now,
//     event: "Joe's Birthday",
//     title: "Project meeting",
//     description: "Today is project meeting.",
//     startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
//     endTime: DateTime(_now.year, _now.month, _now.day, 22),
//   )
// ]