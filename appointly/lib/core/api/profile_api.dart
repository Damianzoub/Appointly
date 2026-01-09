import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';
import 'api_exceptions.dart';

class ProfileApi {
  final SupabaseClient _sb = SB.client;


  // Create User
  Future<void> createProfile({
    required String userID,
    required String username,
    required String name,
    required String surname,
    DateTime? dob
  }) async{
    try{
      await _sb.from("profile").insert({
        'id':userID,
        'username':username,
        'name':name,
        'surname':surname,
        'dob':dob?.toIso8601String().substring(0,10)
      });
    }catch(_){
      throw ApiException("Failed to create profile");
    }
  }


  // Update User
  Future<void> updateMyProfile({
    String? name,
    String? surname,
    String? username,
    String? password,
    String? email,
  }) async{
    final uid = _sb.auth.currentUser?.id;
    if (uid==null) throw ApiException("Not logged In");

    final patch = <String, dynamic>{};
    if (username != null){
      final exists = await _sb
      .from('profiles')
      .select('id')
      .eq('username',username)
      .neq('id', uid)
      .maybeSingle();

      if (exists != null){
        throw ApiException("Username already exists");
      }
    }

    if (email !=null){
      final res = await _sb.rpc('email_exists',params: {'email_input':email});
      if (res == true){
        throw ApiException("Email already exists");
      }
    }

    if (name != null) patch['name'] = name;
    if (surname != null) patch['surname'] = surname;
    if (email != null) patch['email'] =email;
    if (username != null) patch['username']= username;
    
    if(patch.isNotEmpty){
      try{
        await _sb.from('profiles').update(patch).eq('id',uid);
      }catch(_){
        throw ApiException("Failed to update Profile");
      }
    }
  }


  //Read User
  Future<Map<String,dynamic>> getMyProfile() async {
    final uid = _sb.auth.currentUser?.id;
    if (uid == null) throw ApiException("Not logged In");

    try{
      return await _sb.from("profiles").select("*").eq('id',uid).single();
    }catch(_){
      throw ApiException("Failed to load profile");
    }
  }


  //Delete User
  Future<void> deleteMyProfile() async{
    final uid = _sb.auth.currentUser?.id;
    if (uid == null) throw ApiException("Not logged in");

    try{
      await _sb.from("profiles").delete().eq("id",uid);
      await _sb.auth.signOut();
    }catch(_){
      throw ApiException("Failed to delete profile");
    }
  }
}