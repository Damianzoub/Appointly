import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:const Text("Calendar")),
      body: Padding(padding: const EdgeInsets.all(16) , 
      child: Column(
        children: [
          SegmentedButton(segments: const [
            ButtonSegment(value: 'day',label:Text("Day")),
            ButtonSegment(value: 'week',label:Text("Week")),
            ButtonSegment(value: 'month',label:Text("Month")),
          ], selected: const {'week'},
          onSelectionChanged: (_){},
          ),
          const SizedBox(height: 16),
          const Expanded(child: Center(child: Text('Calendar View Placeholder')),),
        ]
      ))
    );
  }
}