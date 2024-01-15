enum Filters {
  all,
  Pending,
  Completed,
  VeryImportant,
  Important,
  Medium,
  Low,
}

enum Sort {
  all,
  DeadLine_By_Ascending,
  DeadLine_By_Descending,
  Name_By_Ascending,
  Name_By_Descending,
  Priority_High_to_Low,
  Priority_Low_to_High,
}

extension FilterExtension on Filters {
  String get filter {
    String filters;
    switch (this) {
      case Filters.Pending:
        filters = 'pending';
        break;
      case Filters.Completed:
        filters = "completed";
        break;
      case Filters.all:
        filters = "all";
        break;
      case Filters.VeryImportant:
        filters = "priority Very Important";
        break;
      case Filters.Important:
        filters = "priority Important";
        break;
      case Filters.Medium:
        filters = "priority Medium";
        break;
      case Filters.Low:
        filters = "priority low";
        break;
    }
    return filters;
  }
}
