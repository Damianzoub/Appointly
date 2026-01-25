import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointly/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

// Ορισμός των διαθέσιμων φίλτρων
enum AppointmentFilter { all, day, week, month }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Κατάσταση του επιλεγμένου φίλτρου
  AppointmentFilter _activeFilter = AppointmentFilter.all;

  // Helper συνάρτηση για ασφαλή ανάκτηση μεταφρασμένου κειμένου
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

  // Μέθοδος ακύρωσης και οριστικής διαγραφής από τη βάση
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
      try {
        await _db.collection('appointments').doc(docId).delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Το ραντεβού ακυρώθηκε και διαγράφηκε επιτυχώς"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Σφάλμα κατά τη διαγραφή: $e")),
          );
        }
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
                child: Text(t.historyFilterPeriodAll),
              ),
              PopupMenuItem(
                value: AppointmentFilter.day,
                child: Text(t.historyFilterPeriodDay),
              ),
              PopupMenuItem(
                value: AppointmentFilter.week,
                child: Text(t.historyFilterPeriodWeek),
              ),
              PopupMenuItem(
                value: AppointmentFilter.month,
                child: Text(t.historyFilterPeriodMonth),
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
                  // Εμφανίζουμε και τα περασμένα ραντεβού (έως 10 λεπτά πριν) για να φαίνονται ως γκρι
                  if (dt.isBefore(now.subtract(const Duration(days: 365))))
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
                      (d) =>
                          (d.data() as Map<String, dynamic>)['dateTime']
                              .toDate()
                              .isAfter(now) &&
                          !_isSameDay(
                            (d.data() as Map<String, dynamic>)['dateTime']
                                .toDate(),
                            now,
                          ),
                    )
                    .toList();

                // Συμπεριλαμβάνουμε τα περασμένα στη λίστα για να φαίνονται γκρι
                final pastDocs = filteredDocs
                    .where(
                      (d) =>
                          (d.data() as Map<String, dynamic>)['dateTime']
                              .toDate()
                              .isBefore(now) &&
                          !_isSameDay(
                            (d.data() as Map<String, dynamic>)['dateTime']
                                .toDate(),
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
                    if (upcomingDocs.isNotEmpty || pastDocs.isNotEmpty) ...[
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
                      ...pastDocs.map(
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

    // Έλεγχος αν το ραντεβού έχει περάσει
    final bool isPast = date.isBefore(DateTime.now());

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
        child: Opacity(
          // Γκρι εμφάνιση αν έχει περάσει
          opacity: isPast ? 0.6 : 1.0,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 6,
                  color: isPast ? Colors.grey : Colors.indigo,
                ),
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
                                      style: TextStyle(
                                        color: isPast
                                            ? Colors.grey
                                            : Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  Text(
                                    serviceName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isPast
                                          ? Colors.grey[700]
                                          : Colors.black,
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
                                color: isPast
                                    ? Colors.grey.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${data['cost'] ?? 0}€",
                                style: TextStyle(
                                  color: isPast ? Colors.grey : Colors.green,
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

                        // Απόκρυψη κουμπιών αν το ραντεβού έχει περάσει
                        if (!isPast) ...[
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
                        ] else ...[
                          const SizedBox(height: 12),
                          // Χρησιμοποιούμε τη μετάφραση αντί για στατικό κείμενο
                          Text(
                            t.pastAppointment,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
