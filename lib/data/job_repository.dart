import 'models.dart';

/// Local catalog. Replace this boundary with an API-backed repository later.
class JobRepository {
  static const jobs = [
    Job(
      'medium',
      'Product Manager',
      'Medium',
      'Salt Lake City, USA',
      'Full-Time',
      6500,
      'Technology',
    ),
    Job(
      'spotify',
      'Senior Brand Designer',
      'Spotify',
      'Stockholm, Sweden',
      'Full-Time',
      7500,
      'Music',
    ),
    Job(
      'google',
      'Marketing Specialist',
      'Google',
      'California, USA',
      'Full-Time',
      5200,
      'Technology',
      age: 0,
    ),
    Job(
      'twitter',
      'Brand Strategist',
      'Twitter',
      'San Francisco, USA',
      'Part-Time',
      4200,
      'Technology',
      age: 2,
    ),
    Job(
      'pinterest',
      'UX Designer',
      'Pinterest',
      'California, USA',
      'Full-Time',
      6000,
      'Technology',
      age: 4,
    ),
    Job(
      'twitch',
      'Product Manager',
      'Twitch',
      'Remote/Worldwide',
      'Part-Time',
      5500,
      'Technology',
      mode: 'Remote',
      age: 12,
    ),
    Job(
      'spotify-product',
      'Sr. Product Designer',
      'Spotify',
      'Stockholm, Sweden',
      'Freelance',
      12000,
      'Music',
      age: 16,
    ),
    Job(
      'finance',
      'Financial Analyst',
      'Google',
      'New York, USA',
      'Full-Time',
      5800,
      'Finance',
      age: 8,
    ),
    Job(
      'food',
      'Brand Designer',
      'Pinterest',
      'Jakarta, Indonesia',
      'Internship',
      1500,
      'Food & Drink',
      age: 6,
    ),
  ];
  Job byId(String id) => jobs.firstWhere((job) => job.id == id);
  List<Job> search(String query, JobFilter filter) {
    final words = query.toLowerCase().trim();
    final maxAge = switch (filter.period) {
      'Past 24 Hours' => 0,
      'Past 7 Days' => 7,
      'Past Month' => 30,
      _ => 999,
    };
    final result = jobs
        .where(
          (job) =>
              '${job.title} ${job.company} ${job.category}'
                  .toLowerCase()
                  .contains(words) &&
              (filter.type == 'All' || job.type == filter.type) &&
              (filter.category.isEmpty || job.category == filter.category) &&
              (filter.location == 'Anywhere' ||
                  (filter.location == 'United States'
                      ? job.location.contains('USA')
                      : job.location.contains(filter.location))) &&
              job.age <= maxAge,
        )
        .toList();
    if (filter.recent) result.sort((a, b) => a.age.compareTo(b.age));
    return result;
  }
}
