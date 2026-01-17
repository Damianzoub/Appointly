import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appointly/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
class AppointmentsHistoryPage extends StatefulWidget {
  const AppointmentsHistoryPage({super.key});

  @override
  State<AppointmentsHistoryPage> createState() => _AppointmentsHistoryPageState();
}

class _AppointmentsHistoryPageState extends State<AppointmentsHistoryPage>{
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  int tabIndex = 0; // 0 = upcoming , 1 = completed

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context){
    final t = AppLocalizations.of(context)!;
    final user = _auth.currentUser;

    if (user == null){
      return Scaffold(
        appBar: AppBar(title: Text(t.appointmentHistory),),body: Center(child: Text(t.notLoggedIn)),
      );
    }
    final uid = user.uid;
    final now = DateTime.now();

    // Query for appointments
    
    final query = _db
    .collection("appointments")
    .where("userId",isEqualTo: uid)
    .orderBy("dateTime",descending: true);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(t.appointmentHistory,style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children:[
          const SizedBox(height: 12,),
          //Toggle buttons
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16),child: _buildToggle(t),),

          const SizedBox(height:12),
          //content
          Expanded(child: StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder: (context,snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data?.docs ?? [];

              //Filter based on selected tab
              final filtered = docs.where((d) {
                  final data = d.data() as Map<String,dynamic>;
                  final status = (data['status'] ?? 'upcoming') as String;
                  final ts = data['dateTime'] as Timestamp;
                  if (ts == null) {return false;}

                  final dt = ts.toDate();
                  if(tabIndex ==0){
                    return (status == 'upcoming' && (dt.isAfter(now) || _isSameDay(dt, now)));
                  } else {
                    return (status == 'completed' || dt.isBefore(now) && !_isSameDay(dt, now));
                  }
              }).toList();

              if (filtered.isEmpty){
                return Center(
                  child: Padding(padding: const EdgeInsets.all(24), child: Text(
                    t.noAppointments, style: TextStyle(color: Colors.grey[700])
                  ),),
                );
              }

              return ListView.builder(padding: const EdgeInsets.all(16),itemCount: filtered.length,itemBuilder: (context,i){
                final doc = filtered[i];
                final data = doc.data() as Map<String,dynamic>;
                final ts = data['dateTime'] as Timestamp;
                final date = ts.toDate();
                return _appointmentTile(context,t,data,date);
              });
            },
          ))
        ]
      )
    );
  }

  Widget _buildToggle(AppLocalizations t){
  return Container(padding: const EdgeInsets.all(6),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0,4)
      )
    ]
  ),
  child: Row(
    children: [
      Expanded(child: _toggleChip(
        isSelected: tabIndex ==0,
        label: t.upcomingTab,
        icon: Icons.schedule_rounded,
        onTap: ()=> setState(()=> tabIndex =0)
      )),
      const SizedBox(width:8,),
      Expanded(
        child: _toggleChip(
          isSelected: tabIndex ==1,
          label: t.completedTab,
          icon: Icons.check_circle_rounded,
          onTap: ()=> setState(()=> tabIndex =1)
        )
      )
    ],
  )
  );
}

Widget _toggleChip({
  required bool isSelected,
  required String label,
  required IconData icon,
  required VoidCallback onTap
}){
  return InkWell(
    borderRadius:  BorderRadius.circular(14),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.indigo.withOpacity(0.12) :Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,size:18,color:isSelected ? Colors.indigo : Colors.grey[600]),
          const SizedBox(width:8),
          Flexible(child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.indigo : Colors.grey[600]
            ),
          ))
        ],
      )
    )
  );
}

Widget _appointmentTile(
  BuildContext context,
  AppLocalizations t,
  Map<String,dynamic> data,
  DateTime date
){
  final localeTag = Localizations.localeOf(context).toLanguageTag();
  final formatted = DateFormat.yMMMMd(localeTag).add_jm().format(date);

  final service = (data['serviceName'] ?? "") as String;
  final provider = (data['providerName'] ?? "") as String;
  final status = (data['status'] ?? "upcoming") as String;
  final isCompleted = status == "completed";


  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0,4)
        )
      ]
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: isCompleted ? Colors.green.withOpacity(0.1) : Colors.indigo.withOpacity(0.1),
        child: Icon(
          isCompleted ? Icons.check_rounded : Icons.event_rounded,
          color: isCompleted ? Colors.green :Colors.indigo,
        )
      ),
      title: Text(
        service, style: const TextStyle(fontWeight: FontWeight.w700,overflow: TextOverflow.ellipsis),
        
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height:4),
          Text(provider,overflow: TextOverflow.ellipsis,),
          const SizedBox(height:2),
          Text(formatted,style: TextStyle(color: Colors.grey[700]),)
        ],
      ),
    )
  );
}
}