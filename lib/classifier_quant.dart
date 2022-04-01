import 'package:health_app/classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ClassifierQuant extends Classifier {
  ClassifierQuant({int numThreads: 1}) : super(numThreads: numThreads);

  @override
  String get modelName => 'mobilenet_v1_1.0_224_1_metadata_1.tflite'; //가벼운모델

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1); //정규화

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 255);
}
