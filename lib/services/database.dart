
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course2/app/home/models/job.dart';
import 'package:time_tracker_flutter_course2/services/api-path.dart';
import 'package:time_tracker_flutter_course2/services/firestore_service.dart';
import 'package:uuid/uuid.dart';


abstract class Database {
  Future<void> setJob(Job job);

  Stream<List<Job>> jobsStream();
}
String documentId;
class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

final _service= FirestoreService.instance;


  Future<void> setJob(Job job) {
    final uuid = Uuid();
    _service.setData(path: ApiPath.job(uid, job.id), data: job.toMap());
  }


  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: ApiPath.jobs(uid), builder: (data, documentId) => Job.fromMap(data, documentId));



}
