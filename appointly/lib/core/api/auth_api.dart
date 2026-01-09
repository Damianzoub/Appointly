import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';
import 'api_exceptions.dart';

class AuthApi{
  final SupabaseClient _sb = SB.client;

  Future<void> login({
    required String email,
    required String password
  }) async {
    try{
        await _sb.auth.signInWithPassword(email:email,password: password);
    }on AuthException catch(e){
      throw ApiException(e.message);
    }
  }

  Future<void> logout() async{
    await _sb.auth.signOut();
  }

  Future<void> signUpAuthOnly({
    required String email,
    required String password
  }) async{
    try{
      await _sb.auth.signUp(email:email,password: password);
    }on AuthException catch(e){
      throw ApiException(e.message);
    }
  }

  String? get currentUserID => _sb.auth.currentUser?.id;
  bool get isLoggedIn => _sb.auth.currentUser != null;
}