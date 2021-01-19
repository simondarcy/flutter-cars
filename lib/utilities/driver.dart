class Driver {
  final String fName;
  final String lName;
  final String email;
  final String phone;
  final String residency;
  final int age;

  Driver(
      {this.fName,
      this.lName,
      this.email,
      this.phone,
      this.residency,
      this.age});

  factory Driver.dummy() {
    return Driver(
        fName: 'Simon',
        lName: 'Darcy',
        email: 'sidarcy@gmail.com',
        phone: '0871324584',
        residency: 'US',
        age: 30);
  }
}
