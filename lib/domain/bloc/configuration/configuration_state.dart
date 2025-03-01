part of 'configuration_bloc.dart';

class ConfigurationState {
  final String version;
  final bool isUpwardList;

  const ConfigurationState({required this.version, required this.isUpwardList});

  factory ConfigurationState.init() =>
      const ConfigurationState(version: "", isUpwardList: false);

  ConfigurationState copyWith({String? version, bool? isUpwardList}) {
    return ConfigurationState(
        version: version ?? this.version,
        isUpwardList: isUpwardList ?? this.isUpwardList);
  }
}
