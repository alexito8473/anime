part of 'configuration_bloc.dart';

class ConfigurationState {
  final String version;
  final bool isUpwardList;
  final String imagePerson;
  final String imageBackGround;

  const ConfigurationState(
      {required this.version,
      required this.isUpwardList,
      required this.imageBackGround,
      required this.imagePerson});

  factory ConfigurationState.init() => const ConfigurationState(
      version: "",
      isUpwardList: false,
      imageBackGround: "assets/backgroundImage/wallpaper1.jpg",
      imagePerson: "assets/wallpaper/saitama.webp");

  ConfigurationState copyWith(
      {String? version,
      String? imagePerson,
      bool? isUpwardList,
      String? imageBackGround}) {
    return ConfigurationState(
        version: version ?? this.version,
        isUpwardList: isUpwardList ?? this.isUpwardList,
        imagePerson: imagePerson ?? this.imagePerson,
        imageBackGround: imageBackGround ?? this.imageBackGround);
  }
}
