class Model {
  final int id;
  final String imagePath;
  final String name;

  Model({
    required this.id,
    required this.imagePath,
    required this.name,
  });
}

List<Model> navBtn = [
  Model(id: 0, imagePath: 'assets/svgs/navigation_bar/Home.svg', name: 'Home'),
  Model(id: 1, imagePath: 'assets/svgs/navigation_bar/House To Motive.svg', name: 'Explore'),
  Model(id: 2, imagePath: 'assets/svgs/navigation_bar/Search.svg', name: 'Search'),
  Model(id: 3, imagePath: 'assets/svgs/navigation_bar/My Chat.svg', name: 'My Chat'),
  Model(id: 4, imagePath: 'assets/svgs/navigation_bar/My Profile.svg', name: 'My Profile'),
];


class Model2 {
  final int id;
  final String imagePath;

  Model2({
    required this.id,
    required this.imagePath,
  });
}

List<Model2> navBtn2 = [
  Model2(id: 0,imagePath: 'assets/svgs/navigation_bar/navigation_bar2/home-2.svg'),
  Model2(id: 1, imagePath: 'assets/svgs/navigation_bar/navigation_bar2/location-2.svg'),
  Model2(id: 2, imagePath: 'assets/svgs/navigation_bar/navigation_bar2/Search-2.svg',),
  Model2(id: 3, imagePath: 'assets/svgs/navigation_bar/navigation_bar2/My Chat-2.svg',),
  Model2(id: 4, imagePath: 'assets/svgs/navigation_bar/navigation_bar2/My Profile-2.svg',),

];
