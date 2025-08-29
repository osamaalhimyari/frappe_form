import 'package:frappe_form/frappe_form.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneInfo {
  String? number;
  Country? country;

  PhoneInfo({this.number, this.country});

  String get completeNumber =>
      '${country?.dialCode != null ? '+${country?.dialCode}' : ''}$number';

  PhoneNumber get asPhoneNumber => PhoneNumber(
    countryISOCode: country?.code ?? '',
    countryCode: country?.dialCode != null ? '+${country?.dialCode}' : '',
    number: number ?? '',
  );

  String get toFrappePhone => asPhoneNumber.toFrappePhone;
}

extension PhoneUtils on PhoneNumber {
  String get toFrappePhone => number.isEmpty ? '' : '$countryCode-$number';

  static String get defaultInitialCountryCode =>
      DocFormLocalization.instance.localization.locale.countryCode ?? 'US';
  static Country get defaultInitialCountry {
    return countries.firstWhere(
      (country) => country.code == defaultInitialCountryCode,
      orElse: () => countries.first,
    );
  }

  static PhoneInfo parse(String? number) {
    if (number == null) return PhoneInfo(country: defaultInitialCountry);
    final tempNumber = (number.startsWith('+') ? number.substring(1) : number)
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '')
        .replaceAll(' ', '');
    final country = countries.firstWhere((country) {
      if (tempNumber.startsWith(country.dialCode)) {
        final numberLength = tempNumber.length - country.dialCode.length;
        return numberLength >= country.minLength &&
            numberLength <= country.maxLength;
      }
      return false;
    }, orElse: () => defaultInitialCountry);
    return PhoneInfo(
      number: tempNumber.length >= country.dialCode.length
          ? tempNumber.substring(country.dialCode.length)
          : tempNumber,
      country: country,
    );
  }
}
