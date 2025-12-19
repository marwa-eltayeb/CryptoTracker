class PaymentBody {
  final String userId;
  final double amount;
  final String currency;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  PaymentBody({
    required this.userId,
    required this.amount,
    this.currency = 'EGP',
    this.firstName = 'Clifford',
    this.lastName = 'Nicolas',
    this.email = 'claudette09@exa.com',
    this.phoneNumber = '+86(8)9135210487',
  });

  Map<String, dynamic> toBillingData() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone_number": phoneNumber,
      "apartment": "NA",
      "floor": "NA",
      "street": "NA",
      "building": "NA",
      "shipping_method": "NA",
      "postal_code": "NA",
      "city": "NA",
      "country": "NA",
      "state": "NA"
    };
  }
}