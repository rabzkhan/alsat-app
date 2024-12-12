import 'package:alsat/app/common/const/image_path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewworkImagePreview extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final double? borderWidth;
  final double radius;
  final double? progressIndicatorRadius;
  final BoxFit fit;
  final Widget? loading;
  final Color? progressColor;
  final Color? imageColor;
  final bool repeat;

  const NewworkImagePreview({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.radius = 0,
    this.fit = BoxFit.cover,
    this.progressIndicatorRadius,
    this.loading,
    this.borderWidth,
    this.progressColor,
    this.repeat = false,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        repeat: repeat ? ImageRepeat.repeat : ImageRepeat.noRepeat,
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        color: imageColor,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            loading ??
            CupertinoActivityIndicator(
              radius: (progressIndicatorRadius ?? height ?? 100) / 4,
              color: progressColor ?? Theme.of(context).primaryColor,
            ),
        errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(radius).r,
          child: Image.asset(logo),
        ),
      ),
    );
  }
}
