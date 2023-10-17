

import 'package:expenses_app/components/chart_bar.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTrasaction;

  Chart(this.recentTrasaction);

  List<Map<String,Object>> get groupedTrasactions{
      return List.generate(7, (index)
      {
        final weekDay = DateTime.now().subtract(Duration(days: index),);

        double totalSum = 0;

        for(var i = 0; i < recentTrasaction.length; i++)
        {
          bool sameDay = recentTrasaction[i].date.day == weekDay.day;
          bool sameMonth = recentTrasaction[i].date.month == weekDay.month;
          bool sameYear = recentTrasaction[i].date.year == weekDay.year;

          if(sameDay && sameMonth && sameYear)
            totalSum += recentTrasaction[i].value;
        }
        
        return {'day': DateFormat.E().format(weekDay)[0], 'value': totalSum};
      }).reversed.toList();
  }

  double get _weekTotalValue{
    return groupedTrasactions.fold(0.0, (sum, tr){
      return sum + (tr['value'] as double);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
        margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTrasactions.map((tr){
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  tr['day'].toString()
                  ,double.parse(tr['value'].toString()),
                  _weekTotalValue == 0 ? 0 : (tr['value'] as double) / _weekTotalValue),
            );
          }).toList(),
        ),
      ),
    );
  }
}
