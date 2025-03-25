import 'package:alsat/app/modules/product/model/product_post_list_res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MultiImagePreview extends StatelessWidget {
  final List<Media> galleryItems;
  final int initialIndex;
  const MultiImagePreview({
    super.key,
    required this.galleryItems,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.appBarTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
          color: Get.theme.appBarTheme.backgroundColor,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(galleryItems[index].name ?? ''),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(
                    tag: galleryItems[index].name ?? ''),
              );
            },
            itemCount: galleryItems.length,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded /
                          (event.expectedTotalBytes ?? 1),
                ),
              ),
            ),
            backgroundDecoration: BoxDecoration(
              color: Get.theme.appBarTheme.backgroundColor,
            ),
            pageController: PageController(initialPage: initialIndex),
          )),
    );
  }
}
