import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.archivedTasks.length >0,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => Dismissible(
              key: Key(cubit.archivedTasks[index]['id'].toString()),
              onDismissed: (direction) {
                cubit.deleteDatabase(id: cubit.archivedTasks[index]['id']);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color.fromRGBO(62, 31, 71, 50),
                      child: Text(
                        '${cubit.archivedTasks[index]['time']}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${cubit.archivedTasks[index]['title']}',
                            style: const TextStyle(
                              color: Color.fromRGBO(62, 31, 71, 50),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${cubit.archivedTasks[index]['date']}',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          cubit.updateDatabase(
                              status: 'done', id: cubit.archivedTasks[index]['id']);
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Color.fromRGBO(62, 31, 71, 50),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
            itemCount: cubit.archivedTasks.length,
          ),
          fallback: (context) => Center(
            child: Text('Archived Tasks',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        );
      },
    );
  }
}
