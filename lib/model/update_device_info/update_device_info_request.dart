class UpdateDeviceInfoRequest {
  String name;
  String gender;
  int age;
  int weight;
  int height;
  String avt;
  String nickname;

  UpdateDeviceInfoRequest(this.name, this.gender, this.age, this.weight,
      this.height, this.avt, this.nickname);

  Map<String, dynamic> toBodyRequest() => {
        'name': name,
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
        'avt': avt,
        'nickname': nickname,
      };
}
