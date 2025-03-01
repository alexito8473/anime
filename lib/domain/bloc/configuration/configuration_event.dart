part of 'configuration_bloc.dart';

@immutable
sealed class ConfigurationEvent {}

class ObtainDataVersion extends ConfigurationEvent{}
class ChangeOrderList extends ConfigurationEvent{}