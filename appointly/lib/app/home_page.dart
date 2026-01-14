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

  // Μέθοδος για την ακύρωση ραντεβού
  Future<void> _cancelAppointment(String docId) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ακύρωση Ραντεβού"),
        content: const Text(
          "Είστε σίγουροι ότι θέλετε να ακυρώσετε αυτό το ραντεβού;",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Όχι"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Ναι, Ακύρωση",
              style: TextStyle(color: Colors.red),
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

  // Μέθοδος για την επεξεργασία ημερομηνίας ραντεβού
  Future<void> _editAppointment(String docId, DateTime currentDate) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (newDate != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate),
      );
      if (time != null) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // Ερώτημα στη Firestore για όλα τα ενεργά ραντεβού του χρήστη
    Query query = _db
        .collection('appointments')
        .where('userId', isEqualTo: _auth.currentUser?.uid)
        .where('status', isEqualTo: 'active')
        .orderBy('dateTime'); // Προαιρετική ταξινόμηση βάσει ημερομηνίας

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
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          // Εμφάνιση Empty State αν δεν υπάρχουν ραντεβού
          if (docs.isEmpty) {
            return _buildEmptyState(context, t);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final date = (data['dateTime'] as Timestamp).toDate();
              return _buildAppointmentCard(docs[index].id, data, date);
            },
          );
        },
      ),
    );
  }

  // Μοντέρνο Empty State χωρίς το κουμπί
  Widget _buildEmptyState(BuildContext context, dynamic t) {
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
              "Δεν υπάρχουν ραντεβού",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Φαίνεται πως δεν έχετε προγραμματίσει κάποια επίσκεψη. Ξεκινήστε κάνοντας μια νέα κράτηση!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Κάρτα εμφάνισης ραντεβού
  Widget _buildAppointmentCard(
    String id,
    Map<String, dynamic> data,
    DateTime date,
  ) {
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
                          Text(
                            data['serviceName'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                            child: const Text(
                              "Active",
                              style: TextStyle(
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
                          Text(
                            data['providerName'],
                            style: const TextStyle(color: Colors.grey),
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
                            DateFormat('dd MMM yyyy • HH:mm').format(date),
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
                            label: const Text("Αλλαγή"),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => _cancelAppointment(id),
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.red,
                            ),
                            label: const Text(
                              "Ακύρωση",
                              style: TextStyle(color: Colors.red),
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
