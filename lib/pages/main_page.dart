import 'package:bechan/pages/add_record.dart';
import 'package:bechan/pages/category_page.dart';
import 'package:bechan/pages/chart_page.dart';
import 'package:bechan/pages/home_page.dart';
import 'package:bechan/pages/loading_page.dart';
import 'package:bechan/pages/setting_page.dart';
import 'package:bechan/services/category_service.dart';
import 'package:bechan/services/user_service.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    CategoryService().fetchCategory();
  }

  Future<void> _fetchUserData() async {
      await UserService().fetch();
      setState(() {
        _isLoading = false;
      });
  }
  
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() { _selectedIndex = index; });
  }

  final List<Widget> _page = <Widget>[
    HomePage(),
    const ChartPage(),
    const CategoryPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingPage();
    }
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () async {
          final isReload = await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return AddRecord(date : DateTime.now());
            }
          );
          if (isReload == true && _selectedIndex == 0) {
            _page[0] = HomePage(isReload: true,);
            setState(() {});
            _onItemTapped(0);
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _page.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        height: 50,
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.surfaceBright,
        notchMargin: 10,
        shadowColor: Theme.of(context).colorScheme.shadow,
        child: Container(
          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                child: Icon(
                  Icons.home, 
                  size: 30,
                  color: _selectedIndex == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
                ),
                onPressed: () {_onItemTapped(0);},
              ),
              TextButton(
                child: Icon(
                  Icons.bar_chart_rounded, 
                  size: 30,
                  color: _selectedIndex == 1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
                ),
                onPressed: () {_onItemTapped(1);},
              ),

              const SizedBox(width: 50,),
              TextButton(
                child: Icon(
                  Icons.note_alt_outlined, 
                  size: 30,
                  color: _selectedIndex == 2 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
                ),
                onPressed: () {_onItemTapped(2);},
              ),
              TextButton(
                child: Icon(
                  Icons.settings, 
                  size: 30,
                  color: _selectedIndex == 3 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
                ),
                onPressed: () {_onItemTapped(3);},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
