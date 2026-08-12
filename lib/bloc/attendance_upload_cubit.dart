import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'attendance_upload_state.dart';

class AttendanceUploadCubit extends Cubit<AttendanceUploadState> {
  AttendanceUploadCubit({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      super(const AttendanceUploadInitial());

  final FirebaseFirestore _firestore;

  Future<void> uploadAttendance({
    required bool livenessPassed,
    required int photoMatchedScore,
    required bool status,
    required String studentEmail,
    required String studentName,
    required String userId,
    DateTime? date,
  }) async {
    emit(const AttendanceUploadLoading());

    final validationMessage = _validate(
      photoMatchedScore: photoMatchedScore,
      studentEmail: studentEmail,
      studentName: studentName,
      userId: userId,
    );

    if (validationMessage != null) {
      emit(AttendanceUploadFailure(validationMessage));
      return;
    }

    try {
      final document = await _firestore.collection('attendance').add({
        'date': Timestamp.fromDate(date ?? DateTime.now()),
        'livenessPassed': livenessPassed,
        'photoMatchedScore': photoMatchedScore,
        'status': status,
        'studentEmail': studentEmail.trim(),
        'studentName': studentName.trim(),
        'userID': userId.trim(),
      });

      emit(AttendanceUploadSuccess(document.id));
    } on FirebaseException catch (error) {
      emit(
        AttendanceUploadFailure(
          error.message ?? 'Could not upload attendance.',
        ),
      );
    } catch (_) {
      emit(
        const AttendanceUploadFailure(
          'An unexpected error occurred while uploading attendance.',
        ),
      );
    }
  }

  void reset() => emit(const AttendanceUploadInitial());
}

String? _validate({
  required int photoMatchedScore,
  required String studentEmail,
  required String studentName,
  required String userId,
}) {
  if (photoMatchedScore < 0 || photoMatchedScore > 100) {
    return 'Photo match score must be between 0 and 100.';
  }
  if (studentEmail.trim().isEmpty || !studentEmail.contains('@')) {
    return 'Enter a valid student email.';
  }
  if (studentName.trim().isEmpty) {
    return 'Student name is required.';
  }
  if (userId.trim().isEmpty) {
    return 'User ID is required.';
  }
  return null;
}