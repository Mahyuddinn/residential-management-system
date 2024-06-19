class Facility {
  String facilityName;
  String description;
  String location;
  String time;

  Facility({
    required this.facilityName,
    required this.description,
    required this.location,
    required this.time,
  });

  // Getter for facilityName
  String getFacilityName() {
    return facilityName;
  }

  // Setter for facilityName
  void setFacilityName(String name) {
    facilityName = name;
  }

  // Getter for openTime
  String getDescription() {
    return description;
  }

  // Setter for openTime
  void setDescription(String description) {
    this.description = description;
  }

  // Getter for closeTime
  String getLocation() {
    return location;
  }

  // Setter for closeTime
  void setLocation(String location) {
    this.location = location;
  }

  // Getter for capacity
  String getTime() {
    return time;
  }

  // Setter for capacity
  void setCapacity(String time) {
    this.time = time;
  }

  void displayAttributes() {
    print('Facility Name: $facilityName');
    print('Description: $description');
    print('Location: $location');
    print('Time: $time');
  }

  factory Facility.fromMap(Map<String, dynamic> data) {
    return Facility(
      facilityName: data['name'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      time: data['time'] ?? '',
    );
  }
}
