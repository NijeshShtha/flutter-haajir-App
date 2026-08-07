sealed class AttendanceUploadState {
  const AttendanceUploadState();
}

final class AttendanceUploadInitial extends AttendanceUploadState {
  const AttendanceUploadInitial();
}

final class AttendanceUploadLoading extends AttendanceUploadState {
  const AttendanceUploadLoading();
}

final class AttendanceUploadSuccess extends AttendanceUploadState {
  const AttendanceUploadSuccess(this.documentId);

  final String documentId;
}

final class AttendanceUploadFailure extends AttendanceUploadState {
  const AttendanceUploadFailure(this.message);

  final String message;
}