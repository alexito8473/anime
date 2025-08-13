import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/update/update_bloc.dart';

class TitleDownloadHomePageWidget extends StatelessWidget {
  const TitleDownloadHomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UpdateBloc, UpdateState, String>(
        selector: (state) => state.advance,
        builder: (context, state) {
          return state != ''
              ? Text('Descargando : $state%')
              : const Text('');
        });
  }
}
