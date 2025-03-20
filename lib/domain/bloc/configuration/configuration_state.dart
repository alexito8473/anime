part of 'configuration_bloc.dart';

class ConfigurationState {
  final String version;
  final bool isUpwardList;
  final String imagePerson;

  const ConfigurationState(
      {required this.version,
      required this.isUpwardList,
      required this.imagePerson});

  factory ConfigurationState.init() => const ConfigurationState(
      version: "",
      isUpwardList: false,
      imagePerson: "assets/wallpaper/saitama.webp");

  ConfigurationState copyWith(
      {String? version, String? imagePerson, bool? isUpwardList}) {
    return ConfigurationState(
        version: version ?? this.version,
        isUpwardList: isUpwardList ?? this.isUpwardList,
        imagePerson: imagePerson ?? this.imagePerson);
  }
}
