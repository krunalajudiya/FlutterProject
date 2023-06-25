import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter/material.dart';

import '../../../../commonWidgets/common_widgets.dart';
import '../../../../constants/ColorCode.dart';
import '../../../../constants/image_path.dart';
import '../../../../constants/login/login_constants.dart';

rollSelectDialogShow(
    context, List<dynamic> roleList, firstName, middleName, lastName) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return RoleSelectDialog(roleList, firstName, middleName, lastName);
      });
}

class RoleSelectDialog extends StatefulWidget {
  final List<dynamic> _roleList;
  final String? firstName, middleName, lastName;

  const RoleSelectDialog(
      this._roleList, this.firstName, this.middleName, this.lastName,
      {super.key});

  @override
  State<StatefulWidget> createState() => _RoleSelectDialogState();
}

class _RoleSelectDialogState extends State<RoleSelectDialog> {
  int selectRole = 0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.transparent,
      child: dialogContent(),
    );
  }

  Widget dialogContent() {
    return Container(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImagePath.userAvtar,
              height: 60,
            ),
            CommonWidgets.verticalSpace(5),
            Text(
              "${CommonFunction.isNullOrIsEmpty(widget.firstName) ? "" : "${widget.firstName!} "}${CommonFunction.isNullOrIsEmpty(widget.middleName) ? "" : "${widget.middleName!} "}${widget.lastName ?? ""}",
              style: CommonWidgets.listLabelTextStyle(),
              overflow: CommonWidgets.textOverFlowEllipsis(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(
                color: Colors.black45,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: widget._roleList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.pop(context, widget._roleList[index]);
                    selectRole = index;
                    setState(() {});
                  },
                  child: Card(
                    elevation: 4,
                    borderOnForeground: false,
                    color: selectRole == index
                        ? const Color(ColorCode.primaryColor)
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(setRoleWiseImage(
                                    widget._roleList[index]["role"])),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                widget._roleList[index]["role"],
                                style: CommonWidgets.listLabelTextStyle(),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(
                color: Colors.black45,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(LoginConstants.cancelLabel,
                        style:
                            TextStyle(color: Color(ColorCode.primaryColor)))),
                CommonWidgets.horizontalSpace(20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, widget._roleList[selectRole]);
                    },
                    child: const Text(LoginConstants.submitLabel)),
              ],
            )
          ],
        ));
  }

  String setRoleWiseImage(String roleType) {
    return !CommonFunction.isNullOrIsEmpty(roleType)
        ? roleType.toLowerCase() == "employee"
            ? ImagePath.employeeAvtar
            : roleType.toLowerCase() == "admin"
                ? ImagePath.adminAvtar
                : roleType.toLowerCase() == "manager"
                    ? ImagePath.managerAvtar
                    : ImagePath.otherAvtar
        : ImagePath.otherAvtar;
  }
}

// Navigator.pop(context, _rolllist[index]);

// _rolllist[index]["role"]
