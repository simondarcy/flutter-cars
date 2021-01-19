class Vendor {
  final String name;
  final String image;
  final Map location;
  final String address;
  final String code;

  Vendor({
    this.name,
    this.image,
    this.location,
    this.address,
    this.code,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      name: json['Vendor']['@CompanyShortName'],
      image:
          "${json['Info']['TPA_Extensions']['VendorPictureURL']['#text']}?output=auto&w=84&q=80&dpr=2",
      location: {
        'lat': double.parse(json['Info']['LocationDetails']['Address']
                ['@Remark']
            .split(',')[0]),
        'lon': double.parse(json['Info']['LocationDetails']['Address']
                ['@Remark']
            .split(',')[1]),
      },
      address: json['Info']['LocationDetails']['@Name'],
      code: json['Info']['LocationDetails']['@Code'],
    );
  }
}
