part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Province> provinceData = [];
  List<Costs> calculatedCosts = [];
  bool dataReady = false;
  bool isFirstLoad = true;
  bool isLoading = false;
  bool isLoadingCityOrigin = false;
  bool isLoadingCityDestination = false;

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic cityDataDestination;
  dynamic cityIdDestination;
  dynamic selectedCityOrigin;
  dynamic selectedCityDestination;

  dynamic selectedProvinceOrigin;
  dynamic selectedProvinceDestination;
  dynamic provinceData;

  dynamic selectedCourier;
  dynamic weight;
  // dynamic calculatedCosts;
  dynamic dataLength;

  TextEditingController weightTextController = TextEditingController();

  Future<List<Province>> getProvinces() async {
    ////
    dynamic prov;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        prov = value;

        ///
        isLoading = false;
      });
    });
    return prov;
  }

  Future<List<City>> getCities(var provId) async {
    ////
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  Future<List<Costs>> getCosts(
      var originId, var destinationId, var weight, var courier) async {
    List<Costs> costs = await MasterDataService.getCosts(
      originId,
      destinationId,
      weight,
      courier,
    );
    return costs;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    provinceData = getProvinces(); ////
    cityDataOrigin = getCities("5");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Hitung Ongkir"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: DropdownButton<String>(
                                  value: selectedCourier,
                                  hint: selectedCourier == null
                                      ? Text("Pilih Jasa")
                                      : Text(selectedCourier),
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedCourier = value!;
                                    });
                                  },
                                  items: <String>['jne', 'tiki', 'pos']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value.toUpperCase(),
                                        child: Text(value));
                                  }).toList())),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: weightTextController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Berat (gr)',
                                    labelStyle:
                                        TextStyle(color: Colors.grey.shade500)),
                              ),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("Origin"),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: FutureBuilder<List<Province>>(
                                  future: provinceData,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                        hint: selectedProvinceOrigin == null
                                            ? Text("Pilih Provinsi")
                                            : Text(selectedProvinceOrigin
                                                .province),
                                        items: snapshot.data
                                            ?.map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.province.toString()));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCityOrigin = null;
                                            selectedProvinceOrigin = value;
                                            isLoadingCityOrigin = true;
                                            cityDataOrigin = getCities(
                                                selectedProvinceOrigin
                                                    .provinceId
                                                    .toString());
                                            isLoadingCityOrigin = false;
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Tidak ada data");
                                    }
                                    return UiLoading.loadingSmall();
                                  })),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                              flex: 3,
                              child: FutureBuilder<List<City>>(
                                  future: cityDataOrigin,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        isLoadingCityOrigin) {
                                      return UiLoading.loadingSmall();
                                    }
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          items: snapshot.data
                                              ?.map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()));
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedCityOrigin = value;
                                              cityIdOrigin =
                                                  selectedCityOrigin.cityId;
                                            });
                                          });
                                    }
                                    return DropdownButton(
                                      isExpanded: true,
                                      items: [],
                                      value: selectedCityOrigin,
                                      onChanged: (value) {
                                        Null;
                                      },
                                      elevation: 4,
                                      isDense: false,
                                      hint: Text('Select an item'),
                                      disabledHint: Text('Pilih kota'),
                                    );
                                  }))
                        ],
                      ),
                      Spacer( flex: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 240,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                                onPressed: () async {
                                  setState(() {
                                    // dataReady = true;
                                    isLoading = true;
                                  });
                                  List<Costs> updatedCosts = await getCosts(
                                    selectedCityOrigin.cityId,
                                    selectedCityDestination.cityId,
                                    weightTextController.text,
                                    selectedCourier,
                                  );

                                  setState(() {
                                    calculatedCosts = updatedCosts;
                                    isLoading = false;
                                  });
                                },
                                child: Text(
                                  "Hitung Estimasi Harga",
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ],
                      ),
                      // Container(
                      //   width: 240,
                      //   child: FutureBuilder<List<City>>(
                      //       future: cityDataOrigin,
                      //       builder: (context, snapshot) {
                      //         if (snapshot.hasData) {
                      //           return DropdownButton(
                      //               isExpanded: true,
                      //               value: selectedCityOrigin,
                      //               icon: Icon(Icons.arrow_drop_down),
                      //               iconSize: 30,
                      //               elevation: 4,
                      //               style: TextStyle(color: Colors.black),
                      //               hint: selectedCityOrigin == null
                      //                   ? Text('Pilih kota')
                      //                   : Text(selectedCityOrigin.cityName),
                      //               items: snapshot.data!
                      //                   .map<DropdownMenuItem<City>>(
                      //                       (City value) {
                      //                 return DropdownMenuItem(
                      //                     value: value,
                      //                     child:
                      //                         Text(value.cityName.toString()));
                      //               }).toList(),
                      //               onChanged: (newValue) {
                      //                 setState(() {
                      //                   selectedCityOrigin = newValue;
                      //                   cityIdOrigin =
                      //                       selectedCityOrigin.cityId;
                      //                 });
                      //               });
                      //         } else if (snapshot.hasError) {
                      //           return Text("Tidak ada data");
                      //         }
                      //         return UiLoading.loadingSmall();
                      //       }),
                      // )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: calculatedCosts.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("Data tidak ditemukan"),
                          )
                        : ListView.builder(
                            itemCount: calculatedCosts.length,
                            itemBuilder: (context, index) {
                              return CardCosts(calculatedCosts[index]);
                            },
                          )),
              ),
              // Flexible(
              //   flex: 5,
              //   child: Container(
              //       width: double.infinity,
              //       height: double.infinity,
              //       child: provinceData.isEmpty
              //           ? const Align(
              //               alignment: Alignment.center,
              //               child: Text("Data tidak ditemukan"),
              //             )
              //           : ListView.builder(
              //               itemCount: provinceData.length,
              //               itemBuilder: (context, index) {
              //                 return CardProvince(provinceData[index]);
              //               })),
              // ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}
