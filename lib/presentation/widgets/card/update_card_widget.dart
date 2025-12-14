
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/update/update_bloc.dart';

class UpdateCardWidget extends StatelessWidget {
  const UpdateCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UpdateBloc, UpdateState, bool>(
        selector: (state) => state.canUpdate,
        builder: (context, state) {
          return SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      state
                          ? '¡Nueva versión disponible!'
                          : 'Tienes la última versión',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    if (state)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          onPressed: () => {
                            if (!kIsWeb && Platform.isAndroid)
                              {
                                context
                                    .read<UpdateBloc>()
                                    .add(CanUpdateMobileEvent())
                              }
                          },
                          child: const Text('Actualizar ahora',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ));
        });
  }
}
