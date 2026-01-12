import 'package:appointly/app.dart';
import 'package:flutter/material.dart';
import 'package:appointly/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final supabase = Supabase.instance.client;

  // Μεταβλητές κατάστασης για τη ροή της κράτησης
  Map<String, dynamic>? _selectedCategory;
  Map<String, dynamic>? _selectedProvider;
  Map<String, dynamic>? _selectedService;
  DateTime? _selectedDate;
  String? _selectedTime;
  bool _isSubmitting = false;

  void _reset() {
    setState(() {
      _selectedCategory = null;
      _selectedProvider = null;
      _selectedService = null;
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AppScaffold(
      title: t.bookTitle,
      child: Column(
        children: [
          // Breadcrumbs για εύκολη πλοήγηση πίσω
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  InputChip(
                    label: Text(_selectedCategory!['name'] ?? ""),
                    onDeleted: _reset,
                  ),
                  if (_selectedProvider != null)
                    InputChip(
                      label: Text(
                        _selectedProvider!['display_name'] ?? "Επαγγελματίας",
                      ),
                      onDeleted: () => setState(() {
                        _selectedProvider = null;
                        _selectedService = null;
                        _selectedDate = null;
                        _selectedTime = null;
                      }),
                    ),
                  if (_selectedService != null)
                    InputChip(
                      label: Text(_selectedService!['name'] ?? "Υπηρεσία"),
                      onDeleted: () => setState(() {
                        _selectedService = null;
                        _selectedDate = null;
                        _selectedTime = null;
                      }),
                    ),
                ],
              ),
            ),
          Expanded(child: _buildStepContent(t)),
        ],
      ),
    );
  }

  Widget _buildStepContent(AppLocalizations t) {
    if (_selectedCategory == null) return _buildCategoryStep();
    if (_selectedProvider == null) return _buildProviderStep();
    if (_selectedService == null) return _buildServiceStep();
    return _buildDateTimeStep(t);
  }

  // --- ΒΗΜΑ 1: ΚΑΤΗΓΟΡΙΕΣ ---
  Widget _buildCategoryStep() {
    return FutureBuilder(
      future: supabase.from('categories').select(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final categories = snapshot.data as List<dynamic>;
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) => _SelectionCard(
            title: categories[index]['name'] ?? "Κατηγορία",
            subtitle: "Επιλέξτε για να συνεχίσετε",
            icon: Icons.category_outlined,
            onTap: () => setState(() => _selectedCategory = categories[index]),
          ),
        );
      },
    );
  }

  // --- ΒΗΜΑ 2: ΠΑΡΟΧΟΙ ---
  Widget _buildProviderStep() {
    return FutureBuilder(
      future: supabase
          .from('providers')
          .select('*, services!inner(category_id)')
          .eq('services.category_id', _selectedCategory!['id']),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final providers = snapshot.data as List<dynamic>;
        return ListView.builder(
          itemCount: providers.length,
          itemBuilder: (context, index) => _SelectionCard(
            // Πρόληψη σφάλματος Null String
            title: providers[index]['display_name'] ?? "Επαγγελματίας",
            subtitle:
                providers[index]['location_text'] ?? "Τοποθεσία μη διαθέσιμη",
            icon: Icons.person_pin_outlined,
            onTap: () => setState(() => _selectedProvider = providers[index]),
          ),
        );
      },
    );
  }

  // --- ΒΗΜΑ 3: ΥΠΗΡΕΣΙΕΣ (Απαραίτητο για το service_id) ---
  Widget _buildServiceStep() {
    return FutureBuilder(
      future: supabase
          .from('services')
          .select('*, provider_services!inner(*)')
          .eq('provider_services.provider_id', _selectedProvider!['id'])
          .eq('category_id', _selectedCategory!['id']),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final services = snapshot.data as List<dynamic>;
        return ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) => _SelectionCard(
            title: services[index]['name'] ?? "Υπηρεσία",
            subtitle: "${services[index]['cost'] ?? 0} €",
            icon: Icons.auto_awesome_outlined,
            onTap: () => setState(() => _selectedService = services[index]),
          ),
        );
      },
    );
  }

  // --- ΒΗΜΑ 4: ΗΜΕΡΟΜΗΝΙΑ & ΩΡΑ ---
  Widget _buildDateTimeStep(AppLocalizations t) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 30)),
            onDateChanged: (date) => setState(() {
              _selectedDate = date;
              _selectedTime = null;
            }),
          ),
          if (_selectedDate != null) ...[const Divider(), _buildSlotsGrid()],
          const SizedBox(height: 32),
          if (_selectedTime != null)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _confirmBooking,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Ολοκλήρωση"),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlotsGrid() {
    final List<String> slots = [
      "09:00",
      "10:00",
      "11:00",
      "14:00",
      "15:00",
      "16:00",
    ];
    return Wrap(
      spacing: 8,
      children: slots
          .map(
            (time) => ChoiceChip(
              label: Text(time),
              selected: _selectedTime == time,
              onSelected: (val) =>
                  setState(() => _selectedTime = val ? time : null),
            ),
          )
          .toList(),
    );
  }

  // --- ΤΕΛΙΚΗ ΚΡΑΤΗΣΗ ---
  Future<void> _confirmBooking() async {
    setState(() => _isSubmitting = true);
    try {
      final user = supabase.auth.currentUser;
      final startTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        int.parse(_selectedTime!.split(':')[0]),
        0,
      );

      // Υπολογισμός λήξης (ends_at) για αποφυγή του null constraint
      final duration =
          _selectedService!['min_duration_minutes'] ??
          30; // Από πίνακα services
      final endTime = startTime.add(Duration(minutes: duration));

      await supabase.from('appointments').insert({
        'user_id': user!.id,
        'provider_id': _selectedProvider!['id'],
        'service_id': _selectedService!['id'], // Λύνει το service_id constraint
        'starts_at': startTime.toIso8601String(),
        'ends_at': endTime.toIso8601String(), // Λύνει το ends_at constraint
        'status': 'pending', // Λύνει το status_check constraint
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Η κράτηση ολοκληρώθηκε!"),
            backgroundColor: Colors.green,
          ),
        );
        _reset();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Σφάλμα: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _SelectionCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
