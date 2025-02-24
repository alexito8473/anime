part of 'configuration_bloc.dart';

class ConfigurationState {
  final String version;

  const ConfigurationState({required this.version});

  factory ConfigurationState.init() {
    return const ConfigurationState(version: "");
  }

  ConfigurationState copyWith(String? version) {
    return ConfigurationState(version: version ?? this.version);
  }
}
