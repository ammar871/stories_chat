class CountryCode {
  late String name;
  late String dialCode;
  late String code;

  CountryCode(
      {required this.name, required this.dialCode, required this.code});

  CountryCode.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dialCode = json['dial_code'];
    code = json['code'];
  }


}
