import 'package:flutter/material.dart';
//import 'package:intl/intl.dart' as MyFormat;
// import 'package:geocoding/geocoding.dart';

import '../assets/icons_assets.dart';
import 'global.dart';

/// remove zero first in phone number
String removeZeroAtFirstDigitPhoneNumber(String inputPhoneNumber) {
  if (inputPhoneNumber.startsWith("0")) {
    return inputPhoneNumber.substring(1, inputPhoneNumber.length);
  }
  return inputPhoneNumber;
}


// String getAddressFromPlaceCheckIn(Placemark place) {
//   return ((place.street.toString().isNotEmpty)
//           ? '${place.street.toString()}, '
//           : '') +
//       ((place.subAdministrativeArea.toString().isNotEmpty)
//           ? '${place.subAdministrativeArea.toString()}, '
//           : '') +
//       ((place.administrativeArea.toString().isNotEmpty)
//           ? '${place.administrativeArea.toString()}, '
//           : '') +
//       ((place.country.toString().isNotEmpty)
//           ? '${place.country.toString()} '
//           : '');
// }
//
// String getAddressFromPlaceUserLocation(Placemark place) {
//   return ((place.subAdministrativeArea.toString().isNotEmpty)
//           ? '${place.subAdministrativeArea.toString()}, '
//           : '') +
//       ((place.administrativeArea.toString().isNotEmpty)
//           ? '${place.administrativeArea.toString()}, '
//           : '') +
//       ((place.country.toString().isNotEmpty)
//           ? '${place.country.toString()} '
//           : '');
// }

/// Condition to check the email address
bool checkEmailAddress(String newEmail) {
  if (newEmail.isNotEmpty) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(newEmail);
  }
  return false;
}



