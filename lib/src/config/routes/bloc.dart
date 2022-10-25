import 'package:stocks/src/config/routes/routes.dart';
import 'package:stocks/src/modules/bloc_screen/view/bloc_view.dart';
export 'package:stocks/src/modules/bloc_screen/view/bloc_view.dart';

class BlocRouteHelper extends RouteHelper<String> {
  static const path = '/bloc/:title';
  static const widget = BlocView;

  const BlocRouteHelper() : super(path: path);

  @override
  String generatePath(String title) =>
      absolutePath.replaceFirst(':title', title);
}
