class OnBoardingModel {
  String imageUrl;
  String title;
  String detail;

  OnBoardingModel({
    required this.imageUrl,
    required this.title,
    required this.detail,
  });
}

List<OnBoardingModel> onBoardingData = [
  OnBoardingModel(
    imageUrl: 'assets/images/introOne.png',
    title: 'Lorem ipsum is placeholder text commonly',
    detail:
    "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing ",
  ),
  OnBoardingModel(
    imageUrl: 'assets/images/introTwo.png',
    title: 'Lorem ipsum is placeholder text commonly',
    detail:
    "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing ",
  ),
  OnBoardingModel(
    imageUrl: 'assets/images/introOne.png',
    title: 'Lorem ipsum is placeholder text commonly',
    detail:
    "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing ",
  ),
];