class UpdatePasswordAccountInfoRequest {
  String newPassword;
  String oldPassword;

  UpdatePasswordAccountInfoRequest(this.newPassword, this.oldPassword);

  Map<String, dynamic> toBodyRequest() => {
        'password': newPassword,
        'oldPassword': oldPassword,
      };
}
