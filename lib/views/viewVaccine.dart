import 'package:cowinapp/models/vaccine.dart';
import 'package:cowinapp/providers/selectionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaccineViewer extends StatefulWidget {
  @override
  _VaccineViewerState createState() => _VaccineViewerState();
}

class _VaccineViewerState extends State<VaccineViewer> {
  LocationSelectorProvider locationSelector;

  @override
  Widget build(BuildContext context) {
    locationSelector = Provider.of<LocationSelectorProvider>(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: (){
          Navigator.pop(context);
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.arrow_back,color: Colors.white,),         
        
      ),
      body: Container(
        height: size.height,
        padding: EdgeInsets.only(top: 38, left: 6, right: 6, bottom: 8),
        child: Consumer<LocationSelectorProvider>(
          builder: (context, model, child) {
            if (model.selectedVaccine != null) {
              VaccineSlot selectedVaccine = model.selectedVaccine;

              return (Column(
                children: [
                  Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        selectedVaccine.name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(selectedVaccine.blockName),                      
                      Text("Pincode : " + selectedVaccine.pincode),
                      SizedBox(height: 8),
                      selectedVaccine.feeType
                          ? Text(
                              "FeeType : Free",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )
                          : Text(
                              "FeeType : Paid",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.orange),
                            ),
                      SizedBox(height: 8),
                      Text("Available on Dates",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: size.height - 226,
                        child: ListView.builder(
                            itemCount: selectedVaccine.sessions.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Session session = selectedVaccine.sessions[index];
                              return (Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ]),
                                child: Column(
                                  children: [
                                    Text(session.date,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          session.vaccine,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Total : " +
                                              session.capacity.toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                            "Dose 1 :" +
                                                session.dose1.toString(),
                                            style: TextStyle(fontSize: 18)),
                                        Text(
                                            "Dose 2 :" +
                                                session.dose2.toString(),
                                            style: TextStyle(fontSize: 18))
                                      ],
                                    ),
                                    Text(
                                        "Age Limit : " +
                                            session.minAgeLimit.toString(),
                                        style: TextStyle(fontSize: 18))
                                  ],
                                ),
                              ));
                            }),
                      )
                    ],
                  ))
                ],
              ));
            }

            return Center(
                child: Text(
                    "No Vaccine Centre has been selected. Please go back and select one."));
          },
        ),
      ),
    );
  }
}
