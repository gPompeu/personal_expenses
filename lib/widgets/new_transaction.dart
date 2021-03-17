import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;
  final bool _isIOS;

  NewTransaction(this.addNewTransaction, this._isIOS);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty ||
        (enteredAmount == null || enteredAmount.isNegative) ||
        _selectedDate == null) {
      return;
    }

    widget.addNewTransaction(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Title',
          ),
          controller: _titleController,
          onSubmitted: (_) => _submitData(),
        ),
        TextField(
          decoration: InputDecoration(
            labelText: 'Amount',
          ),
          controller: _amountController,
          keyboardType: TextInputType.number,
          onSubmitted: (_) => _submitData(),
        ),
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedDate == null
                    ? 'No date selected!'
                    : 'Selected date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
              ),
              widget._isIOS
                  ? CupertinoButton(
                      child: Text(
                        'Select date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _presentDatePicker,
                    )
                  : TextButton(
                      child: Text('Select date'),
                      onPressed: _presentDatePicker,
                    )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _submitData,
              child: Text(
                'Add Transaction',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
