import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyTrack extends StatelessWidget {
  final List<LatLng> chartData;
  const MyTrack({Key key, this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      //Zoom
      backgroundColor: Colors.grey[900],
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true,
        enableMouseWheelZooming: true,
        enablePinching: true,
      ),
      primaryXAxis: NumericAxis(
        rangePadding: ChartRangePadding.additional,
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        rangePadding: ChartRangePadding.additional,
        isVisible: false,
      ),

      series: <ChartSeries>[
        // Renders fast line chart
        FastLineSeries<LatLng, double>(
            dataSource: chartData,
            xValueMapper: (LatLng myTrack, _) => myTrack.latitude,
            yValueMapper: (LatLng myTrack, _) => myTrack.longitude)
      ],
    );
  }
}
