import '../models/lsa_profile_model.dart';
import '../models/submission_result.dart';


abstract class LSAProfileRepository {
  Future<SubmissionResult> submitProfile(LSAProfileModel profile);
}
