// ignore_for_file: file_names

class CustomerModel {
  int id;
  String name;
  String email;
  String phoneNumber;
  String? address;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
      address: map['address'],
    );
  }
}
