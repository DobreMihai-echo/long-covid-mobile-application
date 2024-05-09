import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAndGranularityPicker extends StatefulWidget {
  @override
  _DateAndGranularityPickerState createState() => _DateAndGranularityPickerState();
}

class _DateAndGranularityPickerState extends State<DateAndGranularityPicker> {
  String selectedGranularity = 'Daily';
  DateTime selectedDate = DateTime.now();
  final dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedGranularity,
          items: <String>['Hourly', 'Daily', 'Monthly', 'Yearly']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGranularity = value!;
              fetchData();
            });
          },
        ),
        ElevatedButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != selectedDate)
              setState(() {
                selectedDate = picked;
                fetchData();
              });
          },
          child: Text('Select Date: ${dateFormat.format(selectedDate)}'),
        ),
      ],
    );
  }

  void fetchData() {
    // Call your API with selectedGranularity and selectedDate
  }
}
