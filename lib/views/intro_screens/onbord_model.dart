class OnBoard {
  final String image;
  final String title;
  final String description;

  OnBoard({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnBoard> content = [
  OnBoard(
    image: 'assets/pngs/Group 33331.png',
    title: ' Explore Upcoming and Nearby Events',
    description:
        ' In publishing and graphic design, Lorem is a placeholder text commonly ',
  ),
  OnBoard(
    image: 'assets/pngs/Group 333331.png',
    title: 'To Look Up More Events or Activities Nearby By Map',
    description:
        ' In publishing and graphic design, Lorem is a placeholder text commonly ',
  ),
  OnBoard(
    image: 'assets/pngs/Group 33331 (1).png',
    title: 'Chat With Your Friends And Share Events With Them',
    description:
        ' In publishing and graphic design, Lorem is a placeholder text commonly ',
  ),
];
