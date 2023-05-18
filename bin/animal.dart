class Animal {
  late String _id;
  late String name;
  late String rasa;
  late String photoUrl;
  late String description;
  late bool found;

  Animal(this.name, this.rasa, this.photoUrl, this.description,
      this.found);

  factory Animal.fromJson(dynamic json) {
    return Animal(
        json['name'] as String,
        json['rasa'] as String,
        json["description"] as String,
        json["photoUrl"] as String,
        json["found"] as bool);
  }

  void setId(String id) {
    _id = id;
  }
}
