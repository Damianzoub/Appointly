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

  // State για τις επιλογές του χρήστη
  Map<String, dynamic>? selectedCategory;
  Map<String, dynamic>? selectedProvider;
  DateTime? selectedDate;

  // Μέθοδος για reset της διαδικασίας
  void _reset() {
    setState(() {
      selectedCategory = null;
      selectedProvider = null;
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AppScaffold(
      title: t.bookTitle,
      child: Column(
        children: [
          if (selectedCategory != null)
            Chip(
              label: Text(selectedCategory!['name']),
              onDeleted: _reset,
              deleteIcon: const Icon(Icons.close, size: 18),
            ),
          const SizedBox(height: 16),
          Expanded(child: _buildCurrentStep(t)),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(AppLocalizations t) {
    // ΒΗΜΑ 1: Επιλογή Κατηγορίας
    if (selectedCategory == null) {
      return _buildCategoryStep();
    }

    // ΒΗΜΑ 2: Επιλογή Παρόχου (Providers)
    if (selectedProvider == null) {
      return _buildProviderStep();
    }

    // ΒΗΜΑ 3: Επιλογή Ημερομηνίας/Ώρας
    return _buildDateTimeStep(t);
  }

  // --- WIDGETS ΓΙΑ ΚΑΘΕ ΒΗΜΑ ---

  Widget _buildCategoryStep() {
    return FutureBuilder(
      future: supabase.from('categories').select(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final categories = snapshot.data!;
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return _SelectionCard(
              title: cat['name'],
              subtitle: "Περιηγηθείτε στις υπηρεσίες",
              onTap: () => setState(() => selectedCategory = cat),
            );
          },
        );
      },
    );
  }

  Widget _buildProviderStep() {
    // Εδώ φιλτράρουμε τους παρόχους που προσφέρουν υπηρεσίες της επιλεγμένης κατηγορίας
    // Σημείωση: Σύμφωνα με το σχήμα σου, η σύνδεση γίνεται μέσω του πίνακα services
    return FutureBuilder(
      future: supabase
          .from('providers')
          .select('*, services!inner(*)')
          .eq('services.category_id', selectedCategory!['id']),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final providers = snapshot.data!;
        if (providers.isEmpty)
          return const Center(
            child: Text("Δεν βρέθηκαν πάροχοι για αυτή την κατηγορία."),
          );

        return ListView.builder(
          itemCount: providers.length,
          itemBuilder: (context, index) {
            final prov = providers[index];
            return _SelectionCard(
              title: prov['display_name'] ?? "Επαγγελματίας",
              subtitle: prov['location_text'] ?? "Τοποθεσία μη διαθέσιμη",
              onTap: () => setState(() => selectedProvider = prov),
            );
          },
        );
      },
    );
  }

  Widget _buildDateTimeStep(AppLocalizations t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.calendar_month, size: 64, color: Colors.indigo),
        const SizedBox(height: 20),
        Text("Επιλογή ημερομηνίας για: ${selectedProvider!['display_name']}"),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
            );
            if (picked != null) setState(() => selectedDate = picked);
          },
          icon: const Icon(Icons.date_range),
          label: Text(
            selectedDate == null
                ? "Επιλέξτε Ημερομηνία"
                : selectedDate.toString().split(' ')[0],
          ),
        ),
        if (selectedDate != null) ...[
          const SizedBox(height: 20),
          const Text("Διαθέσιμες Ώρες (Από provider_availability):"),
          // Εδώ θα μπορούσε να μπει ένα GridView με τις ώρες από τον πίνακα provider_availability
        ],
      ],
    );
  }
}

// Helper Widget για τις κάρτες επιλογής
class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
