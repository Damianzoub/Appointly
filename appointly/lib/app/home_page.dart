import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointly/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
            child: Text(
              t.yesCancel,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _db.collection('appointments').doc(docId).update({
        'status': 'cancelled',
      });
    }
  }

  bool _isSameDay(DateTime a, DateTime b){
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _editAppointment(String docId, DateTime currentDate) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: currentDate.isAfter(DateTime.now()) ? currentDate : DateTime.now(),
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

    final Query query = _db
        .collection('appointments')
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: 'active')
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .orderBy('dateTime');

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
      ),
      body: uid == null
          ? _buildEmptyState(context, t) // ή φτιάξε δικό σου "not logged in" state
          : StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return _buildEmptyState(context, t);
                }

                final now = DateTime.now();
                final todaysDocs = <QueryDocumentSnapshot>[];
                final upcomingDocs = <QueryDocumentSnapshot>[];

                for (final d in docs){
                  final data = d.data() as Map<String,dynamic>;
                  final ts = data['dateTime'] as Timestamp?;
                  if (ts == null) continue;

                  final dt = ts.toDate();
                  if (_isSameDay(dt,now)){
                    todaysDocs.add(d);
                  } else {
                    upcomingDocs.add(d);
                  }
                }
                //added the sections for today and upcoming and history
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    //Today section (if exists)
                  if (todaysDocs.isNotEmpty) ...[
                    _buildSectionTitle(t.todayAppointments),
                    const SizedBox(height:12),
                    ...todaysDocs.map((doc){
                      final data = doc.data() as Map<String,dynamic>;
                      final date = (data['dateTime'] as Timestamp).toDate();
                      return _buildAppointmentCard(context: context, t: t, id: doc.id, data: data, date: date);
                    }),
                    const SizedBox(height:24)
                  ],
                  //Upcoming section
                  _buildSectionTitle(t.upcomingAppointments),
                  const SizedBox(height:12),
                  ...upcomingDocs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final date = (data['dateTime'] as Timestamp).toDate();
                    return _buildAppointmentCard(context: context, t: t, id: doc.id, data: data, date: date);
                  }),
                  const SizedBox(height:16),
                  //See all history button
                  _buildHistoryButton(context, t)
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              t.appointmentsEmptySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(left:4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color:Colors.indigo
        )
      ),
    );
  }

  Widget _buildHistoryButton(BuildContext context,AppLocalizations t){
    return SizedBox(width:double.infinity,
    child: OutlinedButton.icon(onPressed: ()=> Navigator.pushNamed(context,'/appointments_history'),
    icon: const Icon(Icons.history_rounded),
    label: Text(t.seeAllHistory),
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(vertical: 14)
    ),));
  }

  Widget _buildAppointmentCard({
    required BuildContext context,
    required AppLocalizations t,
    required String id,
    required Map<String, dynamic> data,
    required DateTime date,
  }) {
    final serviceName = (data['serviceName'] ?? '').toString();
    final providerName = (data['providerName'] ?? '').toString();

    // Locale-aware date formatting
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
                            child: Text(
                              serviceName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
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
                              t.appointmentStatusActive,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 4),
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
