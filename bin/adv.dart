class Advertisement {
  late String id;
  late String idAnimal;
  late String idUser;
  late String state;
  late String createdAt;

  Advertisement(this.id, this.idAnimal, this.idUser, this.state, this.createdAt);

  factory Advertisement.fromJson(dynamic json, String id) {
    return Advertisement(
        id,
        json['id_animal'] as String,
        json["id_user"] as String,
        json["state"] as String,
        json["created_at"] as String
    );
  }

  Map toJson() => {
    'id': id,
    'id_animal': idAnimal,
    'id_user': idUser,
    'state': state,
    'created_at': createdAt
  };
}