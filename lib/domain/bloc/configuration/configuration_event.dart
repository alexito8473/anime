part of 'configuration_bloc.dart';

@immutable
sealed class ConfigurationEvent {}

class ObtainDataVersion extends ConfigurationEvent{}
class ChangeOrderList extends ConfigurationEvent{}
class ChangeImagePerson extends ConfigurationEvent{
  final String image;
  ChangeImagePerson({required this.image});
}