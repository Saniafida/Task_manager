// lib/screens/profile/student_profiles_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_card.dart';

class StudentProfilesScreen extends StatefulWidget {
  const StudentProfilesScreen({super.key});

  @override
  State<StudentProfilesScreen> createState() => _StudentProfilesScreenState();
}

class _StudentProfilesScreenState extends State<StudentProfilesScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _students = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() => _loading = true);
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('role', 'student');

      setState(() {
        _students = List<Map<String, dynamic>>.from(response);
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
        title: const Text('Student Profiles'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
          ? const Center(child: Text('No student profiles found'))
          : RefreshIndicator(
        onRefresh: _fetchStudents,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _students.length,
          itemBuilder: (context, index) {
            return ProfileCard(
              profile: _students[index],
              index: index + 1,
            );
          },
        ),
      ),
    );
  }
}