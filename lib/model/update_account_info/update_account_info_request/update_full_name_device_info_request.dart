class UpdateFullNameAccountInfoRequest {
  String fullName;

  UpdateFullNameAccountInfoRequest(this.fullName);

  Map<String, dynamic> toBodyRequest() => {
        'fullname': fullName,
      };
}
