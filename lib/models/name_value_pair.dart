class NameValuePair {
  String name;
  String value;

  NameValuePair({
    required this.name,
    required this.value,
  });

  factory NameValuePair.fromJson(Map<String, dynamic> json) {
    return NameValuePair(
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}