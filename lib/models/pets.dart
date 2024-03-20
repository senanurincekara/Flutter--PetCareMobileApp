class Pet {
  static int _nextId = 0;

  int id;
  String type;
  String name;
  String gender;
  String age;
  String birthDate;

  Pet({
    this.id = 0,
    required this.type,
    required this.name,
    required this.gender,
    required this.age,
    required this.birthDate,
  }) {
    if (id == 0) {
      _nextId++;
      id = _nextId;
    }
  }
}

List<Pet> samplePets = [
  Pet(
    type: "Dog",
    name: "Buddy",
    gender: "Male",
    age: "2",
    birthDate: "2021-01-01",
  ),
  Pet(
    type: "Cat",
    name: "Whiskers",
    gender: "Female",
    age: "3",
    birthDate: "2020-05-15",
  ),
  Pet(
    type: "Dog",
    name: "max",
    gender: "Male",
    age: "1",
    birthDate: "2022-03-10",
  ),
];
