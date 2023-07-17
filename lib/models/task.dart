class Tasks {
  final String id;
  final String title;
  final String note;
  final DateTime? dueDate;
  final bool complated;
  final double latitude;
  final double longitude;

  Tasks({
    required this.id,
    required this.title,
    this.note = '',
    this.dueDate,
    this.complated = false,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  Tasks copyWith(
      {String? id,
      String? title,
      String? note,
      DateTime? dueDate,
      bool? complated,
      double? latitude,
      double? longitude}) {
    if (dueDate != null) {
      if (dueDate.compareTo(DateTime(0)) == 0) {
        dueDate = null;
      }
    } else {
      dueDate = this.dueDate;
    }
    return Tasks(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: dueDate,
      complated: complated ?? this.complated,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
