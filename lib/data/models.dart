class Job {
  const Job(
    this.id,
    this.title,
    this.company,
    this.location,
    this.type,
    this.salary,
    this.category, {
    this.mode = 'Hybrid',
    this.age = 1,
  });
  final String id, title, company, location, type, category, mode;
  final int salary, age;
  String get logo => company.toLowerCase();
  String get salaryLabel => '\$$salary/month';
}

class Application {
  const Application(
    this.jobId,
    this.stage,
    this.appliedAt, {
    this.rejected = false,
    this.email = '',
    this.phone = '',
    this.resumeName = '',
    this.coverLetter = '',
  });
  final String jobId;
  final int stage;
  final DateTime appliedAt;
  final bool rejected;
  final String email, phone, resumeName, coverLetter;
  Map<String, dynamic> toJson() => {
    'jobId': jobId,
    'stage': stage,
    'appliedAt': appliedAt.toIso8601String(),
    'rejected': rejected,
    'email': email,
    'phone': phone,
    'resumeName': resumeName,
    'coverLetter': coverLetter,
  };
  factory Application.fromJson(Map<String, dynamic> json) => Application(
    json['jobId'] as String,
    json['stage'] as int,
    DateTime.parse(json['appliedAt'] as String),
    rejected: json['rejected'] as bool,
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    resumeName: json['resumeName'] as String? ?? '',
    coverLetter: json['coverLetter'] as String? ?? '',
  );
}

class JobFilter {
  const JobFilter({
    this.type = 'All',
    this.location = 'Anywhere',
    this.category = '',
    this.period = 'All Time',
    this.recent = true,
  });
  final String type, location, category, period;
  final bool recent;
}
