
class VaccineSlot
{
    int centreId;
    String name, address;    
    String stateName, blockName;
    String pincode;
    var lat, long;
    String fromTime, toTime;
    bool feeType;
    int totalVaccines=0;

    List<Session> sessions;   

    VaccineSlot({this.centreId,this.name,this.address,this.stateName,this.blockName, this.pincode,
                  this.lat, this.long, this.fromTime, this.toTime, this.feeType,this.sessions,this.totalVaccines});

    factory VaccineSlot.fromJSON( Map<String,dynamic> json){

      //print(json);
      int _totalVaccines = 0;

      List<Session> sessions_=[];

      List<dynamic> sessionsJson = json['sessions'];
      
      sessionsJson.forEach((session) {
        _totalVaccines += session['available_capacity'];   
        Session parsedSession = Session.fromJSON(session);        
        sessions_.add(parsedSession);   
      });         

        return VaccineSlot(
          centreId: json['center_id'],
          name: json['name'],
          address: json['address'],
          stateName: json['state_name'],
          blockName: json['block_name'],
          pincode: json['pincode'].toString(),
          lat: json['lat'],
          long: json['long'],
          fromTime: json['from'],
          toTime: json['to'],
          feeType: json['fee_type']=="Paid"?false:true,
          sessions: sessions_,
          totalVaccines: _totalVaccines
        );
        
              
    }

}

class Session{
  String sessionId;
  String date;
  int capacity;
  int minAgeLimit;
  bool allowAllAge;
  String vaccine;
  List<String> slots;
  int dose1;
  int dose2;

  Session({this.sessionId,this.date, this.capacity,this.minAgeLimit, this.allowAllAge, this.vaccine, this.slots, this.dose1,this.dose2});

  factory Session.fromJSON(Map<String,dynamic> json)
  {
    List<String> slots_=[];

    json['slots'].forEach((slot)=>slots_.add(slot.toString()));  

    return Session(
      sessionId: json['session_id'],
      date: json['date'],
      capacity: json['available_capacity'],
      minAgeLimit: json['min_age_limit'],
      allowAllAge: json['allow_all_age'],
      vaccine: json['vaccine'],
      slots: slots_,
      dose1:json['available_capacity_dose1'],
      dose2:json['available_capacity_dose2']
    );
  }

}