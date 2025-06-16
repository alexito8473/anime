import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'configuration_event.dart';
part 'configuration_state.dart';

class ConfigurationBloc
    extends HydratedBloc<ConfigurationEvent, ConfigurationState> {
  ConfigurationBloc() : super(ConfigurationState.init()) {
    on<ChangeImagePerson>(
        (event, emit) => emit(state.copyWith(imagePerson: event.image)));
    on<ChangeImageBackground>(
            (event, emit) => emit(state.copyWith(imageBackGround: event.image)));
    on<ChangeOrderList>((event, emit) =>
        emit(state.copyWith(isUpwardList: !state.isUpwardList)));
    on<ConfigurationEvent>((event, emit) async =>
        await PackageInfo.fromPlatform()
            .then((value) => emit(state.copyWith(version: value.version))));
  }

  @override
  ConfigurationState? fromJson(Map<String, dynamic> json) => ConfigurationState(
      imagePerson: json['imagePerson'],
      version: json['version'],
      isUpwardList: json['isUpwardList'] as bool,
      imageBackGround: json['imageBackGround']);

  @override
  Map<String, dynamic>? toJson(ConfigurationState state) => {
        'version': state.version,
        'imagePerson': state.imagePerson,
        'isUpwardList': state.isUpwardList,
        'imageBackGround': state.imageBackGround
      };
}
