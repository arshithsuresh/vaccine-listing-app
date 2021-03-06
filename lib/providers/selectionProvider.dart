import 'dart:convert';

import 'package:cowinapp/models/vaccine.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;


enum AgeList{
  Above18,
  Above45,
  AllAges
}

enum Doses{
  Dose1,
  Dose2,
  Any
}

class LocationSelectorProvider extends ChangeNotifier {
  int _selectedState = -1;
  int _selectedDistrict = -1;
  DateTime _date;  
  int get state => _selectedState;
  int get district => _selectedDistrict;

  String get date => _date.day.toString()+"-"+_date.month.toString()+"-"+_date.year.toString();
  
  List<VaccineSlot> vaccineSlots =[];

  VaccineSlot selectedVaccine;

  AgeList ageList = AgeList.Above18;
  Doses doseSort = Doses.Any;


  LocationSelectorProvider() {
    _date = DateTime.now();
    _selectedState = -1;
    _selectedDistrict = -1;
  }

  void selectState(int stateid) {
    _selectedState = stateid;
    notifyListeners();
  }

  void selectDose(Doses dose)
  {
    doseSort = dose;
    notifyListeners();
  }

  void selectVaccine(VaccineSlot vaccine){

      selectedVaccine = vaccine;
      notifyListeners();
  }

  void clearVaccineSlot()
  {
      vaccineSlots = [];
      notifyListeners();
  }

  void setAgeSorting(AgeList value)
  {
     ageList = value;
     notifyListeners();
  }
  void getVaccineSlotAPI() async
  {
    
    String APIURL = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?";    

    var url = Uri.parse(APIURL+"district_id="+district.toString()+"&"+"date="+date);
    print(url);
    var response = await http.get(url);   
    
    if(response.statusCode == 200)
    {      
      var json = jsonDecode(response.body) as Map<String,dynamic>;        
      List<VaccineSlot> slots = List<VaccineSlot>.from(json['centers'].map((e) => VaccineSlot.fromJSON(e)).toList());   
      
      slots.sort((a,b)=>b.totalVaccines.compareTo(a.totalVaccines));

      vaccineSlots = slots;     
    }   

    notifyListeners();    
  }

  void selectDistrict(int districtId) {
    _selectedDistrict = districtId;
    
    notifyListeners();
  }
}
