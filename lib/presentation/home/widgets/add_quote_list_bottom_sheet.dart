import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:flutter/material.dart';

import 'package:NeQuo/dependency_injection.dart';
import 'package:NeQuo/domain/usecases/add_quote_list.dart';

class AddQuoteListBottomSheet extends StatefulWidget {
  final Function getQuotesList;
  final BuildContext scaffoldContext;

  const AddQuoteListBottomSheet(
      {Key key, this.getQuotesList, this.scaffoldContext})
      : super(key: key);

  @override
  _AddQuoteListBottomSheetState createState() =>
      _AddQuoteListBottomSheetState();
}

class _AddQuoteListBottomSheetState extends State<AddQuoteListBottomSheet> {
  final _formkey = GlobalKey<FormState>();

  AddQuoteList _addQuoteList;
  String quoteListName = "";

  @override
  void initState() {
    super.initState();
    _addQuoteList = getIt<AddQuoteList>();
  }

  @override
  Widget build(BuildContext context) {
    final insetBottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
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
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quote list name',
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Please fill this field';
                }

                return null;
              },
              onSaved: (val) {
                quoteListName = val;
              },
            ),
            Expanded(
              child: SizedBox(height: 10),
            ),
            TextButton(
              child: Text("Create"),
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
                if (_formkey.currentState.validate()) {
                  _formkey.currentState.save();

                  final res = await _addQuoteList(
                    QuoteList(name: quoteListName),
                  );

                  if (res.isLeft()) {
                    Scaffold.of(widget.scaffoldContext).showSnackBar(
                      SnackBar(
                        content:
                            Text("A error occurred while adding quote list"),
                      ),
                    );
                  } else {
                    widget.getQuotesList();

                    Navigator.pop(context);
                  }
                }
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: Text("Cancel"),
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
