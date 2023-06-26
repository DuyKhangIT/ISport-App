class UpdateAvtAccountInfoRequest {
  String avt;

  UpdateAvtAccountInfoRequest(this.avt);

  Map<String, dynamic> toBodyRequest() => {
        'avt': avt,
      };
}
