import 'package:cowinapp/models/vaccine.dart';
import 'package:cowinapp/providers/selectionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../util/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationSelectorProvider locationSelector;

  List<VaccineSlot> vaccineSlots = [];

  @override
  Widget build(BuildContext context) {
    locationSelector = Provider.of<LocationSelectorProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.sort_rounded),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Consumer<LocationSelectorProvider>(
                      builder: (context, model, child) {
                    return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sort Vaccine By",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 32),

                        Text("By Age"),
                        Container(                          
                          height: 30,
                          child: Row(
                            
                            children: [
                              
                              Radio(
                                value: AgeList.Above18,
                                groupValue: locationSelector.ageList,
                                onChanged: (value) {
                                  locationSelector
                                      .setAgeSorting(AgeList.Above18);
                                },
                              ),
                              Text(" 18"),
                              Radio(
                                value: AgeList.Above45,
                                groupValue: locationSelector.ageList,
                                onChanged: (value) {
                                  locationSelector
                                      .setAgeSorting(AgeList.Above45);
                                },
                              ),
                              Text(" 45"),
                              Radio(
                                value: AgeList.AllAges,
                                groupValue: locationSelector.ageList,
                                onChanged: (value) {
                                  locationSelector
                                      .setAgeSorting(AgeList.AllAges);
                                },
                              ),
                              Text("All"),
                              
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        
                        Text("By Dose"),
                        Container(                          
                          height: 30,
                          child: Row(
                            
                            children: [
                              
                              Radio(
                                value: Doses.Dose1,
                                groupValue: locationSelector.doseSort,
                                onChanged: (value) {
                                  locationSelector
                                      .selectDose(Doses.Dose1);
                                },
                              ),
                              Text(" 1"),
                              Radio(
                                value:  Doses.Dose2,
                                groupValue: locationSelector.doseSort,
                                onChanged: (value) {
                                  locationSelector
                                      .selectDose(Doses.Dose2);
                                },
                              ),
                              Text(" 2"),
                              Radio(
                                value: Doses.Any,
                                groupValue: locationSelector.doseSort,
                                onChanged: (value) {
                                  locationSelector
                                      .selectDose(Doses.Any);
                                },
                              ),
                              Text("Any"),
                              
                            ],
                          ),
                        ),
                      ],
                    ));
                  }),
                );
              });
        },
      ),
      body: Container(
        margin: EdgeInsets.only(top: 42),
        child: Center(
          child: Column(
            children: [
              Text("Select State"),
              SizedBox(height: 8),
              FutureBuilder(
                  future: DBProvider.db.getStates(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print(snapshot.data);
                      List states = snapshot.data;
                      return Container(
                        height: 38,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            primary: true,
                            itemCount: states.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                (locationSelector.state ==
                                                        states[index]
                                                            ['stateid'])
                                                    ? Colors.teal
                                                    : Colors.black),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50)))),
                                    onPressed: () {
                                      locationSelector.selectState(
                                          states[index]['stateid']);
                                    },
                                    child: Text(states[index]['statename'])),
                              );
                            }),
                      );
                    }

                    return CircularProgressIndicator();
                  }),
              SizedBox(height: 12),
              Text("Select District"),
              SizedBox(height: 8),
              Consumer<LocationSelectorProvider>(
                  builder: (context, model, child) {
                if (model.state > 0) {
                  return FutureBuilder(
                      future: DBProvider.db.getDistricts(model.state),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          //print(snapshot.data);
                          List districts = snapshot.data;
                          return Container(
                            height: 38,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                primary: true,
                                itemCount: districts.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(left: 8, right: 8),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>((locationSelector
                                                            .district ==
                                                        districts[index]['id'])
                                                    ? Colors.teal
                                                    : Colors.black),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)))),
                                        onPressed: () {
                                          locationSelector.clearVaccineSlot();
                                          locationSelector.selectDistrict(
                                              districts[index]['id']);
                                          locationSelector.getVaccineSlotAPI();
                                        },
                                        child:
                                            Text(districts[index]['district'])),
                                  );
                                }),
                          );
                        }

                        return CircularProgressIndicator();
                      });
                }
                return Text("Select a State");
              }),
              SizedBox(
                height: 12,
              ),
              Consumer<LocationSelectorProvider>(
                  builder: (context, model, child) {
                return Column(
                  children: [
                    Text("Available Slots",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Total Slots Found : " +
                        model.vaccineSlots.length.toString()),
                  ],
                );
              }),
              SizedBox(
                height: 12,
              ),
              Consumer<LocationSelectorProvider>(
                  builder: (context, model, child) {
                if (model.vaccineSlots.length > 0) {
                  vaccineSlots = model.vaccineSlots;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: vaccineSlots.length,
                        itemBuilder: (context, index) {
                          if (vaccineSlots.length > 0) {
                            VaccineSlot vaccineSlot = vaccineSlots[index];
                            if (vaccineSlot.totalVaccines > 0) {
                              return GestureDetector(
                                onTap: () {
                                  locationSelector.selectVaccine(vaccineSlot);
                                  print("Clicked" + vaccineSlot.name);
                                  Navigator.pushNamed(context, "/viewVaccine");
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(vaccineSlot.name,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "Total Available Vaccines : " +
                                              vaccineSlot.totalVaccines
                                                  .toString(),
                                          style: TextStyle(fontSize: 16)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(vaccineSlot.pincode,
                                              style: TextStyle(fontSize: 16)),
                                          Text(vaccineSlot.blockName,
                                              style: TextStyle(fontSize: 16)),
                                          vaccineSlot.feeType
                                              ? Text(
                                                  "Free",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              : Text(
                                                  "Paid",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.orange),
                                                )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(vaccineSlot.name,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                    Text("Total Available Vaccines : 0",
                                        style: TextStyle(fontSize: 16))
                                  ],
                                ));
                          }

                          return Text(
                              "No Vaccine Sessions Found!\nSelect State or District.");
                        }),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 64),
                        child: CircularProgressIndicator()),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Select State and District and Press Search!",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
