import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/job_repository.dart';
import '../data/models.dart';

class AppState extends ChangeNotifier {
  AppState({this.preferences});
  final SharedPreferences? preferences;
  final repository = JobRepository();
  bool signedIn = false,
      notifications = true,
      textMessage = false,
      authenticator = false;
  String name = 'Matt Murdock',
      email = 'mattmurdock@gmail.com',
      phone = '+62 85444888222';
  String address = 'Malang, Indonesia', language = 'English (US)';
  String about =
      "I'm a UI designer with well-developed skills and experience in wireframes, high fidelity design and style guides. I have worked in the creative industry since 2019.";
  String workTitle = 'User Interface Designer', workCompany = 'Spotify';
  String institution = 'Universitas Negeri Malang', degree = 'Bachelor of Art';
  String level = 'Intermediate', startDate = '2022-05-31', endDate = 'Present';
  final skills = <String>{'Design', 'Layout', 'Marketing', 'Painting'};
  final categories = <String>{'Design'};
  final saved = <String>{};
  List<Application> applications = [
    Application('google', 0, DateTime.now().subtract(const Duration(days: 1))),
    Application('twitch', 1, DateTime.now().subtract(const Duration(days: 12))),
    Application(
      'spotify-product',
      2,
      DateTime.now().subtract(const Duration(days: 16)),
    ),
    Application(
      'pinterest',
      0,
      DateTime.now().subtract(const Duration(days: 20)),
      rejected: true,
    ),
  ];
  static Future<AppState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final state = AppState(preferences: prefs);
    final raw = prefs.getString('carijob.v1');
    if (raw != null) {
      try {
        state.restore(jsonDecode(raw) as Map<String, dynamic>);
      } on FormatException {
        await prefs.remove('carijob.v1');
      } on TypeError {
        await prefs.remove('carijob.v1');
      }
    }
    return state;
  }

  void restore(Map<String, dynamic> data) {
    signedIn = data['signedIn'] as bool;
    final p = Map<String, String>.from(data['profile'] as Map);
    name = p['Name']!;
    email = p['Email']!;
    phone = p['Phone Number']!;
    address = p['Address']!;
    about = p['About Me']!;
    workTitle = p['Job Title']!;
    workCompany = p['Company Name']!;
    institution = p['Institution']!;
    degree = p['Degree']!;
    level = p['Job Level'] ?? level;
    startDate = p['Start Date'] ?? startDate;
    endDate = p['End Date'] ?? endDate;
    language = data['language'] as String;
    notifications = data['notifications'] as bool;
    textMessage = data['textMessage'] as bool? ?? false;
    authenticator = data['authenticator'] as bool? ?? false;
    saved.addAll(List<String>.from(data['saved'] as List));
    skills
      ..clear()
      ..addAll(List<String>.from(data['skills'] as List));
    categories
      ..clear()
      ..addAll(List<String>.from(data['categories'] as List));
    applications = (data['applications'] as List)
        .map((e) => Application.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Map<String, String> get profile => {
    'Name': name,
    'Email': email,
    'Phone Number': phone,
    'Address': address,
    'About Me': about,
    'Job Title': workTitle,
    'Company Name': workCompany,
    'Institution': institution,
    'Degree': degree,
    'Job Level': level,
    'Start Date': startDate,
    'End Date': endDate,
  };
  Future<void> save() async {
    notifyListeners();
    await preferences?.setString(
      'carijob.v1',
      jsonEncode({
        'signedIn': signedIn,
        'profile': profile,
        'language': language,
        'notifications': notifications,
        'textMessage': textMessage,
        'authenticator': authenticator,
        'saved': saved.toList(),
        'skills': skills.toList(),
        'categories': categories.toList(),
        'applications': applications.map((a) => a.toJson()).toList(),
      }),
    );
  }

  void updateProfile(Map<String, String> v) {
    name = v['Name'] ?? name;
    email = v['Email'] ?? email;
    phone = v['Phone Number'] ?? phone;
    address = v['Address'] ?? address;
    about = v['About Me'] ?? about;
    workTitle = v['Job Title'] ?? workTitle;
    workCompany = v['Company Name'] ?? workCompany;
    institution = v['Institution'] ?? institution;
    degree = v['Degree'] ?? degree;
    level = v['Job Level'] ?? level;
    startDate = v['Start Date'] ?? startDate;
    endDate = v['End Date'] ?? endDate;
    save();
  }

  void toggleSaved(String id) {
    saved.contains(id) ? saved.remove(id) : saved.add(id);
    save();
  }

  bool hasApplied(String id) => applications.any((a) => a.jobId == id);
  Future<void> apply(
    String id, {
    String email = '',
    String phone = '',
    String resumeName = '',
    String coverLetter = '',
  }) async {
    if (hasApplied(id)) return;
    applications.insert(
      0,
      Application(
        id,
        0,
        DateTime.now(),
        email: email,
        phone: phone,
        resumeName: resumeName,
        coverLetter: coverLetter,
      ),
    );
    await save();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
