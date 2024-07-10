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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    CategoryService().fetchCategory();
    TagService().fetchTag();
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

  void setStartDate(DateTime startDate) {
    setState(() {
      _selectedDate = startDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> page = <Widget>[
      HomePage(onDataChanged: setStartDate),
      const ChartPage(),
      const CategoryPage(),
      const SettingPage(),
    ];
    
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
              return AddRecord(date : _selectedDate);
            }
          );
          if (isReload == true && _selectedIndex == 0) {
            page[0] = HomePage(isReload: true, onDataChanged: setStartDate,);
            setState(() {});
            _onItemTapped(0);
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
