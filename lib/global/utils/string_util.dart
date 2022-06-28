import 'package:awesome_cafe/global/model/address_model.dart';
import 'package:awesome_cafe/global/model/cafe_model.dart';
import 'package:awesome_cafe/global/utils/http_manager.dart';

String removeLocation(String param) {
  if (param.contains("### ")) {
    int firstIndex;
    firstIndex = param.indexOf('### ');
    return param.substring(0, firstIndex);
  } else {
    return param;
  }
}

List<String> sliceACafe(String param) {
  int firstIndex = 0;
  List<String> slice = [];
  for (var i = 0; i < param.length; i++) {
    try {
      if (param.contains('#### ')) {
        firstIndex = param.indexOf('#### ');
        param = param.replaceFirst('#### ', '**** ');

        slice.add(removeLocation(param.substring(firstIndex, param.indexOf('#### '))));
      }
    } catch (e) {
      break;
    }
  }
  return slice;
}

CafeModel? sliceACafeSpec(String param) {
  if (param.contains('****')) {
    try {
      // [카페 캠프통]
      String name = param.substring(param.indexOf('[') + 1, param.indexOf(']'));
      //()
      String link = param.substring(param.indexOf('(') + 1, param.indexOf(')'));
      //- 위치 :
      String location_str = param.substring(param.indexOf('- 위치') + 7, param.indexOf('- 규모'));

      //- 규모 :
      String scale = param.substring(param.indexOf('- 규모') + 7, param.indexOf('- 운영'));
      //- 규모 :
      String placeFeatures = param.substring(param.indexOf('- 책상') + 7, param.indexOf('- 콘센트 유무'));
      //- 규모 :
      String hasSocket = param.substring(param.indexOf('- 콘센트 유무') + 7, param.indexOf('- 콘센트 개수'));
      //- 규모 :
      String howManySocket = param.substring(param.indexOf('- 콘센트 개수') + 7, param.indexOf('- 와이파이 유무'));
      //- 규모 :
      String hasWifi = param.substring(param.indexOf('- 와이파이 유무') + 7, param.indexOf('- 와이파이 속도'));
      //- 규모 :
      String howFastWifi = param.substring(param.indexOf('- 와이파이 속도') + 7, param.indexOf('- 기타 특징'));
      //- 규모 :
      String otherFeatures = param.substring(param.indexOf('- 기타 특징') + 7, param.length);

      return CafeModel(
          name: name,
          link: link,
          location: location_str,
          // address: AddresssModel.fromMap(location['addresses'][0]),
          scale: scale,
          placeFeatures: placeFeatures,
          hasSocket: hasSocket,
          howManySocket: howManySocket,
          hasWifi: hasWifi,
          howFastWifi: howFastWifi,
          otherFeatures: otherFeatures);
    } catch (e) {
      return CafeModel(
          name: "name",
          link: "link",
          location: "loca",
          address: null,
          howManySocket: "howManySocket",
          howFastWifi: "howFastWifi",
          otherFeatures: "otherFeatures");
    }
  }
}
