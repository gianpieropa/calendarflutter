import 'package:calendar/blocs/evento/evento_event.dart';
import 'package:calendar/models/evento_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar/blocs/blocs.dart';
import 'package:intl/intl.dart';

class AddForm extends StatefulWidget {
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  AddFormBloc _myFormBloc;
  Evento newEvento = new Evento();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _dataFineController = TextEditingController();
  final TextEditingController _descrizioneController = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.year <= 3000
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime(3000));

    if (result == null) return;

    setState(() {
      _dataController.text = new DateFormat.yMd().format(result);
    });
  }

  Future _chooseDateFine(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.year <= 3000
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime(3000));

    if (result == null) return;

    setState(() {
      _dataFineController.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _myFormBloc = BlocProvider.of<AddFormBloc>(context);
    _dataFineController.addListener(_onDataFineChanged);
    _dataController.addListener(_onDataChanged);
    _descrizioneController.addListener(_onDescrizioneChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFormBloc, AddFormState>(
      builder: (context, state) {
        if (state.formSubmittedSuccessfully) {
          final FormState form = _formKey.currentState;
          form.save();

          BlocProvider.of<EventoListBloc>(context)
              .add(AddEvento(evento: newEvento));

          return SuccessDialog(onDismissed: () {
            _dataController.clear();
            _descrizioneController.clear();
            _myFormBloc.add(FormReset());
          });
        }
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Inserisci evento",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Data inizio",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 15)),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 160,
                          height: 40,
                          child: TextFormField(
                              onTap: () {
                                _chooseDateFine(
                                    context, _dataFineController.text);
                              },
                              controller: _dataFineController,
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: "",
                                filled: true,
                                fillColor: Colors.lightBlue[50],
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(
                                      color: Colors.lightBlue[50]),
                                ),
                                focusedBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(
                                      color: Colors.lightBlue[50]),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(
                                      color: Colors.lightBlue[50]),
                                ),
                              ),
                              keyboardType: TextInputType.datetime,
                              autovalidate: true,
                              onSaved: (val) => newEvento.dataFine =
                                  DateFormat.yMd().parse(val)),
                        ),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Data fine",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 15)),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 160,
                          height: 40,
                          child: TextFormField(
                            onTap: () {
                              _chooseDate(context, _dataController.text);
                            },
                            controller: _dataController,
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              filled: true,
                              fillColor: Colors.lightBlue[50],
                              enabledBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                borderSide:
                                    new BorderSide(color: Colors.lightBlue[50]),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                borderSide:
                                    new BorderSide(color: Colors.lightBlue[50]),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                borderSide:
                                    new BorderSide(color: Colors.lightBlue[50]),
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                            autovalidate: true,
                            onSaved: (val) => newEvento.dataInizio =
                                DateFormat.yMd().parse(val),
                          ),
                        ),
                      ])
                ],
              ),
              SizedBox(height: 10),
              Text("Descrizione",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey[400], fontSize: 15)),
              Container(
                height: 50,
                child: TextFormField(
                  controller: _descrizioneController,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    filled: true,
                    fillColor: Colors.lightBlue[50],
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(color: Colors.lightBlue[50]),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(color: Colors.lightBlue[50]),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(color: Colors.lightBlue[50]),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  autovalidate: true,
                  onSaved: (val) => newEvento.descrizione = val,
                ),
              ),
               SizedBox(height: 20,),
              GestureDetector(
                onTap: state.isFormValid ? _onSubmitPressed : null,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(10),bottomLeft:Radius.circular(10))),
                            child: Text("Aggiungi",style: TextStyle(color:Colors.white),),
                      ),
                    ),
                   
                    Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.only(topRight:Radius.circular(10),bottomRight:Radius.circular(10))),
                    
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _dataController.dispose();
    _dataFineController.dispose();
    _descrizioneController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    _myFormBloc.add(DataChanged(data: _dataController.text));
  }

  void _onDataFineChanged() {
    _myFormBloc.add(DataFineChanged(data: _dataController.text));
  }

  void _onDescrizioneChanged() {
    _myFormBloc
        .add(DescrizioneChanged(descrizione: _descrizioneController.text));
  }

  void _onSubmitPressed() {
    _myFormBloc.add(FormSubmitted());
  }
}

class SuccessDialog extends StatelessWidget {
  final VoidCallback onDismissed;

  SuccessDialog({Key key, @required this.onDismissed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(Icons.info),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Form Submitted Successfully!',
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
          RaisedButton(
            child: Text('OK'),
            onPressed: onDismissed,
          ),
        ],
      ),
    );
  }
}
