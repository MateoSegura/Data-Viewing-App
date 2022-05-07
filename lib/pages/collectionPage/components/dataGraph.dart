import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
//import 'package:syncfusion_flutter_sliders/sliders.dart';

class OR21GraphData {
  DateTime time;
  double value;

  OR21GraphData({
    this.time,
    this.value,
  });
}

class OR21Graph extends StatefulWidget {
  //Variables
  final String title;
  final List<DateTime> time;
  final List<double> data;

  final min;
  final max;

  OR21Graph({
    Key key,
    @required this.title,
    @required this.time,
    @required this.data,
    @required this.min,
    @required this.max,
  }) : super(key: key);

  @override
  _OR21GraphState createState() => _OR21GraphState();
}

class _OR21GraphState extends State<OR21Graph> {
  List<OR21GraphData> graphData = [];
  TooltipBehavior _tooltipBehavior;
  TrackballBehavior _trackballBehavior;
  RangeController juan;

  @override
  void initState() {
    _tooltipBehavior = tooltipBehaviorSettings();
    _trackballBehavior = trackballBehaviorSettings();
    for (int i = 0; i < widget.time.length; i++) {
      graphData.add(
        OR21GraphData(
          time: widget.time[i],
          value: widget.data[i],
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      child: Card(
        child: Stack(
          children: [
            Positioned(
              child: DropdownButton(
                autofocus: false,
                items: [],
              ),
            ),
            SfCartesianChart(
              //Title
              // title: ChartTitle(
              //   text: this.widget.title,
              //   alignment: ChartAlignment.center,
              // ),

              margin: EdgeInsets.all(20),

              tooltipBehavior: _tooltipBehavior,
              trackballBehavior: _trackballBehavior,

              //Zoom
              zoomPanBehavior: buildZoomPanBehavior(),

              primaryXAxis: DateTimeAxis(
                  isVisible: true,
                  enableAutoIntervalOnZooming: true,
                  visibleMinimum: widget.min,
                  visibleMaximum: widget.max,
                  interval: 1,
                  intervalType: DateTimeIntervalType.seconds),

              primaryYAxis: NumericAxis(
                anchorRangeToVisiblePoints: true,
                enableAutoIntervalOnZooming: true,
              ),

              series: <ChartSeries>[
                FastLineSeries<OR21GraphData, DateTime>(
                  //Auto range calculation`

                  //Average null points
                  emptyPointSettings:
                      EmptyPointSettings(mode: EmptyPointMode.average),

                  //Tool Tip
                  enableTooltip: false,

                  //Initial Line Display Duration
                  animationDuration: 100,
                  dataSource: graphData,
                  xAxisName: "Time",
                  xValueMapper: (OR21GraphData data, _) => data.time,
                  yValueMapper: (OR21GraphData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                      isVisible: false,
                      labelPosition: ChartDataLabelPosition.inside),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Zooming
  ZoomPanBehavior buildZoomPanBehavior() {
    return ZoomPanBehavior(
      selectionRectBorderColor: Colors.red,
      selectionRectBorderWidth: 1,
      selectionRectColor: Colors.grey,
      enablePanning: true,
      //enableDoubleTapZooming: true,
      //maximumZoomLevel: 0.1,
      enableSelectionZooming: true,
      zoomMode: ZoomMode.xy,
      //enableMouseWheelZooming: true,
      //enablePinching: true,
    );
  }

  //ToolTip
  TooltipBehavior tooltipBehaviorSettings() => TooltipBehavior(enable: true);

  //Trackball
  TrackballBehavior trackballBehaviorSettings() {
    return TrackballBehavior(
      // Enables the trackball
      enable: true,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        format: 'point.x \n point.y',
      ),
    );
  }
}
