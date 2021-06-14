import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course2/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course2/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course2/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_flutter_course2/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course2/app/home/models/job.dart';
import 'package:time_tracker_flutter_course2/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course2/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course2/services/auth.dart';
import 'package:time_tracker_flutter_course2/services/database.dart';


class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      await Provider.of<AuthBase>(context, listen: false).signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout');
    if (didRequestSignOut) {
      _signOut(context);
    }
  }

  Future<void> _delete(BuildContext context, Job job) async{
try {
  final database = Provider.of<Database>(context, listen: false);
  await database.deleteJob(job);
} on FirebaseException catch (e) {
showExceptionAlertDialog(context, title: 'Delete failed', exception: e);
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EditJobPage.show(context, database: Provider.of<Database>(context, listen: false)),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context,job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(
                context,
               job,
              ),
            ),
          ),
        );
      },
    );
  }


}
