class License {
  final title;

  License(this.title);
}

class DrivingLicenese extends License {
  final title;

  DrivingLicenese(this.title) : super(title);
}

class LearningLicenese extends License {
  final title;

  LearningLicenese(this.title) : super(null);
}
