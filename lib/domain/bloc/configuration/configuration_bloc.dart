import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'configuration_event.dart';
part 'configuration_state.dart';

class ConfigurationBloc
    extends HydratedBloc<ConfigurationEvent, ConfigurationState> {
  ConfigurationBloc() : super(ConfigurationState.init()) {
    on<ChangeOrderList>((event, emit) =>
        emit(state.copyWith(isUpwardList: !state.isUpwardList)));
    on<ConfigurationEvent>((event, emit) async =>
        await PackageInfo.fromPlatform()
            .then((value) => emit(state.copyWith(version: value.version))));
  }

  @override
  ConfigurationState? fromJson(Map<String, dynamic> json) => ConfigurationState(
      version: json["version"], isUpwardList: json["isUpwardList"] as bool);

  @override
  Map<String, dynamic>? toJson(ConfigurationState state) =>
      {"version": state.version, "isUpwardList": state.isUpwardList};
}
