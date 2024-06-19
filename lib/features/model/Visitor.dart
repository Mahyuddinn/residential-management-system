class Visitor {
  final String name;
  final String phoneNumber;
  final String plate;
  final String checkInDate;
  final String checkOutDate;
  final String Status;

  Visitor({
    required this.name,
    required this.phoneNumber,
    required this.plate,
    required this.checkInDate,
    required this.checkOutDate,
    required this.Status,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'plate': plate,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'Status': Status,
    };
  }
}