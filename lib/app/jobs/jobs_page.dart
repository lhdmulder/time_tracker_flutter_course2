import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course2/app/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course2/app/jobs/job_list_tile.dart';
import 'package:time_tracker_flutter_course2/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course2/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course2/services/auth.dart';
import 'package:time_tracker_flutter_course2/services/database.dart';

import '../home/models/job.dart';

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
        onPressed: () => EditJobPage.show(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs
              .map((job) => JobListTile(
                    job: job,
                    onTap: () => EditJobPage.show(
                      context,
                      job: job,
                    ),
                  ))
              .toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Some error occurred'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
