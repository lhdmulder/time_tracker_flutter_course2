import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course2/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job, this.onTap}) : super(key: key);

  final Job job;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      subtitle: Text('\$ ${job.ratePerHour.toString()}'),
      onTap: onTap,
trailing: Icon(Icons.chevron_right),
    );
  }
}