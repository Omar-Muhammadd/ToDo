import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, AppStates state) {
        if (state is AppChangeInsertDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Center(child: Text('${cubit.Appbar[cubit.CurrentIndex]}')),
          ),
          body: cubit.Tasks[cubit.CurrentIndex],
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromRGBO(62, 31, 71, 50),
            onPressed: () {
              if (cubit.sheetIsOpen) {
                if (formKey.currentState!.validate()) {
                  cubit.insertDataBase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text);

                }
                titleController.clear();
                timeController.clear();
                dateController.clear();
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                cursorColor: Color.fromRGBO(62, 31, 71, 50),
                                autofocus: true,
                                controller: titleController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Title must not be Empty';
                                  }
                                  return null;
                                },

                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                  prefixIcon: Icon(Icons.title),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,color: Color.fromRGBO(62, 31, 71, 50),
                                    )
                                  ),

                                ),
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: timeController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Time must not be Empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Time',
                                  prefixIcon: Icon(Icons.watch_later_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.datetime,
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder: (context, child) {
                                        return Theme(
                                            data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    const ColorScheme.light(
                                              primary: Color.fromRGBO(
                                                  62, 31, 71, 50),
                                            )),
                                            child: MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      alwaysUse24HourFormat:
                                                          true),
                                              child: child!,
                                            ));
                                      }).then((value) {
                                    timeController.text =
                                        value!.format(context);
                                  });
                                },
                                showCursor: true,
                                readOnly: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  showCursor: true,
                                  readOnly: true,
                                  controller: dateController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be Empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Date',
                                    prefixIcon: Icon(Icons.date_range_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2025),
                                        builder: (context, child) {
                                          return Theme(
                                              data: Theme.of(context).copyWith(
                                                  colorScheme:
                                                      const ColorScheme.light(
                                                primary: Color.fromRGBO(
                                                    62, 31, 71, 50),
                                              )),
                                              child: MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        alwaysUse24HourFormat:
                                                            true),
                                                child: child!,
                                              ));
                                        }).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                      elevation: 30,
                    )
                    .closed
                    .then((value) {
                  cubit.changeSheetIsOpen(isOpen: false);
                });
                cubit.changeSheetIsOpen(isOpen: true);
              }
            },
            child: cubit.sheetIsOpen == false
                ? const Icon(Icons.edit)
                : const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined),
                label: 'Archived',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.CurrentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
          ),
        );
      }),
    );
  }
}
