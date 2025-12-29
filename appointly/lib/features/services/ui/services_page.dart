import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CategoryChip(label: 'Hair'),
              _CategoryChip(label: 'Health'),
              _CategoryChip(label: 'Fitness'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Popular services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _ServiceCard(
            name: 'Hair',
            subtitle: '30–60 min  from 25\$',
            onTap: () {},
          ),
          _ServiceCard(
            name: 'Consultation',
            subtitle: '30–45 min • from 40\$',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () {},
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
