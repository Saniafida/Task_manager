// lib/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _profiles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllProfiles();
  }

  Future<void> _fetchAllProfiles() async {
    setState(() => _loading = true);

    try {
      final response = await _supabase.from('profiles').select();

      setState(() {
        _profiles = List<Map<String, dynamic>>.from(response);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load profiles')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Separate admins and students
    final adminProfiles = _profiles.where((p) => p['role'] == 'admin').toList();
    final studentProfiles = _profiles.where((p) => p['role'] == 'student').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Profiles'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _profiles.isEmpty
          ? const Center(
        child: Text(
          'No entries found in the profiles table',
          style: TextStyle(fontSize: 16),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchAllProfiles,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // Admins Section
            const SectionHeader(title: 'Admins'),
            if (adminProfiles.isEmpty)
              const EmptySectionMessage(message: 'No admins found')
            else
              ...adminProfiles.asMap().entries.map((entry) {
                int idx = entry.key;
                var profile = entry.value;
                return ProfileCard(profile: profile, index: idx + 1);
              }),

            const SizedBox(height: 24),

            // Students Section
            const SectionHeader(title: 'Students'),
            if (studentProfiles.isEmpty)
              const EmptySectionMessage(message: 'No students found')
            else
              ...studentProfiles.asMap().entries.map((entry) {
                int idx = entry.key;
                var profile = entry.value;
                return ProfileCard(profile: profile, index: idx + 1);
              }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Reusable Widgets for Clean Code

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}

class EmptySectionMessage extends StatelessWidget {
  final String message;
  const EmptySectionMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final int index;

  const ProfileCard({super.key, required this.profile, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${profile['role']?.toString().toUpperCase() ?? 'USER'} #${index}',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: profile['role'] == 'admin' ? Colors.deepOrange : Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            ...profile.entries.map((entry) {
              // Optionally hide sensitive fields like passwords if exist
              if (entry.key == 'password') return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '${entry.key}:',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value?.toString() ?? 'null',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}