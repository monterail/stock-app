import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocks/src/repositories/polygon_io/common/client.dart';
import 'package:stocks/src/repositories/polygon_io/reference/src/api/search_by_name.dart';
import 'package:stocks/src/repositories/polygon_io/reference/ticker_reference_repository.dart';

import 'ticker_search_bloc.dart';

class TickerSearchBlocProvider extends StatelessWidget {
  final Widget child;

  const TickerSearchBlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => RepositoryProvider(
        create: (context) => TickerReferenceRepository(
          httpClient: polygonClient,
          searchByName: searchByName,
        ),
        child: BlocProvider(
          create: (context) => TickerSearchBloc(
            tickerReferenceRepository: context.read(),
          ),
          child: child,
        ),
      );
}
