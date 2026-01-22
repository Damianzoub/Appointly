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
  String _selectedPeriod = 'All';
  int tabIndex = 0; // 0 = upcoming, 1 = completed

  // Helper συνάρτηση για ασφαλή ανάκτηση μεταφρασμένου κειμένου
  String _getTranslated(
    Map<String, dynamic> data,
    String fieldKey,
    String lang,
    String fallback,
  ) {
    // Προσπάθεια ανάγνωσης από το Map των μεταφράσεων (π.χ. serviceNameMap)
    final mapField = data['${fieldKey}Map'];
    if (mapField is Map) {
      return mapField[lang]?.toString() ??
          mapField['en']?.toString() ??
          fallback;
    }
    // Fallback στο απλό String πεδίο (για παλιά ραντεβού)
    return data[fieldKey]?.toString() ?? fallback;
  }

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
    final t = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;

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
                  hint: Text(t.historyFilterCategoryHint),
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(t.historyFilterAllCategories),
                    ),
                    if (snapshot.hasData)
                      ...snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        // Δυναμική μετάφραση ονόματος κατηγορίας στο φίλτρο
                        final name = data['name'] is Map
                            ? (data['name'][lang] ?? data['name']['en'] ?? "")
                            : (data['name'] ?? "").toString();
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(name),
                        );
                      }),
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
              items: [
                DropdownMenuItem(
                  value: 'All',
                  child: Text(t.historyFilterPeriodAll),
                ),
                DropdownMenuItem(
                  value: 'Day',
                  child: Text(t.historyFilterPeriodDay),
                ),
                DropdownMenuItem(
                  value: 'Week',
                  child: Text(t.historyFilterPeriodWeek),
                ),
                DropdownMenuItem(
                  value: 'Month',
                  child: Text(t.historyFilterPeriodMonth),
                ),
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
    final t = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection("appointments")
          .where("userId", isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(t.historyError(snapshot.error.toString())));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs.where((
          doc,
        ) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['dateTime'] == null) return false;

          final date = (data['dateTime'] as Timestamp).toDate();
          final appointmentDay = DateTime(date.year, date.month, date.day);

          bool isPast = date.isBefore(now);
          if (tabIndex == 0 && isPast) return false;
          if (tabIndex == 1 && !isPast) return false;

          if (_selectedCategoryId != null &&
              data['categoryId'] != _selectedCategoryId) {
            return false;
          }

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

        filteredDocs.sort((a, b) {
          final dateA =
              (a.data() as Map<String, dynamic>)['dateTime'] as Timestamp;
          final dateB =
              (b.data() as Map<String, dynamic>)['dateTime'] as Timestamp;
          return tabIndex == 0
              ? dateA.compareTo(dateB)
              : dateB.compareTo(dateA);
        });

        double totalCost = 0;
        double totalMinutes = 0;

        for (var doc in filteredDocs) {
          final data = doc.data() as Map<String, dynamic>;
          totalCost += (data['cost'] ?? 0).toDouble();
          totalMinutes += (data['duration'] ?? 0).toDouble();
        }

        if (filteredDocs.isEmpty) {
          return Center(child: Text(t.historyNoResults));
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildSummaryCard(t, filteredDocs.length, totalCost, totalMinutes),
            const SizedBox(height: 16),
            ...filteredDocs.map(
              (doc) =>
                  _buildAppointmentCard(t, doc.data() as Map<String, dynamic>),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(
    AppLocalizations t,
    int count,
    double cost,
    double minutes,
  ) {
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
          _summaryItem(t.historySummaryAppointments, count.toString()),
          _summaryItem(t.historySummaryTotal, "${cost.toStringAsFixed(0)}€"),
          _summaryItem(
            t.historySummaryHours,
            "${(minutes / 60).toStringAsFixed(1)}h",
          ),
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

  Widget _buildAppointmentCard(AppLocalizations t, Map<String, dynamic> data) {
    final lang = Localizations.localeOf(context).languageCode;
    final date = (data['dateTime'] as Timestamp).toDate();
    final formatted = DateFormat('dd/MM/yyyy HH:mm').format(date);

    // Δυναμική μετάφραση με χρήση των Maps
    final serviceName = _getTranslated(
      data,
      'serviceName',
      lang,
      t.historyFallbackService,
    );
    final providerName = _getTranslated(
      data,
      'providerName',
      lang,
      t.historyFallbackProvider,
    );
    final categoryName = _getTranslated(data, 'categoryName', lang, '');

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
                if (categoryName.isNotEmpty)
                  Text(
                    categoryName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                Text(
                  serviceName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  providerName,
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
            "${(data['cost'] ?? 0)}€",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
