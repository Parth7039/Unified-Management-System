class Party {
  String partyName;
  String partyContact;

  Party({
    required this.partyName,
    required this.partyContact,
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      partyName: json['partyName'],
      partyContact: json['partyContact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partyName': partyName,
      'partyContact': partyContact,
    };
  }
}

class Contract {
  String contractType;
  String contractName;
  String duration;
  String details;
  String? additionalTerms;
  DateTime effectiveDate;
  DateTime endDate;
  String status;
  Party? partyDetails;

  Contract({
    required this.contractType,
    required this.contractName,
    required this.duration,
    required this.details,
    this.additionalTerms,
    required this.effectiveDate,
    required this.endDate,
    required this.status,
    this.partyDetails,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      contractType: json['contractType'],
      contractName: json['contractName'],
      duration: json['duration'],
      details: json['details'],
      additionalTerms: json['additionalTerms'],
      effectiveDate: DateTime.parse(json['effectiveDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
      partyDetails: json['partyDetails'] != null
          ? Party.fromJson(json['partyDetails'])
          : null,
    );
  }

  get partyName => null;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'contractType': contractType,
      'contractName': contractName,
      'duration': duration,
      'details': details,
      'additionalTerms': additionalTerms,
      'effectiveDate': effectiveDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'partyDetails': partyDetails?.toJson(),
    };
    return data;
  }
}
