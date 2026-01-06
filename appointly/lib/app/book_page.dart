import 'package:appointly/app.dart';
import 'package:flutter/material.dart';

class _CardLine extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CardLine({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Book",
      child: ListView(
        children: const [
          Text(
            "Booking placeholder",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          _CardLine(title: "Step 1", subtitle: "Choose Category"),
          _CardLine(title: "Step 2", subtitle: "Choose provider"),
          _CardLine(title: "Step 3", subtitle: "Pick date & time"),
        ],
      ),
    );
  }
}
