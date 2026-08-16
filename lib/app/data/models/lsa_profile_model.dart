import 'package:equatable/equatable.dart';


class LSAProfileModel extends Equatable {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? certificationNumber;
  final int? yearsOfExperience;
  final String? bio;

  final String? predecessorId;

  const LSAProfileModel({
    this.fullName,
    this.email,
    this.phone,
    this.certificationNumber,
    this.yearsOfExperience,
    this.bio,
    this.predecessorId,
  });

  factory LSAProfileModel.empty() => const LSAProfileModel();

  LSAProfileModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? certificationNumber,
    int? yearsOfExperience,
    String? bio,
    String? predecessorId,
  }) {
    return LSAProfileModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      certificationNumber: certificationNumber ?? this.certificationNumber,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      bio: bio ?? this.bio,
      predecessorId: predecessorId ?? this.predecessorId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'certification_number': certificationNumber,
        'years_of_experience': yearsOfExperience,
        'bio': bio,
        'predecessor_id': predecessorId,
      };

  @override
  List<Object?> get props => <Object?>[
        fullName,
        email,
        phone,
        certificationNumber,
        yearsOfExperience,
        bio,
        predecessorId,
      ];
}
