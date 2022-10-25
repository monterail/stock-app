import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocks/src/modules/main_screen/bloc/ticker_search_bloc.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (query) =>
                context.read<TickerSearchBloc>().add(UpdateQuery(query)),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: const TickerAutocomplete(),
          ),
        ],
      );
}

class TickerAutocomplete extends StatelessWidget {
  const TickerAutocomplete({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TickerSearchBloc, TickerSearchState>(
        builder: (context, state) {
          final results = state.queryResults.toList();
          return ListView.separated(
            shrinkWrap: true,
            itemCount: results.length,
            separatorBuilder: (_, __) => Container(
              height: 1,
              color: Colors.grey,
            ),
            itemBuilder: (context, index) {
              final ticker = results[index];
              return ListTile(
                title: Text(ticker.name),
                subtitle: Text(ticker.ticker),
                onTap: () {
                  context.read<TickerSearchBloc>().add(PickTicker(ticker));
                  context.read<TickerSearchBloc>().add(UpdateQuery(''));
                },
              );
            },
          );
        },
      );
}
