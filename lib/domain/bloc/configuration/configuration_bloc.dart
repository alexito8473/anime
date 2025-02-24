import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'configuration_event.dart';
part 'configuration_state.dart';

class ConfigurationBloc
    extends HydratedBloc<ConfigurationEvent, ConfigurationState> {
  ConfigurationBloc() : super(ConfigurationState.init()) {
    on<ConfigurationEvent>((event, emit) async {
      await PackageInfo.fromPlatform().then(
        (value) {
          emit(ConfigurationState(version: value.version));
        },
      );
    });
  }

  @override
  ConfigurationState? fromJson(Map<String, dynamic> json) {
    return ConfigurationState(version: json["version"]);
  }

  @override
  Map<String, dynamic>? toJson(ConfigurationState state) {
    return {"version": state.version};
  }
}
