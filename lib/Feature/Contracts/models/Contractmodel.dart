
class Contract {
  String name;
  String details;
  String duration;
  String additionalTerms;
  DateTime startDate;
  DateTime endDate;
  String partyName;
  String partyContact;
  String contractType; // 'Government' or 'Private'
  String contractStatus; // 'Active', 'Inactive', 'Completed'

  Contract({
    required this.name,
    required this.details,
    required this.duration,
    required this.additionalTerms,
    required this.startDate,
    required this.endDate,
    required this.partyName,
    required this.partyContact,
    required this.contractType,
    required this.contractStatus,
  });
}
