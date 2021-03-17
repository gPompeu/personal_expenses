import 'package:flutter/material.dart';

class ChartSwitch extends StatelessWidget {
  final Function onChanged;
  final bool isOn;

  const ChartSwitch({this.isOn, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Show Chart', style: Theme.of(context).textTheme.headline6),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor,
          onChanged: (bool value) {
            this.onChanged(value);
          },
          value: this.isOn,
        )
      ],
    );
  }
}
