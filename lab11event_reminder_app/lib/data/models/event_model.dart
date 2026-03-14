class Event {
  final int? id;
  final String title;
  final String? description;
  final int categoryId;
  final String eventDate;
  final String startTime;
  final String endTime;
  final String status; // Pending, In Progress, Completed, Cancelled
  final int priority; // 1: Low, 2: Normal, 3: High

  Event({
    this.id, required this.title, this.description, required this.categoryId,
    required this.eventDate, required this.startTime, required this.endTime,
    this.status = 'Pending', this.priority = 2,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, 'title': title, 'description': description,
      'category_id': categoryId, 'event_date': eventDate,
      'start_time': startTime, 'end_time': endTime,
      'status': status, 'priority': priority,
    };
  }
}