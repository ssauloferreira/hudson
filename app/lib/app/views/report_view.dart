import 'package:hudson/app/controllers/exchange_controller.dart';
import 'package:hudson/app/models/exchange_model.dart';
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

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // final TabController _tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  pinned: true,
                  floating: true,
                  bottom: const TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(child: Text('Calendário de gastos', style: TextStyle(color: Colors.black))),
                      Tab(child: Text('Gráfico mensal', style: TextStyle(color: Colors.black))),
                    ],
                  ),
                ),
              ];
            },
            body: const TabBarView(
              children: <Widget>[
                CalendarPage(),
                Icon(Icons.directions_transit, size: 350),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _date = DateTime.now();
  final EventController _eventController = EventController();
  final exchangeController = ExchangeController();
  late Map groupedExchanges = {};

  final List weekLetter = ["D", "S", "T", "Q", "Q", "S", "S"];

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
        if (e.value["expense"] > 0) {
          events.add(CalendarEventData(
              date: e.value["date"],
              event: e.value["expense"].toString(),
              title: NumberFormat.simpleCurrency(locale: "pt-BR").format(e.value["expense"]),
              description: "aaaa",
              startTime: DateTime(e.value["date"].year, e.value["date"].month, e.value["date"].day, 0, 0),
              endTime: DateTime(e.value["date"].year, e.value["date"].month, e.value["date"].day, 0, 0),
              color: Colors.red));
        }

        if (e.value["income"] > 0) {
          events.add(CalendarEventData(
              date: e.value["date"],
              event: e.value["income"].toString(),
              title: NumberFormat.simpleCurrency(locale: "pt-BR").format(e.value["income"]),
              description: "aaaa",
              startTime: DateTime(e.value["date"].year, e.value["date"].month, e.value["date"].day, 0, 0),
              endTime: DateTime(e.value["date"].year, e.value["date"].month, e.value["date"].day, 0, 0),
              color: Colors.green));
        }
      }
    }

    return events;
  }

  Future<Map<String, dynamic>> loadExchanges() async {
    return await exchangeController.getGroupedExchangesByMonth(_date.month, _date.year);
  }

  String getWeekDay(int i) {
    return weekLetter[i];
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController..addAll(getEvents()),
      child: MaterialApp(
        home: Scaffold(
          body: MonthView(
            headerStyle: HeaderStyle(decoration: BoxDecoration(color: Colors.white.withOpacity(0.5))),
            showBorder: true,
            borderColor: Colors.transparent,
            cellAspectRatio: 0.7,
            weekDayStringBuilder: getWeekDay,
            onPageChange: (date, pageIndex) {
              setState(() {
                _date = date;
                refreshData();
              });
            },
          ),
        ),
      ),
    );
  }
}
