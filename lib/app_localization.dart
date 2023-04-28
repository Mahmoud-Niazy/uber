import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  Locale? locale ;
  AppLocalizations({
    this.locale
});

  static LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  static AppLocalizations? of(context){
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  late Map<String,String> jsonStrings ;
  Future LoadLangJson() async{
    String strings = await rootBundle.loadString('assets/lang/${locale!.languageCode}.json');
    Map<String,dynamic> jsons = json.decode(strings);
    jsonStrings= jsons.map((key, value){
      return MapEntry(key, value.toString());
    } );
  }

  String Translate(String key) => jsonStrings[key]?? key ;
}


class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ['en' , 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async{
    AppLocalizations appLocalizations = AppLocalizations(
      locale: locale
    );
    await appLocalizations.LoadLangJson();
    return appLocalizations ;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false ;
  
}