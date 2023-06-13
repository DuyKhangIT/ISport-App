class DataResponseRegister {
  int userId = 0;

  DataResponseRegister(
    this.userId,
  );
  DataResponseRegister.buildDefault();
  factory DataResponseRegister.fromJson(Map<String, dynamic> json) {
    return DataResponseRegister(
      json['userId'],
    );
  }
}
