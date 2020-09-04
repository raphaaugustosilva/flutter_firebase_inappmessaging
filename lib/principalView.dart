import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

class PrincipalView extends StatefulWidget {
  @override
  _PrincipalViewState createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  bool inAppInterrompido = false;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging();
  String nomeEventoPersonalizado = "raphael_evento";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(title: Text('POC In-App Messaging')),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              montaCard("Logar evento Analytics", "Loga o evento $nomeEventoPersonalizado no Analytics", "Log de Analytics evento $nomeEventoPersonalizado", () async {
                await analytics.logEvent(name: nomeEventoPersonalizado);
              }),
              montaCard("Trigger de evento programática", "Manualmente aciona eventos programaticamente", "Trigger do evento $nomeEventoPersonalizado", () async {
                await fiam.triggerEvent(nomeEventoPersonalizado);
              }),
              montaCard("${inAppInterrompido ? "Retoma" : "Interrompe"} In-App Messaging", "${inAppInterrompido ? "Retoma" : "Interrompe"} temporariamente o recebimendo de In-App Messaging", "${inAppInterrompido ? "Retomar" : "Interromper"}", () async {
                inAppInterrompido = !inAppInterrompido;
                await fiam.setMessagesSuppressed(inAppInterrompido);
                setState(() {});
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget montaCard(String titulo, String descricao, String textoBotao, Function acaoAoClicarBotao) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Text(titulo, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18)),
            SizedBox(height: 8),
            Text(descricao),
            SizedBox(height: 8),
            RaisedButton(
              onPressed: acaoAoClicarBotao,
              color: Colors.blue,
              child: Text(textoBotao.toUpperCase(), style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}
