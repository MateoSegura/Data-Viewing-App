import 'package:flutter/material.dart';

import 'dataGraph.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({
    Key key,
    @required this.time,
    @required this.ath,
    @required DateTime max2,
    @required DateTime min2,
  })  : _max2 = max2,
        _min2 = min2,
        super(key: key);

  final List<DateTime> time;
  final List<double> ath;
  final DateTime _max2;
  final DateTime _min2;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return OR21Graph(
          title: "Graph",
          time: widget.time,
          data: widget.ath,
          max: widget._max2,
          min: widget._min2,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
