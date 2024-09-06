class Settings {
  String language = "en";

  Settings({required this.language});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(language: json["language"] ?? "en");
  }

  Map<String, dynamic> toJson() {
    return {"language": language};
  }
}