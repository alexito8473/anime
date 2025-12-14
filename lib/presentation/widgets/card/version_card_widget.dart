import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/configuration/configuration_bloc.dart';

class VersionCardWidget extends StatelessWidget {
  const VersionCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ConfigurationBloc, ConfigurationState, String>(
      selector: (state) => state.version,
      builder: (context, state) {
        return SliverToBoxAdapter(
            child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text('Versión Actual',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text(state,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600))
                    ])));
      },
    );
  }
}
