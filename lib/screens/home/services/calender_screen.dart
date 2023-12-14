import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/attendence.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../network/model/service_history.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key, required this.vehicleId}) : super(key: key);

  final int vehicleId;
  @override
  State<CalenderScreen> createState() => _CalenderScreenState(vehicleId);
}

class _CalenderScreenState extends State<CalenderScreen> {
  late Future<AttendanceModel?> _future;

  final now = DateTime.now();

  final List<DateTime> absentDates = [];
  final List<DateTime> presentDates = [];
  final List<DateTime> noMarkedDates = [];
  final List<DateTime> notAvailable = [];

  _CalenderScreenState(this.vehicleId);

  final int vehicleId;

  @override
  void initState() {
    _future = ApiService().execute<AttendanceModel>(
      'get-attendances',
      params: {'date': DateFormat('yyyy-MM-dd').format(now),'vehicle_id': vehicleId.toString()},
    ).then((value) {
      if (value != null) {
        for (var item in value.attendance?.absent ?? []) {
          absentDates.add(item);
        }
        for (var item in value.attendance?.present ?? []) {
          presentDates.add(item);
        }
        for (var item in value.attendance?.notMarked ?? []) {
          noMarkedDates.add(item);
        }
        for (var item in value.attendance?.notAvailable ?? []) {
          notAvailable.add(item);
        }
      }
      setState(() {});
      return value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder<AttendanceModel?>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime(DateTime.now().year - 1),
                      lastDay: DateTime(DateTime.now().year + 1),
                      focusedDay: DateTime.now(),
                      calendarFormat: CalendarFormat.month,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      daysOfWeekVisible: true,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        ),
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        print(selectedDay);
                      },
                      selectedDayPredicate: (day) {
                        for (var item in absentDates) {
                          if (item.day == day.day && item.month == day.month && item.year == day.year) {
                            return true;
                          }
                        }

                        for (var item in presentDates) {
                          if (item.day == day.day && item.month == day.month && item.year == day.year) {
                            return true;
                          }
                        }

                        for (var item in noMarkedDates) {
                          if (item.day == day.day && item.month == day.month && item.year == day.year) {
                            return true;
                          }
                        }

                        for (var item in notAvailable ) {
                          if (item.day == day.day && item.month == day.month && item.year == day.year) {
                            return true;
                          }
                        }


                        return false;
                      },
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        todayTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        todayDecoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          shape: BoxShape.circle,
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        weekendDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, date, _) {
                          for (var item in absentDates) {
                            if (item.day == date.day && item.month == date.month && item.year == date.year) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          }

                          for (var item in presentDates) {
                            if (item.day == date.day && item.month == date.month && item.year == date.year) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          }

                          for (var item in noMarkedDates) {
                            if (item.day == date.day && item.month == date.month && item.year == date.year) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            }
                          }

                          for (var item in notAvailable) {
                            if (item.day == date.day && item.month == date.month && item.year == date.year) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          }
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(height: 10),
                            Text('Present'),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(height: 10),
                            Text('Absent'),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(height: 10),
                            Text('Not Marked'),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(height: 10),
                            Text('Not Available'),
                          ],
                        )
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.history),
        label: Text('History'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServiceHistory(vehicleId: vehicleId,)),
          );
        },
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
    );
  }
}

class ServiceHistory extends StatefulWidget {
  const ServiceHistory({Key? key,required this.vehicleId}) : super(key: key);

  final int vehicleId;

  @override
  State<ServiceHistory> createState() => _ServiceHistoryState(vehicleId);
}

class _ServiceHistoryState extends State<ServiceHistory> {
  late Future<ServiceHistoryModel?> _futureServiceHistory;

  _ServiceHistoryState(this.vehicleId);

  final int vehicleId;


  @override
  void initState() {
    _futureServiceHistory =
        ApiService().execute<ServiceHistoryModel>('history-packages/${vehicleId}', isGet: true, isThrowExc: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service History'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<ServiceHistoryModel?>(
            future: _futureServiceHistory,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var history = snapshot.data!.history![index];
                    return Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.1),
                        //     spreadRadius: 5,
                        //     blurRadius: 7,
                        //     offset: Offset(0, 3), // changes position of shadow
                        //   ),
                        // ],
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.green, size: 15),
                              SizedBox(width: 10),
                              Text(
                                history.title ?? '',
                                style: TextStyle(fontSize: 18),
                              ),
                              Spacer(),
                              Visibility(
                                visible: history.amount != null,
                                child: Text(
                                  '₹ ${history.amount ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                replacement: Text(
                                  'N/A',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Start Date', style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 10),
                                  Text(
                                    DateFormat.yMMMMd().format(history.fromDate ?? DateTime.now()),
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('End Date', style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 10),
                                  Text(
                                    DateFormat.yMMMMd().format(history.toDate ?? DateTime.now()),
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data!.history?.length ?? 0,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
