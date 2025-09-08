import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/update/update_bloc.dart';

class AlertDialogUpdateAppWidget extends StatelessWidget {
  const AlertDialogUpdateAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shadowColor: Colors.white54,
        title: Text(
          'Nueva actualización disponible',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
            'Se ha encontrado una nueva versión de la aplicación. ¿Deseas actualizar ahora?',
            style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Más tarde',
                style: theme.textTheme.labelLarge!.copyWith(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600)),
          ),
          TextButton(
              onPressed: () {
                context.read<UpdateBloc>().add(UpdateMobileEvent());
                Navigator.of(context).pop();
              },
              child: Text('Actualizar',
                  style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold)))
        ]);
  }
}
