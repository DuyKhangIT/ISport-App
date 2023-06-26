class AddDeviceRequest {
  String name;
  int idUser;
  String gender;
  int age;
  int weight;
  int height;
  String date;
  String time;
  String avt;
  String nickname;

  AddDeviceRequest(this.name, this.idUser, this.gender, this.age, this.weight,
      this.height, this.date, this.time, this.avt, this.nickname);

  Map<String, dynamic> toBodyRequest() => {
        'name': name,
        'iduser': idUser,
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
        'date': date,
        'time': time,
        'avt': avt,
        'nickname': nickname,
      };
}
