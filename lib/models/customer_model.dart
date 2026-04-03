enum Gender { male, female, other }

enum FabricType { wool, linen, cotton, silk, velvet }

enum SilhouetteType { italianSlimFit, doublBreasted, regularFit, relaxedFit }

class MeasurementsModel {
  double chest;
  double waist;
  double bicep;
  double neck;
  double shoulder;
  double inseam;

  MeasurementsModel({
    this.chest = 0.0,
    this.waist = 0.0,
    this.bicep = 0.0,
    this.neck = 0.0,
    this.shoulder = 0.0,
    this.inseam = 0.0,
  });

  MeasurementsModel copyWith({
    double? chest,
    double? waist,
    double? bicep,
    double? neck,
    double? shoulder,
    double? inseam,
  }) {
    return MeasurementsModel(
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      bicep: bicep ?? this.bicep,
      neck: neck ?? this.neck,
      shoulder: shoulder ?? this.shoulder,
      inseam: inseam ?? this.inseam,
    );
  }
}

class CustomerModel {
  final String? id;
  final String fullName;
  final String phone;
  final Gender gender;
  final String specialNotes;
  final MeasurementsModel measurements;
  final String occasionType;
  final List<FabricType> preferredFabrics;
  final SilhouetteType? preferredSilhouette;

  const CustomerModel({
    this.id,
    this.fullName = '',
    this.phone = '',
    this.gender = Gender.male,
    this.specialNotes = '',
    required this.measurements,
    this.occasionType = '',
    this.preferredFabrics = const [],
    this.preferredSilhouette,
  });

  CustomerModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    Gender? gender,
    String? specialNotes,
    MeasurementsModel? measurements,
    String? occasionType,
    List<FabricType>? preferredFabrics,
    SilhouetteType? preferredSilhouette,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      specialNotes: specialNotes ?? this.specialNotes,
      measurements: measurements ?? this.measurements,
      occasionType: occasionType ?? this.occasionType,
      preferredFabrics: preferredFabrics ?? this.preferredFabrics,
      preferredSilhouette: preferredSilhouette ?? this.preferredSilhouette,
    );
  }
}
