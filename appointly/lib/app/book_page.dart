import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointly/l10n/app_localizations.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? _selectedServiceId;
  String? _selectedServiceName;
  double? _selectedServiceCost;

  String? _selectedProviderId;
  String? _selectedProviderName;

  DateTime? _selectedDateTime;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _confirmBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _db.collection('appointments').add({
        'userId': user.uid,
        'serviceId': _selectedServiceId,
        'serviceName': _selectedServiceName,
        'providerId': _selectedProviderId,
        'providerName': _selectedProviderName,
        'cost': _selectedServiceCost,
        'dateTime': Timestamp.fromDate(_selectedDateTime!),
        'notes': _notesController.text.trim(),
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Η κράτηση ολοκληρώθηκε με επιτυχία!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Σφάλμα κατά την κράτηση: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50], // Απαλό φόντο για αντίθεση
      appBar: AppBar(
        title: Text(
          t.bookTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("1", "Επιλέξτε Υπηρεσία"),
            const SizedBox(height: 12),
            _buildModernCard(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db.collection('services').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LinearProgressIndicator());
                  }
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.category_rounded,
                        color: Colors.indigo,
                      ),
                    ),
                    value: _selectedServiceId,
                    hint: const Text("Διαθέσιμες Υπηρεσίες"),
                    items: snapshot.data?.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(
                          "${data['name'] ?? 'Υπηρεσία'} • ${data['cost'] ?? 0}€",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      final doc = snapshot.data!.docs.firstWhere(
                        (d) => d.id == val,
                      );
                      final data = doc.data() as Map<String, dynamic>;
                      setState(() {
                        _selectedServiceId = val;
                        _selectedServiceName = data['name'];
                        _selectedServiceCost = (data['cost'] as num).toDouble();
                        _selectedProviderId = null;
                        _selectedDateTime = null;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            if (_selectedServiceId != null) ...[
              _buildSectionHeader("2", "Επιλέξτε Πάροχο"),
              const SizedBox(height: 12),
              _buildModernCard(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db
                      .collection('providers')
                      .where('serviceIds', isEqualTo: _selectedServiceId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: LinearProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Δεν βρέθηκαν πάροχοι για αυτή την υπηρεσία.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person_rounded,
                          color: Colors.indigo,
                        ),
                      ),
                      value: _selectedProviderId,
                      hint: const Text("Επιλέξτε Επαγγελματία"),
                      items: snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(data['name'] ?? 'Πάροχος'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        final doc = snapshot.data!.docs.firstWhere(
                          (d) => d.id == val,
                        );
                        final data = doc.data() as Map<String, dynamic>;
                        setState(() {
                          _selectedProviderId = val;
                          _selectedProviderName = data['name'];
                          _selectedDateTime = null;
                        });
                      },
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 24),

            if (_selectedProviderId != null) ...[
              _buildSectionHeader("3", "Ημερομηνία & Σημειώσεις"),
              const SizedBox(height: 12),
              _buildModernCard(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        _selectedDateTime == null
                            ? "Επιλέξτε Ημερομηνία & Ώρα"
                            : "${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} στις ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontWeight: _selectedDateTime == null
                              ? FontWeight.normal
                              : FontWeight.bold,
                          color: _selectedDateTime == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _pickDateTime,
                    ),
                    const Divider(height: 32),
                    TextField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Σημειώσεις",
                        hintText: "Προσθέστε τυχόν λεπτομέρειες...",
                        border: InputBorder.none,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: (_selectedDateTime != null) ? _confirmBooking : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.indigo,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: const Text(
                  "Επιβεβαίωση Κράτησης",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper για τους τίτλους των ενοτήτων
  Widget _buildSectionHeader(String step, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            step,
            style: const TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Helper για το μοντέρνο container
  Widget _buildModernCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 9, minute: 0),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }
}
