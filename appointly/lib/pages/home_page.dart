import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointly/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

enum AppointmentFilter { all, day, week, month }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppointmentFilter _activeFilter = AppointmentFilter.all;

  String _getTranslated(
    Map<String, dynamic> data,
    String fieldKey,
    String lang,
    String fallback,
  ) {
    final mapField = data['${fieldKey}Map'];
    if (mapField is Map) {
      return mapField[lang]?.toString() ??
          mapField['en']?.toString() ??
          fallback;
    }
    return data[fieldKey]?.toString() ?? fallback;
  }

  Future<void> _cancelAppointment(String docId) async {
    final t = AppLocalizations.of(context)!;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.cancelAppointmentTitle),
        content: Text(t.cancelAppointmentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.yesCancel, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _db.collection('appointments').doc(docId).update({
        'status': 'cancelled',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Το ραντεβού ακυρώθηκε επιτυχώς"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _editAppointment(String docId, DateTime currentDate) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: currentDate.isAfter(DateTime.now())
          ? currentDate
          : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (newDate == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDate),
    );
    if (time == null) return;
    final finalDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      time.hour,
      time.minute,
    );
    await _db.collection('appointments').doc(docId).update({
      'dateTime': Timestamp.fromDate(finalDateTime),
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final uid = _auth.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          t.homeTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton<AppointmentFilter>(
            icon: const Icon(Icons.filter_list_rounded),
            onSelected: (filter) => setState(() => _activeFilter = filter),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: AppointmentFilter.all,
                child: Text(
                  t.historyFilterPeriodAll,
                ), // Μετάφραση: Όλα [cite: 16]
              ),
              PopupMenuItem(
                value: AppointmentFilter.day,
                child: Text(
                  t.historyFilterPeriodDay,
                ), // Μετάφραση: Ημέρα [cite: 16]
              ),
              PopupMenuItem(
                value: AppointmentFilter.week,
                child: Text(
                  t.historyFilterPeriodWeek,
                ), // Μετάφραση: Εβδομάδα [cite: 16]
              ),
              PopupMenuItem(
                value: AppointmentFilter.month,
                child: Text(
                  t.historyFilterPeriodMonth,
                ), // Μετάφραση: Μήνας [cite: 16]
              ),
            ],
          ),
        ],
      ),
      body: uid == null
          ? _buildEmptyState(context, t)
          : StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection('appointments')
                  .where('userId', isEqualTo: uid)
                  .where('status', isEqualTo: 'active')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                final allDocs = snapshot.data?.docs ?? [];
                final now = DateTime.now();

                final filteredDocs = allDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final dt = (data['dateTime'] as Timestamp).toDate();
                  if (dt.isBefore(now.subtract(const Duration(minutes: 10))))
                    return false;
                  switch (_activeFilter) {
                    case AppointmentFilter.day:
                      return _isSameDay(dt, now);
                    case AppointmentFilter.week:
                      return dt.isBefore(now.add(const Duration(days: 7)));
                    case AppointmentFilter.month:
                      return dt.isBefore(now.add(const Duration(days: 30)));
                    default:
                      return true;
                  }
                }).toList();

                filteredDocs.sort((a, b) {
                  final dateA =
                      (a.data() as Map<String, dynamic>)['dateTime']
                          as Timestamp;
                  final dateB =
                      (b.data() as Map<String, dynamic>)['dateTime']
                          as Timestamp;
                  return dateA.compareTo(dateB);
                });

                if (filteredDocs.isEmpty) return _buildEmptyState(context, t);

                final todaysDocs = filteredDocs
                    .where(
                      (d) => _isSameDay(
                        (d.data() as Map<String, dynamic>)['dateTime'].toDate(),
                        now,
                      ),
                    )
                    .toList();
                final upcomingDocs = filteredDocs
                    .where(
                      (d) => !_isSameDay(
                        (d.data() as Map<String, dynamic>)['dateTime'].toDate(),
                        now,
                      ),
                    )
                    .toList();

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (todaysDocs.isNotEmpty) ...[
                      _buildSectionTitle(t.todayAppointments),
                      const SizedBox(height: 12),
                      ...todaysDocs.map(
                        (doc) => _buildAppointmentCard(
                          context: context,
                          t: t,
                          id: doc.id,
                          data: doc.data() as Map<String, dynamic>,
                          date: (doc.data() as Map<String, dynamic>)['dateTime']
                              .toDate(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (upcomingDocs.isNotEmpty) ...[
                      _buildSectionTitle(t.upcomingAppointments),
                      const SizedBox(height: 12),
                      ...upcomingDocs.map(
                        (doc) => _buildAppointmentCard(
                          context: context,
                          t: t,
                          id: doc.id,
                          data: doc.data() as Map<String, dynamic>,
                          date: (doc.data() as Map<String, dynamic>)['dateTime']
                              .toDate(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _buildHistoryButton(context, t),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations t) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 80,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              t.appointmentsEmptyTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              t.appointmentsEmptySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildHistoryButton(BuildContext context, AppLocalizations t) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/appointments_history'),
        icon: const Icon(Icons.history_rounded),
        label: Text(t.seeAllHistory),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required BuildContext context,
    required AppLocalizations t,
    required String id,
    required Map<String, dynamic> data,
    required DateTime date,
  }) {
    final lang = Localizations.localeOf(context).languageCode;
    final serviceName = _getTranslated(data, 'serviceName', lang, 'Service');
    final providerName = _getTranslated(data, 'providerName', lang, 'Provider');
    final categoryName = _getTranslated(data, 'categoryName', lang, '');
    final notes = (data['notes'] ?? '').toString();
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final formatted = DateFormat('dd MMM yyyy • HH:mm', localeTag).format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 6, color: Colors.indigo),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${data['cost'] ?? 0}€",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              providerName,
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formatted,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (notes.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.sticky_note_2_outlined,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  notes,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => _editAppointment(id, date),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: Text(t.change),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => _cancelAppointment(id),
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.red,
                            ),
                            label: Text(
                              t.cancelAppointment,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
