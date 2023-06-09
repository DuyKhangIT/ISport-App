class AddDeviceRequest {
  String name;
  String gender;
  int age;
  int weight;
  int height;
  String date;
  String time;
  String nickname;

  AddDeviceRequest(this.name, this.gender, this.age, this.weight, this.height,
      this.date, this.time, this.nickname);

  Map<String, dynamic> toBodyRequest() => {
        'name': name,
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
        'date': date,
        'time': time,
        'nickname': nickname,
      };
}
