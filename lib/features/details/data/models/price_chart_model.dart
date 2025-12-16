class PriceChartModel {
  final List<ChartDataPoint> prices;

  PriceChartModel({
    required this.prices,
  });

  factory PriceChartModel.fromJson(Map<String, dynamic> json) {
    return PriceChartModel(
      prices: _parseDataPoints(json['prices']),
    );
  }

  static List<ChartDataPoint> _parseDataPoints(dynamic data) {
    if (data == null) return [];

    final list = data as List<dynamic>;
    return list.map((point) {
      final pointList = point as List<dynamic>;
      return ChartDataPoint(
        time: (pointList[0] as num).toDouble(),
        price: (pointList[1] as num).toDouble(),
      );
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'prices': prices.map((p) => [p.time, p.price]).toList(),
    };
  }
}

class ChartDataPoint {
  final double time;
  final double price;

  ChartDataPoint({
    required this.time,
    required this.price,
  });

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(time.toInt());

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartDataPoint(
      time: (json['time'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'price': price,
    };
  }
}