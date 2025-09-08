part of 'configuration_bloc.dart';

class ConfigurationState {
  final String version;
  final bool isUpwardList;
  final String imagePerson;
  final String imageBackGround;
  final int pageHomeIndex;

  const ConfigurationState(
      {required this.version,
      required this.isUpwardList,
      required this.imageBackGround,
      required this.pageHomeIndex,
      required this.imagePerson});

  factory ConfigurationState.init() => const ConfigurationState(
      version: '',
      isUpwardList: false,
      imageBackGround: 'assets/backgroundImage/wallpaper1.jpg',
      imagePerson: 'assets/wallpaper/saitama.webp',
      pageHomeIndex: 0);

  ConfigurationState copyWith(
      {String? version,
      String? imagePerson,
      int? pageHomeIndex,
      bool? isUpwardList,
      String? imageBackGround}) {
    return ConfigurationState(
        version: version ?? this.version,
        isUpwardList: isUpwardList ?? this.isUpwardList,
        imagePerson: imagePerson ?? this.imagePerson,
        pageHomeIndex: pageHomeIndex ?? this.pageHomeIndex,
        imageBackGround: imageBackGround ?? this.imageBackGround);
  }
}
