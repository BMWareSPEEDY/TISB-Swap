import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eco_tisb/models/user_profile.dart';
import 'package:eco_tisb/models/item.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  // --- Authentication ---
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String startFullName
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': startFullName},
    );

    // Create profile manually if session exists (Email confirmation OFF)
    // or if the user was created (Email confirmation ON - profile created on first login)
    if (response.user != null && response.session != null) {
      await createProfile(email, startFullName);
    }
    return response;
  }

  Future<void> createProfile(String email, String fullName) async {
    await _client.from('profiles').upsert({
      'email': email,
      'full_name': fullName,
      'points': 0,
      'co2_saved': 0.0,
    });
  }

  Future<AuthResponse> signIn({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Ensure profile exists on login
    if (response.user != null) {
      final profile = await getUserProfile(email);
      if (profile == null) {
        await createProfile(email, response.user!.userMetadata?['full_name'] ?? 'User');
      }
    }
    return response;
  }

  Future<void> signOut() async => await _client.auth.signOut();

  // --- Profiles ---
  Future<UserProfile?> getUserProfile(String email) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('email', email) // Using email as the lookup key
          .maybeSingle();

      if (response == null) return null;
      return UserProfile.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching seller profile: $e');
      return null;
    }
  }

  // --- Items ---
  Future<List<Item>> getAvailableItems() async {
    try {
      final response = await _client
          .from('items')
          .select()
          .eq('is_swapped', false)
          .order('created_at', ascending: false);

      // DEBUG: Print the raw response to your console
      debugPrint('RAW DATABASE RESPONSE: $response');

      return (response as List).map((item) => Item.fromJson(item)).toList();
    } catch (e) {
      debugPrint('ERROR IN getAvailableItems: $e');
      return [];
    }
  }

  Future<List<Item>> getUserListings(String email) async {
    final response = await _client
        .from('items')
        .select()
        .eq('seller_email', email as Object)
        .order('created_at', ascending: false);
    return (response as List).map((item) => Item.fromJson(item)).toList();
  }

  Future<Item?> createItem(Item item) async {
    final data = item.toJson();
    data.remove('id'); // Let DB generate UUID
    data.remove('created_at'); // Let DB generate timestamp

    final response = await _client.from('items').insert(data).select().single();
    return Item.fromJson(response);
  }
  Future<String?> uploadItemImage(File imageFile) async {
    try {
      // 1. Create a unique filename
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${p.extension(imageFile.path)}';
      final path = 'public/$fileName';

      // 2. Upload to the 'item_images' bucket
      await _client.storage.from('item_images').upload(path, imageFile);

      // 3. Get the Public URL
      final String publicUrl = _client.storage.from('item_images').getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      debugPrint('Upload Error: $e');
      return null;
    }
  }
}