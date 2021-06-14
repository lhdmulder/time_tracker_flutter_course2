import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course2/common_widgets/date_time_picker.dart';
import 'package:time_tracker_flutter_course2/app/home/job_entries/format.dart';
import 'package:time_tracker_flutter_course2/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course2/app/home/models/job.dart';
import 'package:time_tracker_flutter_course2/common_widgets/date_time_picker_ct.dart';
import 'package:time_tracker_flutter_course2/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course2/services/database.dart';

class EntryPageCT extends StatefulWidget {
  const EntryPageCT({@required this.database, @required this.job, this.entry});
  final Database database;
  final Job job;
  final Entry entry;

  static Future<void> show(
      {BuildContext context, Database database, Job job, Entry entry}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EntryPageCT(database: database, job: job, entry: entry),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EntryPageCTState();
}

class _EntryPageCTState extends State<EntryPageCT> {
  DateTime _startDateTime;
  DateTime _endDateTime;
  String _comment;

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDateTime = start;

    final end = widget.entry?.end ?? DateTime.now();
    _endDateTime = end;

    _comment = widget.entry?.comment ?? '';
  }

  Entry _entryFromState() {
    final start = _startDateTime;
    final end = _endDateTime;
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
      id: id,
      jobId: widget.job.id,
      start: start,
      end: end,
      comment: _comment,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database.setEntry(entry);
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job.name),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.entry != null ? 'Update' : 'Create',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildStartDate(),
              _buildEndDate(),
              SizedBox(height: 8.0),
              _buildDuration(),
              SizedBox(height: 8.0),
              _buildComment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePickerCT(
      labelText: 'Start',
      selectedDateTime: _startDateTime,
      onSelectedDateTime: (datetime) => setState(() => _startDateTime = datetime),
    );
  }

  Widget _buildEndDate() {
    return DateTimePickerCT(
      labelText: 'End',
      selectedDateTime: _endDateTime,
      onSelectedDateTime: (datetime) => setState(() => _endDateTime = datetime),
    );
  }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    final durationFormatted = Format.hours(currentEntry.durationInHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Duration: $durationFormatted',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }
}
