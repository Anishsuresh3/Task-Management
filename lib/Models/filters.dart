enum Filters {
  all,
  pending,
  completed,
  priority
}

extension FilterExtension on Filters {
  String get filter {
    String filters;
    switch (this) {
      case Filters.pending:
        filters = 'pending';
        break;
      case Filters.completed:
        filters = "completed";
        break;
      case Filters.all:
        filters = "all";
        break;
      case Filters.priority:
        filters = "priority";
        break;
    }
    return filters;
  }
}
