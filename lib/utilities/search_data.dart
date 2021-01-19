class SearchData {
  final String locationName;
  double latitude;
  double longitude;
  String pickupDate;
  String returnDate;
  String pickupTime;
  String returnTime;

  SearchData(
      {this.locationName,
      this.latitude,
      this.longitude,
      this.pickupDate,
      this.returnDate,
      this.pickupTime,
      this.returnTime});
}
