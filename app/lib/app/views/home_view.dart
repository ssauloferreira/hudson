import 'package:hudson/app/components/sidebar_widget.dart';
import 'package:hudson/app/views/exchange_list_view.dart';
import 'package:hudson/app/views/feed_view.dart';
import 'package:hudson/app/views/report_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
  }

  void setCurrentPage(int value) {
    setState(() {
      currentPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: SidebarDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: setCurrentPage,
        children: const [FeedPage(), ExchangeListPage(), ReportPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Relatório',
          )
        ],
        onTap: (value) {
          _pageController.animateToPage(value, duration: const Duration(microseconds: 400), curve: Curves.ease);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/exchange_details');
        },
      ),
    );
  }
}
