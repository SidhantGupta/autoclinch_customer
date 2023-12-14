import 'package:autoclinch_customer/keys.dart';
import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/home_response.dart';
import 'package:autoclinch_customer/notifiers/home_notifiers.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_place_picker/map_place_picker.dart' show MapPicker, MapAddress;
import 'package:provider/provider.dart' show Consumer, Provider;

//ignore: must_be_immutable
class VendorListScreen extends StatefulWidget {
  // const VendorListScreen({Key? key}) : super(key: key);

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

final GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();

class _VendorListScreenState extends State<VendorListScreen> {
  List<Vendor> _vendors = List.empty();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeApi(context, isFirst: _isFirst);
      _isFirst = false;
    });
  }

  void _homeApi(BuildContext context, {bool isFirst = false}) async {
    if (_mapAddress == null) {
      _checkLocation(context, isFirst);
      return;
    }
    try {
      if (_loadingNotifier?.isLoading == false) {
        _loadingNotifier?.isLoading = true;
      }
    } catch (e) {}
    final params = {
      'lat': _mapAddress!.latitude.toString(),
      'lng': _mapAddress!.longitude.toString(),
      'status': _onlyAvailableVendor ? 'yes' : 'no',
      // 'radius': '56'
      'searchKey': _searchKey
    };
    final selectedFilter = _filterModels.where((element) => element.isSelected).toList();
    if (selectedFilter.isNotEmpty) {
      params.addAll(selectedFilter.asMap().map((key, value) => MapEntry('service_list[$key]', value.name)));
    }
    final HomeResponse? response = await ApiService().execute<HomeResponse>('getnearestvendors', params: params);
    _vendors = response?.homeData?.vendorList ?? [];

    ////("Vendor list" + _vendors.toString());
    if (_filterModels.isEmpty) {
      _filterModels = response?.homeData?.filterServiceList
              ?.map((e) => _FilterModelUnMutable(name: e.serviceName, id: 0, isSelected: false))
              .toList() ??
          [];
    }
    _loadingNotifier?.isLoading = false;
    _vendorsListNotifier?.notify();
  }

  MapAddress? _mapAddress;

  void _checkLocation(BuildContext context, bool isFirst) async {
    _mapAddress = await SharedPreferenceUtil().getMapAddress();
    if (_mapAddress == null || isFirst) {
      _openMap(context, (mapAddress) {
        ////('MJM _checkLocation $mapAddress');0
        if (mapAddress == null) {
          Navigator.pop(context);
        } else {
          _homeApi(context);
        }
      });
    } else {
      _locationNotifier?.notify();
      _homeApi(context);
    }
  }

  void _openMap(BuildContext context, void Function(MapAddress?) addressSelected) {
    final LatLng? _latLng = _mapAddress == null ? null : LatLng(_mapAddress!.latitude, _mapAddress!.longitude);
    MapPicker.show(context, MAP_API_KEY, (address) {
      if (address != null) {
        SharedPreferenceUtil().storeMapAddress(address);
        _mapAddress = address;
        addressSelected(address);
        _locationNotifier?.notify();
      }
    }, initialLocation: _latLng, title: 'Pick your location');
  }

  HomeLoadingNotifier? _loadingNotifier;

  HomeVendorsNotifier? _vendorsListNotifier;

  HomeLocationNotifier? _locationNotifier;

  String _searchKey = '';

  bool _isFirst = true;

  @override
  Widget build(BuildContext context) {
    _loadingNotifier = Provider.of<HomeLoadingNotifier>(context, listen: false);
    _vendorsListNotifier = Provider.of<HomeVendorsNotifier>(context, listen: false);

    _locationNotifier = Provider.of<HomeLocationNotifier>(context, listen: false);
    // _loadingNotifier?.reset(loading: true);
    _loadingNotifier?.reset();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenWidthNew = MediaQuery.of(context).size.width - 40;

    final TextStyle _labelStyle = TextStyle(fontSize: 14.0, color: Color(0xFF2A2935));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Near By Vendors',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        automaticallyImplyLeading: true,
        // leading: IconButton(onPressed: null , Icon(Icons.arrow_forward_ios_outlined)),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      Container(
                          // height: 70,

                          // color: Color.fromARGB(255, 252, 203, 82),
                          padding: const EdgeInsets.only(top: 20, bottom: 45),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[Color.fromARGB(255, 255, 176, 101), Color.fromARGB(255, 250, 228, 205)],
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  size: 24,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Consumer<HomeLocationNotifier>(
                                    builder: (context, value, child) => Text(
                                        // '29 Street of NY, New York City, USA',
                                        _mapAddress?.address ?? 'Select location',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: _labelStyle),
                                  ),
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.my_location_outlined,
                                    size: 26,
                                  ),
                                  onTap: () => _openMap(context, (address) {
                                    _homeApi(context);
                                  }),
                                )
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 33,
                      ),
                    ],
                  ),

                  //
                  // Positioned(
                  //   bottom: 10,
                  //   child: Container(
                  //     width: screenWidthNew,
                  //     child: Card(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //           height: 50,
                  //           // color: const Color(0xFFFAF9F
                  //           // 7),
                  //           child: Row(
                  //             children: [
                  //               TextField(
                  //                 decoration: InputDecoration(
                  //                     icon: Icon(Icons.account_balance)),
                  //               ),

                  //               Text(
                  //                 'Enable Virtual Service',
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.normal,
                  //                   fontSize: 20.0, // double
                  //                 ),
                  //               ),

                  //               // SwitchScreen(value: isSwitched)
                  //             ],
                  //           )

                  //           // color: Colors.grey[100],
                  //           ,
                  //         ),
                  //       ),
                  //     ),
                  //   ),

                  // )

                  Container(
                    width: screenWidthNew,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(Icons.search_outlined, color: Color.fromARGB(255, 246, 130, 30)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Form(
                                  key: _searchFormKey,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: "Search",
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      if (value.isNullOrEmpty && value.trim() != _searchKey) {
                                        _searchKey = '';
                                        _homeApi(context);
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (value) {
                                      final _newValue = value.trim();
                                      if (_newValue != _searchKey) {
                                        _searchKey = _newValue;
                                        _homeApi(context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showFilters(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                    primary: Color.fromARGB(255, 244, 245, 247),
                                  ),
                                  icon: Icon(
                                    Icons.filter_list_outlined,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    'Filter',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),

                  //
                ],
              ),
            ),
            Expanded(child: Consumer<HomeLoadingNotifier>(
              builder: (context, value, child) {
                if (_vendors.length == 0 && !value.isLoading) {
                  return Center(
                    child: Text(
                      'No vendors found in this area',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: _vendors.length,
                  itemBuilder: (context, index) {
                    final Vendor _vendorDetails = _vendors[index];
                    return Card(
                      child: InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/vendordetails', arguments: _vendorDetails.businessInfo.id),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Container(
                                  child: Column(
                                    children: [
                                      _vendorDetails.businessInfo.profileImage == null &&
                                              _vendorDetails.businessInfo.profileImage!.isEmpty
                                          ? Container(
                                              height: 80,
                                              child: Image.asset(
                                                'assets/images/logo/samplepin.jpeg',
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                          : Container(
                                              height: 80,
                                              child: Image.network(
                                                _vendorDetails.businessInfo.profileImage ?? "",
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                      Container(
                                        width: 70,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                        color: _vendorDetails.isOnline ? Colors.green : Color(0xFFEBEBEB),
                                        child: Text(
                                          _vendorDetails.isOnline ? 'Online' : 'Offline',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: _vendorDetails.isOnline ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      Text(
                                        _vendorDetails.businessInfo.businessName ?? '',
                                        style: _labelStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      _vendorDetails.businessInfo.is_verified == "yes"
                                          ? Image.asset(
                                              'assets/images/checked.jpeg',
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.contain,
                                            )
                                          : Text(""),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Divider(),
                                  const SizedBox(height: 3),
                                  Container(
                                    width: 90,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      // margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),

                                      color: Color.fromARGB(255, 249, 227, 206),

                                      child: Container(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.star_outlined, color: Color.fromARGB(255, 246, 130, 30)),
                                            const SizedBox(width: 4),
                                            Text(
                                              _vendorDetails.rating.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15.0,
                                                  color: Color.fromARGB(255, 246, 130, 30)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.home_work_outlined,
                                        color: Color.fromARGB(255, 141, 158, 166),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(_vendorDetails.businessInfo.address ?? '',
                                            style: TextStyle(color: Color.fromARGB(255, 98, 99, 112))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.place_outlined,
                                        color: Color.fromARGB(255, 141, 158, 166),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text('${_vendorDetails.businessInfo.distanceInt} KM',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 98, 99, 112),
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ))
          ],
        ),
      ).setScreenLoader<HomeLoadingNotifier>(),
    );
  }

  List<_FilterModelUnMutable> _filterModels = List.of({
    // _FilterModelUnMutable(name: 'Painting', id: 1),
    // _FilterModelUnMutable(name: 'name', id: 1),
    // _FilterModelUnMutable(name: 'name', id: 1),
    // _FilterModelUnMutable(name: 'name', id: 1),
  }, growable: false);

  bool _onlyAvailableVendor = true;

  void _showFilters(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final mutableList = _filterModels.map((e) => e.toMutable()).toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FilterScreen(mutableList, (list, status) {
          _onlyAvailableVendor = status;
          _filterModels = list.map((e) => e.toUnMutable()).toList();
          Navigator.pop(context);
          _homeApi(context);
        }, _onlyAvailableVendor),
      ),
    );
  }
}

extension PaddingWidget on Widget {
  Widget paddingAll(double padding) => Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double vertical = 0.0, double horizontal = 0.0}) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical), child: this);
}

class _FilterModelMutable {
  final String name;
  final int id;
  bool isSelected;

  _FilterModelMutable({required this.name, required this.id, this.isSelected = true});
  _FilterModelUnMutable toUnMutable() {
    return _FilterModelUnMutable(name: name, id: id, isSelected: isSelected);
  }
}

class _FilterModelUnMutable {
  final String name;
  final int id;
  final bool isSelected;

  _FilterModelUnMutable({required this.name, required this.id, this.isSelected = true});
  _FilterModelMutable toMutable() {
    return _FilterModelMutable(name: name, id: id, isSelected: isSelected);
  }
}

// class _FilterNotifier extends ChangeNotifier {
//   bool _expandVendor = true, _expandFilter = true;
//   bool get expandVendor => _expandVendor;
//   bool get expandFilter => _expandFilter;
//   set expandVendor(bool expand) {
//     _expandVendor = expand;
//     notifyListeners();
//   }

//   set expandFilter(bool expand) {
//     _expandFilter = expand;
//     notifyListeners();
//   }

//   void filterSelected() {
//     ////('MJM filterSelected()');

//     notifyListeners();
//   }
// }

class FilterScreen extends StatefulWidget {
  final List<_FilterModelMutable> filterModel;
  final Function(List<_FilterModelMutable>, bool status) applyEvent;
  final _onlyAvailableVendor;
  FilterScreen(this.filterModel, this.applyEvent, this._onlyAvailableVendor, {Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool _expandVendor = true, _expandFilter = true, _onlyAvailableVendor = false;
  @override
  void initState() {
    _onlyAvailableVendor = widget._onlyAvailableVendor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                widget.applyEvent(widget.filterModel, _onlyAvailableVendor);
              },
              child: Text(
                'Apply',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFEF2E6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ).paddingSymmetric(horizontal: 15),
        const Divider(),
        Expanded(
          child: ListView(
            // physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            children: [
              ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  ////('expansionCallback $isExpanded ');
                  setState(() {
                    _expandVendor = !isExpanded;
                  });
                },
                elevation: 0,
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Availabe Vendors',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: CheckboxListTile(
                      onChanged: (value) {
                        setState(() {
                          if (value != null) _onlyAvailableVendor = value;
                        });
                      },
                      value: _onlyAvailableVendor,
                      title: Text('Only Available'),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    isExpanded: _expandVendor,
                  )
                ],
              ),
              const Divider(),
              ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    _expandFilter = !isExpanded;
                  });
                },
                elevation: 0,
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Services',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => CheckboxListTile(
                        onChanged: (value) {
                          setState(() {
                            widget.filterModel[index].isSelected = value ?? true;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                        value: widget.filterModel[index].isSelected,
                        title: Text(widget.filterModel[index].name),
                      ),
                      itemCount: widget.filterModel.length,
                    ),
                    isExpanded: _expandFilter,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
