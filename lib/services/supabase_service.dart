import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// A service class to handle Supabase operations
class SupabaseService {
  // Singleton pattern
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Supabase client
  late final SupabaseClient client;
  
  // Initialize Supabase
  Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: 'YOUR_SUPABASE_URL', // Replace with your Supabase URL
        anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your Supabase Anon Key
        debug: kDebugMode,
      );
      
      client = Supabase.instance.client;
      debugPrint('Supabase initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Supabase: $e');
      rethrow;
    }
  }

  // Authentication methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // User methods
  User? get currentUser => client.auth.currentUser;
  
  // Database methods
  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await client
        .from('products')
        .select()
        .order('created_at', ascending: false);
    
    return response;
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    await client.from('products').insert(productData);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> updates) async {
    await client.from('products').update(updates).eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    await client.from('products').delete().eq('id', id);
  }
} 