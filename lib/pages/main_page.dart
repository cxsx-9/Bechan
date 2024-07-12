import 'package:bechan/config.dart' as config;
import 'package:bechan/pages/add_record.dart';
import 'package:bechan/pages/category_page.dart';
import 'package:bechan/pages/chart_page.dart';
import 'package:bechan/pages/home_page.dart';
import 'package:bechan/pages/loading_page.dart';
import 'package:bechan/pages/setting_page.dart';
import 'package:bechan/services/category_service.dart';
import 'package:bechan/services/tag_service.dart';
import 'package:bechan/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  final DateTime _now = DateTime.now();
  late List page;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    CategoryService().fetchCategory();
    TagService().fetchTag();
    page = [
      HomePage(onDataChanged: setStartDate),
      const ChartPage(),
      const CategoryPage(),
      const SettingPage(),
    ];
  }

  Future<void> _fetchUserData() async {
      await UserService().fetch();
      setState(() {
        _isLoading = false;
      });
  }
  
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index == 0) setStartDate(_now);
    setState(() { _selectedIndex = index; });
  }

  void setStartDate(DateTime startDate) {
    setState(() {
      _selectedDate = startDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingPage();
    }
    if (config.USER_DATA.email == '') {
      UserService().logout(context);
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
              return AddRecord(date : _selectedDate);
            }
          );
          if (isReload == true && _selectedIndex == 0) {
            page[0] = HomePage(onDataChanged: setStartDate, loadStart: true,);
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        toolbarHeight: 10,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      body: page.elementAt(_selectedIndex),
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
                child: FaIcon(
                  FontAwesomeIcons.house, 
                  size: 22,
                  color: _selectedIndex == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
                ),
                onPressed: () {_onItemTapped(0);},
              ),
              TextButton(
                child: FaIcon(
                  FontAwesomeIcons.chartSimple, 
                  size: 22,
                  color: _selectedIndex == 1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
                ),
                onPressed: () {_onItemTapped(1);},
              ),

              const SizedBox(width: 50,),
              TextButton(
                child: FaIcon(
                  FontAwesomeIcons.tags, 
                  size: 22,
                  color: _selectedIndex == 2 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
                ),
                onPressed: () {_onItemTapped(2);},
              ),
              TextButton(
                child: FaIcon(
                  FontAwesomeIcons.bars, 
                  size: 22,
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
