import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './widgets/chart_switch.dart';

class HomePage extends StatefulWidget {
  final bool _isIOS;

  const HomePage(this._isIOS);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      title: 'New shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Groceries',
      amount: 120,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction, widget._isIOS);
        });
  }

  bool _showChart = false;

  void _toggleChart(bool value) {
    setState(() {
      _showChart = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final bool _isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = widget._isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    child: Icon(CupertinoIcons.add),
                    onTap: () => _startAddNewTransaction(context))
              ],
            ),
          )
        : AppBar(title: Text('Personal Expenses'), actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context))
          ]);

    final availableBodyHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final Widget chartSwitchContainer = Container(
        height: availableBodyHeight * 0.1,
        child: ChartSwitch(isOn: _showChart, onChanged: _toggleChart));

    Widget chartContainer(double relativeHeight) {
      return Container(
        height: availableBodyHeight * relativeHeight,
        child: Chart(_recentTransactions),
      );
    }

    Widget transactionListContainer(double relativeHeight) {
      return Container(
          height: availableBodyHeight * relativeHeight,
          child: TransactionList(_transactions, _deleteTransaction));
    }

    final Widget appBody = SafeArea(
      child: ListView(
        children: [
          if (_isLandscape) chartSwitchContainer,
          if (_isLandscape)
            _showChart ? chartContainer(0.9) : transactionListContainer(0.9),
          if (!_isLandscape) chartContainer(0.35),
          if (!_isLandscape) transactionListContainer(0.65),
        ],
      ),
    );

    return widget._isIOS
        ? CupertinoPageScaffold(navigationBar: appBar, child: appBody)
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButton: widget._isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
