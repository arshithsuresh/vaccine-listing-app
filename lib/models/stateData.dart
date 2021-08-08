class StateData{
  int stateID;
  String stateName;

  List<Districts> districts;

  StateData({
    this.stateID,
    this.stateName,
    this.districts
  });

  Map<String,dynamic> toMap()=>{
    "stateId" : stateID,
    "stateName" : stateName,
    "districts" : districts
  };

  factory StateData.fromMap(Map<String,dynamic> json) => StateData(
    stateID: json["stateid"],
    stateName: json["stateName"]

  );

}

class Districts{
  String districtName;
  int districtID;  

  Districts({
    this.districtID,
    this.districtName
  });

  factory Districts.fromMap(Map<String,dynamic> json)=> Districts(
    districtName : json['districtName'],
    districtID: json['districtId']
  );

}