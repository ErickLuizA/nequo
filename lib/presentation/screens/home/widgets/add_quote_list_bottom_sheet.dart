import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:nequo/domain/usecases/add_category.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  final Function getCategories;
  final BuildContext scaffoldContext;
  final AddCategory addCategory;

  AddCategoryBottomSheet({
    Key? key,
    required this.getCategories,
    required this.scaffoldContext,
    required this.addCategory,
  }) : super(key: key);

  @override
  _AddCategoryBottomSheetState createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  late GlobalKey<FormState> _formkey;

  String quoteListName = "";

  @override
  void initState() {
    _formkey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final insetBottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      key: Key("add_quote_list_bottom_sheet_container"),
      height: insetBottom == 0
          ? MediaQuery.of(context).size.height / 2
          : MediaQuery.of(context).size.height / 1.1,
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: insetBottom == 0 ? 20 : insetBottom,
      ),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              key: Key("text_input"),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText:
                    AppLocalizations.of(context).translate('quote_list_name'),
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
              validator: (val) {
                if (val != null && val.isEmpty) {
                  return AppLocalizations.of(context).translate('fill_field');
                }

                return null;
              },
              onSaved: (val) {
                quoteListName = val ?? '';
              },
            ),
            Expanded(
              child: SizedBox(height: 10),
            ),
            TextButton(
              key: Key("create_button"),
              child: Text(AppLocalizations.of(context).translate('create')),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  Size(
                    MediaQuery.of(context).size.width,
                    50,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  Colors.green,
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () async {
                if (_formkey.currentState != null &&
                    _formkey.currentState!.validate()) {
                  _formkey.currentState?.save();

                  final res = await widget.addCategory(
                    AddCategoryParams(name: quoteListName),
                  );

                  if (res.isLeft()) {
                    Scaffold.of(widget.scaffoldContext).showSnackBar(
                      SnackBar(
                        key: Key("add_quote_list_snackbar"),
                        content: Text(AppLocalizations.of(context)
                            .translate('add_quote_list_error')),
                      ),
                    );
                  } else {
                    widget.getCategories();

                    Navigator.pop(context);
                  }
                }
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: Text(AppLocalizations.of(context).translate('cancel')),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  Size(
                    MediaQuery.of(context).size.width,
                    50,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  Colors.red,
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}