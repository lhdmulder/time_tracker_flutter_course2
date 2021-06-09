
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course2/app/home/models/job.dart';
import 'package:time_tracker_flutter_course2/services/api-path.dart';
import 'package:time_tracker_flutter_course2/services/firestore_service.dart';


abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future <void> deleteJob(Job,job);
}
String documentId;
class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

final _service= FirestoreService.instance;

@override
  Future<void> setJob(Job job) {
    _service.setData(path: ApiPath.job(uid, job.id), data: job.toMap());
  }
  @override
Future <void> deleteJob(Job,job) => _service.deleteData(path: ApiPath.job(uid, job.id));

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: ApiPath.jobs(uid), builder: (data, documentId) => Job.fromMap(data, documentId));



}
