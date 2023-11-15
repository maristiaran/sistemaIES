import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sistema_ies/core/domain/entities/student.dart';
import 'package:sistema_ies/core/domain/entities/user_roles.dart';
import 'package:sistema_ies/core/domain/ies_system.dart';
import 'package:sistema_ies/crud_roles/domain/crud_roles.dart';
import 'package:sistema_ies/crud_roles/presentation/add_student_dialog.dart';
import 'package:sistema_ies/crud_roles/presentation/add_teacher_dialog.dart';
// import 'package:sistema_ies/crud_roles/presentation/adding_role_dialog.dart';

class CRUDRolesPage extends ConsumerWidget {
  const CRUDRolesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crudStatesProvider = ref.watch(
        IESSystem().crudTeachersAndStudentsUseCase.stateNotifierProvider);
    // final SearchController _searchController = SearchController();
    if (crudStatesProvider.stateName == CRUDRoleStateName.initial) {
      crudStatesProvider as CRUDRoleInitialState;
      // print("crudstate ${crudStatesProvider.searchedUsers}");
      Future<Student?> studentIfAny;
      return Scaffold(
        appBar: AppBar(
          // leading: null,
          automaticallyImplyLeading: false,
          title: const Text('Asignación de roles'),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    IESSystem().homeUseCase.onReturnFromOperation();
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  IESSystem().crudTeachersAndStudentsUseCase.cancel();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  print('Guardar cambios');
                },
                child: const Text(
                  'Guardar cambios',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: Center(
            child: Align(
                alignment: const Alignment(0.00, -1.0),
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    width: MediaQuery.of(context).size.width / 0.5,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          SearchAnchor(
                              // searchController: _searchController,
                              builder: (BuildContext context,
                                  SearchController controller) {
                            return SearchBar(
                              controller: controller,
                              padding:
                                  const MaterialStatePropertyAll<EdgeInsets>(
                                      EdgeInsets.symmetric(horizontal: 16.0)),
                              // onTap: () {
                              //   controller.openView();
                              // },
                              onChanged: (val) {
                                if (val.endsWith(",")) {
                                  IESSystem()
                                      .crudTeachersAndStudentsUseCase
                                      .searchUser(
                                          userDescription:
                                              val.substring(0, val.length - 1));

                                  // controller.openView();
                                }
                              },
                              // leading: const Icon(Icons.search),
                              trailing: <Widget>[
                                Tooltip(
                                  message: 'Buscar usuario',
                                  child: IconButton(
                                    isSelected: true,
                                    onPressed: () {},
                                    icon: const Icon(Icons.search),
                                    // selectedIcon:
                                    //     const Icon(Icons.brightness_2_outlined),
                                  ),
                                )
                              ],
                            );
                          }, suggestionsBuilder: (BuildContext context,
                                  SearchController controller) {
                            return [];
                            // if (crudStatesProvider.searchedUsers.isNotEmpty) {
                            //   controller.openView();

                            //   return crudStatesProvider.searchedUsers
                            //       .map((e) => ListTile(
                            //             title: const Text('ddd'),
                            //             // title:
                            //             //     Text("${e.surname} , ${e.firstname}"),
                            //             onTap: () {
                            //               IESSystem()
                            //                   .crudTeachersAndStudentsUseCase
                            //                   .selectUser(user: e);
                            //               controller.closeView(
                            //                   "${e.surname} , ${e.firstname}");
                            //               // });
                            //             },
                            //           ))
                            //       .toList(growable: false);
                            // } else {
                            //   return [];
                            // }
                          }),
                          ListView.builder(
                            itemCount: crudStatesProvider.searchedUsers.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) => ListTile(
                                title: Text(crudStatesProvider
                                    .searchedUsers[index]
                                    .toString()),
                                onTap: (() => IESSystem()
                                    .crudTeachersAndStudentsUseCase
                                    .selectUser(
                                        user: crudStatesProvider
                                            .searchedUsers[index])))),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(crudStatesProvider.selectedUser == null
                                ? 'Nombre(s): '
                                : 'Nombre(s): ${crudStatesProvider.selectedUser!.firstname}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(crudStatesProvider.selectedUser == null
                                ? 'Apellido: '
                                : 'Apellido: ${crudStatesProvider.selectedUser!.surname}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(crudStatesProvider.selectedUser == null
                                ? 'DNI: '
                                : 'DNI: ${crudStatesProvider.selectedUser!.dni.toString()}'),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text('Roles'),
                              const Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    Student? studentIfAny =
                                        await showDialog<Student?>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const AddingStudentDialog(
                                                newuserRoleIfAny: null,
                                              );
                                            });
                                    print(studentIfAny);
                                  },
                                  icon: const Icon(Icons.person_add_alt)),
                              IconButton(
                                  onPressed: () async {
                                    Teacher? teacherIfAny =
                                        await showDialog<Teacher?>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const AddingTeacherDialog(
                                                newuserRoleIfAny: null,
                                              );
                                            });
                                    print(teacherIfAny);
                                  },
                                  icon: const Icon(Icons.person_add))
                            ],
                          ),
                          SizedBox(
                              height: 150,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    crudStatesProvider.selectedUser == null
                                        ? 0
                                        : crudStatesProvider
                                            .selectedUser!.roles.length,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(crudStatesProvider
                                      .selectedUser!.roles[index]
                                      .toString()),
                                  subtitle: Text(crudStatesProvider
                                      .selectedUser!.roles[index]
                                      .subtitle()),
                                  trailing: IconButton(
                                      onPressed: () => {
                                            IESSystem()
                                                .crudTeachersAndStudentsUseCase
                                                .removeUserRole(
                                                    userRole: crudStatesProvider
                                                        .selectedUser!
                                                        .roles[index])
                                          },
                                      icon: const Icon(Icons.delete)),
                                ),
                              )),
                        ])))),
      );
    } else {
      return Container();
    }
  }
}
