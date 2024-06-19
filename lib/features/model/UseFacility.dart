class UseFacility {
  String facilityName;
  DateTime timeIn;
  String name;
  String address;
  int numPeople;
  DateTime? timeOut;

  UseFacility({
    required this.facilityName,
    required this.timeIn,
    required this.name,
    required this.address,
    required this.numPeople,
    this.timeOut,
  });
}
