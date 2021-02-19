import 'package:flutter/material.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setImageAssetPath("demo/doc2.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setImageAssetPath("demo/doc3.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setImageAssetPath("demo/doc4.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
