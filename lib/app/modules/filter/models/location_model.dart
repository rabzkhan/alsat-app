class Province {
  final String name;
  final List<String> cities;

  Province({
    required this.name,
    required this.cities,
  });
}

class SelectedProvince {
  final String province;
  final List<String> cities;

  SelectedProvince({required this.province, this.cities = const []});
}

List<Province> provinces = [
  Province(name: "Dhaka", cities: ["Dhanmondi", "Gulshan", "Mirpur", "Mohammadpur", "Uttara"]),
  Province(name: "Chattogram", cities: ["Patenga", "Halishahar", "Agrabad", "Pahartali"]),
  Province(name: "Khulna", cities: ["Sonadanga", "Khalishpur", "Shibbari", "Gollamari"]),
  Province(name: "Sylhet", cities: ["Zindabazar", "Amberkhana", "Shahjalal Uposhohor"]),
  Province(name: "Rajshahi", cities: ["Shaheb Bazar", "Uposhohor", "Motihar"]),
  Province(name: "Barishal", cities: ["Sadar Road", "Nathullabad", "Kaunia"]),
  Province(name: "Rangpur", cities: ["Sadar Upazila", "Carmichael", "Modern"]),
  Province(name: "Mymensingh", cities: ["Trishal", "Valuka", "Gafargaon"]),
  Province(name: "Ahal", cities: ["Anau", "Tejen", "Sarahs", "Abadan"]),
  Province(name: "Balkan", cities: ["Balkanabat", "Turkmenbashi", "Bereket", "Gumdag"]),
  Province(name: "Dashoguz", cities: ["Dashoguz City", "Koneurgench", "Boldumsaz", "Gorogly"]),
  Province(name: "Lebap", cities: ["Turkmenabat", "Farap", "Darganata", "Kerkichi"]),
  Province(name: "Mary", cities: ["Mary City", "Bayramaly", "Yoloten", "Murgap"]),
  Province(name: "Ashgabat", cities: ["Ashgabat City"]),
];
