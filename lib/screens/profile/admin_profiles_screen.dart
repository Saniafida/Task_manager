// lib/screens/profile/admin_profiles_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_card.dart'; // We'll create this shared widget

class AdminProfilesScreen extends StatefulWidget {
  const AdminProfilesScreen({super.key});

  @override
  State<AdminProfilesScreen> createState() => _AdminProfilesScreenState();
}

class _AdminProfilesScreenState extends State<AdminProfilesScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _admins = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdmins();
  }

  Future<void> _fetchAdmins() async {
    setState(() => _loading = true);
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('role', 'admin');

      setState(() {
        _admins = List<Map<String, dynamic>>.from(response);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profiles'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _admins.isEmpty
          ? const Center(child: Text('No admin profiles found'))
          : RefreshIndicator(
        onRefresh: _fetchAdmins,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _admins.length,
          itemBuilder: (context, index) {
            return ProfileCard(
              profile: _admins[index],
              index: index + 1,
            );
          },
        ),
      ),
    );
  }
}