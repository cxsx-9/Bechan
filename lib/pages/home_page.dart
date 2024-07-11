import 'package:bechan/services/filetransfer_service.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/show_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/widgets/all_data_card.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/date_card.dart';
import 'package:bechan/widgets/small_profile_card.dart';
import 'package:bechan/config.dart' as config;
import 'package:bechan/services/transaction_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {

  final Function(DateTime) onDataChanged;

  const HomePage({
    super.key,
    required this.onDataChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Menu { download }

class _HomePageState extends State<HomePage> {
  final User _user = config.USER_DATA;
  final DateTime _now = DateTime.now();
  String _range = DateFormat('dd MMMM yyyy').format(DateTime.now());
  String _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime? _start;
  DateTime? _end;
  bool _isLoading = true;
  bool _hasData = false;
  double _income = 0;
  double _expense = 0;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItem = 1;
  bool _morePage = false;
  List<dynamic> _listData = [];
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _reload(loading: true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _currentPage < _totalPages) 
      {
        _currentPage += 1;
        _morePage = true;
        _reload();
      }
      else {
        _morePage = false;
      }
    });
    super.initState();
  }

  // not show Circle loading for [pull to refresh] and [edit / delete] show just when it start
  Future<void> _reload({bool loading = false}) async {
    setState(() {_isLoading = loading;});
    dynamic response = await TransactionService().fetchTransaction(startDate:  _startDate, page: _currentPage, endDate: _endDate, onExpired: () => UserService().logout(context));
    if (response == null) {
      _listData = [];
    } else {
      if (_morePage) {
        _listData.addAll(response.transactions);
      } else {
        _listData = response.transactions;
      }
      if (_listData.isNotEmpty) {
        _hasData = true;
        _income = response.summary.totalIncome;
        _expense = response.summary.totalExpense;
        _totalPages = response.pagination.pageTotal;
        _totalItem = response.pagination.totalItem;
        print(_currentPage);
        print(_totalPages);
      }
    }
    _refreshController.refreshCompleted();
    setState(() {_isLoading = false;});
  }

  void _onSubmit(Object value) {
      if (value is PickerDateRange && value.startDate != null) {
        setState(() {
          _range = value.endDate == null || value.endDate == value.startDate
              ? DateFormat('dd MMMM yyyy').format(value.startDate!)
              : '${DateFormat('dd MMM yy').format(value.startDate!)} - ${DateFormat('dd MMM yy').format(value.endDate ?? value.startDate!)}';
          _startDate = DateFormat('yyyy-MM-dd').format(value.startDate!);
          _start = value.startDate;
          _endDate = DateFormat('yyyy-MM-dd').format(value.endDate ?? value.startDate!);
          _end = value.endDate;
          widget.onDataChanged(value.startDate!);
          _currentPage = 1;
          _morePage = false;
        });
        _reload();
        Navigator.of(context).pop();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: () => {_reload(loading: true)},
          enablePullDown: true,
          enablePullUp: false,
          enableTwoLevel: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallProfileCard(firstname: _user.firstname, email: _user.email, profilePath: _user.profilePath, greeting: "Welcome back!"),
                          const SizedBox(width: 10),
                          DateCard(time: _now)
                        ],
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Container(
                          decoration: cardDecoration(context),
                          child: TextButton(
                            onPressed: () {
                              ShowDatePickerFunction().showDateRange(context, _start, _end, _onSubmit);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 40,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.calendar_month_rounded, size: 17),
                                    const SizedBox(width: 10,),
                                    Text(_range),
                                    const Icon(Icons.arrow_drop_down_rounded),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                  child: PopupMenuButton<Menu>(
                                    elevation: 5,
                                    shadowColor: Theme.of(context).colorScheme.secondary,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    icon: const Icon(Icons.more_vert_rounded, size: 20,),
                                    onSelected: (Menu item) {},
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                                      PopupMenuItem<Menu>(
                                        onTap: _hasData ? () async {
                                          dynamic res = await FiletransferService().exportTransaction(_startDate, _endDate);
                                          if (res != null) {
                                            final Uri url = Uri.parse(res.url);
                                            if (!await launchUrl(url)) {
                                              throw Exception('Could not launch $url');
                                            }
                                          }
                                        } : null,
                                        value: Menu.download,
                                        child: _hasData
                                        ? const ListTile(
                                          leading: Icon(Icons.file_download),
                                          title: Text('Export transactions'),
                                        )
                                        : ListTile(
                                          title: Text('No Data to Export', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      AllDataCard(
                        data: _listData,
                        income: _income,
                        expense: _expense,
                        totalItem: _totalItem,
                        onDataChanged: _reload,
                        waiting: _isLoading,
                        scrollController : _scrollController
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}