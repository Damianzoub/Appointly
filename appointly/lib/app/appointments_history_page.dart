import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appointly/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppointmentsHistoryPage extends StatefulWidget {
  const AppointmentsHistoryPage({super.key});

  @override
  State<AppointmentsHistoryPage> createState() =>
      _AppointmentsHistoryPageState();
}

class _AppointmentsHistoryPageState extends State<AppointmentsHistoryPage> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? _selectedCategoryId;
  // Φιλτράρισμα περιόδου: All, Day, Week, Month (όπως στην home_page)
  String _selectedPeriod = 'All';
  int tabIndex = 0; // 0 = upcoming, 1 = completed

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.appointmentHistory)),
        body: Center(child: Text(t.notLoggedIn)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          t.appointmentHistory,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildTabs(t),
          Expanded(child: _buildAppointmentsList(user.uid)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db.collection('categories').snapshots(),
              builder: (context, snapshot) {
                return DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategoryId,
                  hint: const Text("Κατηγορία"),
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(value: null, child: Text("Όλες")),
                    if (snapshot.hasData)
                      ...snapshot.data!.docs.map(
                        (doc) => DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['name'] ?? ""),
                        ),
                      ),
                  ],
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedPeriod,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'All', child: Text("Όλα")),
                DropdownMenuItem(value: 'Day', child: Text("Ημέρα")),
                DropdownMenuItem(value: 'Week', child: Text("Εβδομάδα")),
                DropdownMenuItem(value: 'Month', child: Text("Μήνας")),
              ],
              onChanged: (val) => setState(() => _selectedPeriod = val!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _tabButton(0, t.upcomingTab),
          const SizedBox(width: 12),
          _tabButton(1, t.completedTab),
        ],
      ),
    );
  }

  Widget _tabButton(int index, String label) {
    bool active = tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.indigo : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? Colors.indigo : Colors.grey[300]!,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection("appointments")
          .where("userId", isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text("Error: ${snapshot.error}"));
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs.where((
          doc,
        ) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['dateTime'] == null) return false;

          final date = (data['dateTime'] as Timestamp).toDate();
          final appointmentDay = DateTime(date.year, date.month, date.day);

          // Διαχωρισμός Upcoming / Completed
          bool isPast = date.isBefore(now);
          if (tabIndex == 0 && isPast) return false;
          if (tabIndex == 1 && !isPast) return false;

          // Φίλτρο Κατηγορίας
          if (_selectedCategoryId != null &&
              data['categoryId'] != _selectedCategoryId) {
            return false;
          }

          // Λογική Φιλτραρίσματος Περιόδου (όπως στην home_page)
          if (_selectedPeriod == 'Day') {
            if (appointmentDay != today) return false;
          } else if (_selectedPeriod == 'Week') {
            final sevenDaysFromNow = today.add(const Duration(days: 7));
            if (appointmentDay.isBefore(today) ||
                appointmentDay.isAfter(sevenDaysFromNow)) {
              return false;
            }
          } else if (_selectedPeriod == 'Month') {
            final thirtyDaysFromNow = today.add(const Duration(days: 30));
            if (appointmentDay.isBefore(today) ||
                appointmentDay.isAfter(thirtyDaysFromNow)) {
              return false;
            }
          }

          return true;
        }).toList();

        // Ταξινόμηση
        filteredDocs.sort((a, b) {
          final dateA =
              (a.data() as Map<String, dynamic>)['dateTime'] as Timestamp;
          final dateB =
              (b.data() as Map<String, dynamic>)['dateTime'] as Timestamp;
          return tabIndex == 0
              ? dateA.compareTo(dateB) // Στα μελλοντικά, το πιο κοντινό πρώτο
              : dateB.compareTo(
                  dateA,
                ); // Στα ολοκληρωμένα, το πιο πρόσφατο πρώτο
        });

        // Υπολογισμός Συνόλων
        double totalCost = 0;
        double totalMinutes = 0;

        for (var doc in filteredDocs) {
          final data = doc.data() as Map<String, dynamic>;
          totalCost += (data['cost'] ?? 0).toDouble();

          final duration = (data['duration'] ?? 0).toDouble();
          totalMinutes += duration;
        }

        if (filteredDocs.isEmpty) {
          return const Center(child: Text("Δεν βρέθηκαν ραντεβού."));
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildSummaryCard(filteredDocs.length, totalCost, totalMinutes),
            const SizedBox(height: 16),
            ...filteredDocs.map(
              (doc) =>
                  _buildAppointmentCard(doc.data() as Map<String, dynamic>),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(int count, double cost, double minutes) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("Ραντεβού", count.toString()),
          _summaryItem("Σύνολο", "${cost.toStringAsFixed(0)}€"),
          _summaryItem("Ώρες", "${(minutes / 60).toStringAsFixed(1)}h"),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> data) {
    final date = (data['dateTime'] as Timestamp).toDate();
    final formatted = DateFormat('dd/MM/yyyy HH:mm').format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.event_note, color: Colors.indigo),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['serviceName'] ?? "Υπηρεσία",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  data['providerName'] ?? "Πάροχος",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                Text(
                  formatted,
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${data['cost'] ?? 0}€",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
