import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointly/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? _selectedCategoryId;
  String? _selectedCategoryName;

  String? _selectedServiceId;
  Map<String, dynamic>? _selectedServiceData;

  String? _selectedProviderId;
  String? _selectedProviderName;

  DateTime? _selectedDateTime;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    if (_selectedProviderId == null) return;

    try {
      final provDoc = await _db
          .collection('providers')
          .doc(_selectedProviderId)
          .get();

      final data = provDoc.data();
      final workingHours = data?['workingHours'] as Map<String, dynamic>?;

      final startHour = workingHours?['start'] ?? 9;
      final endHour = workingHours?['end'] ?? 20;

      final DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 60)),
        selectableDayPredicate: (DateTime val) =>
            val.weekday != DateTime.sunday,
      );

      if (date == null) return;

      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: startHour.toInt(), minute: 0),
      );

      if (time == null) return;

      final fullDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      if (fullDateTime.isBefore(DateTime.now())) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Δεν μπορείτε να κλείσετε ραντεβού σε ώρα που έχει περάσει!",
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (time.hour < startHour || time.hour >= endHour) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Ο πάροχος λειτουργεί $startHour:00 - $endHour:00"),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      final conflictQuery = await _db
          .collection('appointments')
          .where('providerId', isEqualTo: _selectedProviderId)
          .where('status', isEqualTo: 'active')
          .where('dateTime', isEqualTo: Timestamp.fromDate(fullDateTime))
          .get();

      if (conflictQuery.docs.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Αυτή η ώρα είναι ήδη κλεισμένη! Επιλέξτε άλλη."),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        return;
      }

      setState(() {
        _selectedDateTime = fullDateTime;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Σφάλμα κατά τον έλεγχο διαθεσιμότητας: $e")),
        );
      }
    }
  }

  Future<void> _confirmBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _selectedDateTime == null) return;

    try {
      // Υπολογισμός μέσης διάρκειας από τα δεδομένα του service
      final minD = (_selectedServiceData?['minDuration'] ?? 0) as num;
      final maxD = (_selectedServiceData?['maxDuration'] ?? 0) as num;
      final double averageDuration = (minD + maxD) / 2;

      await _db.collection('appointments').add({
        'userId': user.uid,
        'categoryId': _selectedCategoryId,
        'categoryName': _selectedCategoryName,
        'serviceId': _selectedServiceId,
        'serviceName': _selectedServiceData?['name'] ?? 'Άγνωστη Υπηρεσία',
        'providerId': _selectedProviderId,
        'providerName': _selectedProviderName,
        'cost': _selectedServiceData?['cost'] ?? 0,
        'duration': averageDuration, // Αποθήκευση του μέσου χρόνου
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
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Σφάλμα: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
            _buildSectionHeader("1", "Επιλέξτε Κατηγορία"),
            const SizedBox(height: 12),
            _buildModernCard(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db.collection('categories').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const LinearProgressIndicator();
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.grid_view_rounded,
                        color: Colors.indigo,
                      ),
                    ),
                    value: _selectedCategoryId,
                    hint: const Text("Κατηγορίες"),
                    items: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(data['name'] ?? 'Χωρίς Όνομα'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      final selectedDoc = snapshot.data!.docs.firstWhere(
                        (d) => d.id == val,
                      );
                      final selectedData =
                          selectedDoc.data() as Map<String, dynamic>;

                      setState(() {
                        _selectedCategoryId = val;
                        _selectedCategoryName =
                            selectedData['name'] ?? 'Εκπαίδευση';
                        _selectedServiceId = null;
                        _selectedServiceData = null;
                        _selectedProviderId = null;
                        _selectedDateTime = null;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedCategoryId != null) ...[
              _buildSectionHeader("2", "Επιλέξτε Υπηρεσία"),
              const SizedBox(height: 12),
              _buildModernCard(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db
                      .collection('services')
                      .where('categoryId', isEqualTo: _selectedCategoryId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const LinearProgressIndicator();
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
                      hint: const Text("Υπηρεσίες"),
                      items: snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(
                            "${data['name'] ?? 'Υπηρεσία'} • ${data['cost'] ?? 0}€",
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        final doc = snapshot.data!.docs.firstWhere(
                          (d) => d.id == val,
                        );
                        setState(() {
                          _selectedServiceId = val;
                          _selectedServiceData =
                              doc.data() as Map<String, dynamic>;
                          _selectedProviderId = null;
                          _selectedDateTime = null;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
            if (_selectedServiceData != null) ...[
              const SizedBox(height: 16),
              _buildDetailsCard(),
            ],
            const SizedBox(height: 24),
            if (_selectedServiceId != null) ...[
              _buildSectionHeader("3", "Επιλέξτε Πάροχο"),
              const SizedBox(height: 12),
              _buildModernCard(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db
                      .collection('providers')
                      .where('serviceIds', whereIn: [_selectedServiceId])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const LinearProgressIndicator();
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
                      hint: const Text("Επαγγελματίας / Κατάστημα"),
                      items: snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(data['name'] ?? 'Πάροχος'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        final selectedDoc = snapshot.data!.docs.firstWhere(
                          (d) => d.id == val,
                        );
                        final selectedData =
                            selectedDoc.data() as Map<String, dynamic>;
                        setState(() {
                          _selectedProviderId = val;
                          _selectedProviderName =
                              selectedData['name'] ?? 'Πάροχος';
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
              _buildSectionHeader("4", "Ημερομηνία & Σημειώσεις"),
              const SizedBox(height: 12),
              _buildModernCard(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.indigo,
                      ),
                      title: Text(
                        _selectedDateTime == null
                            ? "Επιλέξτε Ημερομηνία & Ώρα"
                            : "Επιλεγμένο: ${DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!)}",
                      ),
                      onTap: _pickDateTime,
                    ),
                    const Divider(),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: "Σημειώσεις (προαιρετικά)",
                        border: InputBorder.none,
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
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("Επιβεβαίωση Κράτησης"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Λεπτομέρειες Υπηρεσίας",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedServiceData?['description'] ?? 'Δεν υπάρχει περιγραφή.',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "Διάρκεια: ${_selectedServiceData?['minDuration'] ?? 0}-${_selectedServiceData?['maxDuration'] ?? 0} λεπτά",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                "${_selectedServiceData?['cost'] ?? 0}€",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String step, String title) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.indigo,
          child: Text(
            step,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildModernCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: child,
    );
  }
}
