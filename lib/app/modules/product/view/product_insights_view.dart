import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/modules/product/view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';

class MonthlyEarningGraph extends StatefulWidget {
  const MonthlyEarningGraph({super.key});

  @override
  State<MonthlyEarningGraph> createState() => _MonthlyEarningGraphState();
}

class _MonthlyEarningGraphState extends State<MonthlyEarningGraph> {
  List<Color> gradientColors = [
    Colors.grey.shade300,
    Colors.blueAccent,
  ];
  List<Color> gradient2Colors = [
    Colors.grey,
    Colors.grey,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25.w,
          ),
          child: Row(
            children: [
              Text(
                'Earnings',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.w,
                      ),
                    ),
                    // onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Weekly',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 1.9,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ).copyWith(
              left: 10.w,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 10.sp,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Container(
          padding: EdgeInsets.only(
            left: 10.w,
          ),
          child: Text(
            'Sun',
            style: style,
            textAlign: TextAlign.center,
          ),
        );
        break;
      case 1:
        text = Text('Mon', style: style);
        break;
      case 2:
        text = Text('Tue', style: style);
        break;
      case 3:
        text = Text('Wed', style: style);
        break;
      case 4:
        text = Text('Thu', style: style);
        break;
      case 5:
        text = Text('Fri', style: style);
        break;
      case 6:
        text = Container(
            padding: EdgeInsets.only(
              right: 10.w,
            ),
            child: Text('Sat', style: style));
        break;
      default:
        text = Text('-', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12.sp,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
      case 1:
        text = '10';
      case 2:
        text = '50';
        break;
      case 3:
        text = '100';
        break;
      case 4:
        text = '150';
        break;
      case 5:
        text = '500';
      case 6:
        text = '1k+';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
              color: Colors.grey.shade300, strokeWidth: .5, dashArray: [4, 4]);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.blueAccent,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 7,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6, 3.1),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(1.6, 1),
            FlSpot(3.9, 5),
            FlSpot(6, 2.1),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradient2Colors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductInsightsView extends StatelessWidget {
  const ProductInsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: const SafeArea(
          child: CustomAppBar(
            isShowBackButton: true,
          ),
        ),
      ),
      body: Column(
        children: [
          const MonthlyEarningGraph(),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: FormBuilderTextField(
              name: 'popularity',
              decoration: InputDecoration(
                isDense: true,
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Popularity',
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Get.theme.shadowColor.withOpacity(.6),
                ),
                border: outlineBorder,
                enabledBorder: outlineBorder,
                errorBorder: outlineBorder,
                focusedBorder: outlineBorder,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: FormBuilderTextField(
              name: 'popularity',
              decoration: InputDecoration(
                isDense: true,
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Engagement Is',
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Get.theme.shadowColor.withOpacity(.6),
                ),
                border: outlineBorder,
                enabledBorder: outlineBorder,
                errorBorder: outlineBorder,
                focusedBorder: outlineBorder,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
          ),
          Row(
            children: [
              30.horizontalSpace,
              Checkbox(
                value: false,
                side: const BorderSide(
                  width: .5,
                ),
                onChanged: (value) {},
              ),
              Text(
                'Unique Views',
                style: regular.copyWith(
                  fontSize: 12.sp,
                ),
              ),
              Checkbox(
                value: false,
                side: const BorderSide(
                  width: .5,
                ),
                onChanged: (value) {},
              ),
              Text(
                'Unique Views',
                style: regular.copyWith(
                  fontSize: 12.sp,
                ),
              )
            ],
          ),
          5.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                infoTile(name: 'Engagements', value: '12'),
                infoTile(name: 'Likes', value: '55'),
                infoTile(name: 'Comments', value: '33'),
                infoTile(name: 'Offer Request', value: '11'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
