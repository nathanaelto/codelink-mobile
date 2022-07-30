import 'package:codelink_mobile/in_app_view/articles_views/article_view.dart';
import 'package:codelink_mobile/in_app_view/kata_event_views/kata_event_view.dart';
import 'package:codelink_mobile/in_app_view/profile_views/profile_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const ArticleView(),
    KataEventView(),
    ProfileView(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
          children: [
            Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            )
          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.border_all_rounded), label: 'Event'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }

}