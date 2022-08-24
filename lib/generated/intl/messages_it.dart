// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'it';

  static String m0(x, y) =>
      "Dai un\'occhiata a quell\'uccisione in ${x}!\n${y}";

  static String m1(x, y) => "Mostrando ${x} di ${y}";

  static String m2(x) => "Cerca tra ${x} uccisioni";

  static String m3(x, y, z) => "Visto da ${x} il ${y} alle ${z}";

  static String m4(x) => "Tempi caccia ${x} ";

  static String m5(howMany) =>
      "${Intl.plural(howMany, one: '1 Uccisione', other: '${howMany} Uccisioni')}";

  static String m6(x) => "${x} nuove uccisioni trovate!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M": MessageLookupByLibrary.simpleMessage("Maschile"),
        "W": MessageLookupByLibrary.simpleMessage("Femmina"),
        "age": MessageLookupByLibrary.simpleMessage("Età"),
        "altgeiss": MessageLookupByLibrary.simpleMessage("Femmina adulta"),
        "alttier": MessageLookupByLibrary.simpleMessage("Femmina adulta"),
        "andereWildart":
            MessageLookupByLibrary.simpleMessage("Altre specie selvatiche"),
        "appTitle":
            MessageLookupByLibrary.simpleMessage("Statistiche sulla caccia"),
        "area": MessageLookupByLibrary.simpleMessage("Zona"),
        "bache": MessageLookupByLibrary.simpleMessage("Femmina"),
        "betaModeDescription": MessageLookupByLibrary.simpleMessage(
            "Alcune funzioni potrebbero non funzionare correttamente."),
        "betaModeTitle": MessageLookupByLibrary.simpleMessage("Modo beta"),
        "bockjahrling":
            MessageLookupByLibrary.simpleMessage("Maschio di un anno"),
        "bockkitz": MessageLookupByLibrary.simpleMessage("Piccolo maschio"),
        "causes": MessageLookupByLibrary.simpleMessage("Causi"),
        "chartBasedOnDownloaded": MessageLookupByLibrary.simpleMessage(
            "I grafici si basano sui dati scaricati. Se manca un anno, puoi selezionarlo e scaricarlo nella pagina iniziale.\n\nQuesti diagrammi forniscono informazioni sullo sviluppo storico del gioco nella tua zona e sono stati progettati in modo tale da poter configurare tu stesso la struttura!"),
        "checkOutThisKillXY": m0,
        "close": MessageLookupByLibrary.simpleMessage("Chiudere"),
        "companion": MessageLookupByLibrary.simpleMessage("Compagno"),
        "configuration": MessageLookupByLibrary.simpleMessage("Configurazione"),
        "copiedToClipboardSnackbar":
            MessageLookupByLibrary.simpleMessage("Copiato negli appunti!"),
        "credentialsScreen":
            MessageLookupByLibrary.simpleMessage("Credenziali"),
        "credsDisclaimerText": MessageLookupByLibrary.simpleMessage(
            "I tuoi dati di accesso vengono memorizzati solo localmente e utilizzati per scaricare le uccisioni dal sito dell\'associazione dei cacciatori.\nNon saranno mai ceduti a terzi!"),
        "credsEmptySnackbar": MessageLookupByLibrary.simpleMessage(
            "Devi inserire entrambi i campi!"),
        "credsLoginButton": MessageLookupByLibrary.simpleMessage("REGISTRARE"),
        "credsLoginErrorSnackbar": MessageLookupByLibrary.simpleMessage(
            "Errore: non esiste un territorio per queste date!"),
        "credsLoginTitle": MessageLookupByLibrary.simpleMessage("Registrare"),
        "credsPasswordFieldHint":
            MessageLookupByLibrary.simpleMessage("Password"),
        "credsPasswordFieldTitle":
            MessageLookupByLibrary.simpleMessage("Password"),
        "credsTerritoryFieldHint":
            MessageLookupByLibrary.simpleMessage("esempio Bruneck13L"),
        "credsTerritoryFieldTitle":
            MessageLookupByLibrary.simpleMessage("Territorio"),
        "credsTooManySigninsSnackbar": MessageLookupByLibrary.simpleMessage(
            "Registrato troppo spesso! Attendi 1 minuto prima di poter accedere nuovamente."),
        "dachs": MessageLookupByLibrary.simpleMessage("Tasso"),
        "dialogLogoutBody": MessageLookupByLibrary.simpleMessage(
            "Vuoi davvero fare il log-out?\nI tuoi dati di accesso e tutte le tue impostazioni verranno cancellate!"),
        "dialogNo": MessageLookupByLibrary.simpleMessage("No"),
        "dialogYes": MessageLookupByLibrary.simpleMessage("Si"),
        "display": MessageLookupByLibrary.simpleMessage("Mostrare"),
        "distribution": MessageLookupByLibrary.simpleMessage("Distribuzione"),
        "eigengebrauch": MessageLookupByLibrary.simpleMessage("Uso personale"),
        "eigengebrauchAbgabe": MessageLookupByLibrary.simpleMessage(
            "Uso personale - consegna per ulteriore elaborazione"),
        "erlegt": MessageLookupByLibrary.simpleMessage("Abbattuto"),
        "error": MessageLookupByLibrary.simpleMessage("Errore"),
        "fallwild": MessageLookupByLibrary.simpleMessage("Trovato morto"),
        "feedbackMailSubject": MessageLookupByLibrary.simpleMessage(
            "Feedback sulla app delle statistiche di caccia"),
        "freizone": MessageLookupByLibrary.simpleMessage("Zona libera"),
        "frischling": MessageLookupByLibrary.simpleMessage("Cinghialetto"),
        "fuchs": MessageLookupByLibrary.simpleMessage("Volpe"),
        "gameTypes": MessageLookupByLibrary.simpleMessage("Specie"),
        "gamsbock": MessageLookupByLibrary.simpleMessage("Maschio di camoscio"),
        "gamsgeiss": MessageLookupByLibrary.simpleMessage("Femmina camoscio"),
        "gamsjahrlinge":
            MessageLookupByLibrary.simpleMessage("puledri di camoscio"),
        "gamswild": MessageLookupByLibrary.simpleMessage("Camoscio"),
        "geissjahrling":
            MessageLookupByLibrary.simpleMessage("Femmina di un anno"),
        "geisskitz": MessageLookupByLibrary.simpleMessage("Piccolo femmina"),
        "geschlossen": MessageLookupByLibrary.simpleMessage("Chiuso"),
        "grid": MessageLookupByLibrary.simpleMessage("Griglia"),
        "hegeabschuss":
            MessageLookupByLibrary.simpleMessage("Abbattimento conservativo"),
        "hirschkalb": MessageLookupByLibrary.simpleMessage("Piccolo maschile"),
        "historic": MessageLookupByLibrary.simpleMessage("Storico"),
        "hunter": MessageLookupByLibrary.simpleMessage("Cacciatore"),
        "jahrlingsHirsch":
            MessageLookupByLibrary.simpleMessage("Maschio di un anno"),
        "jahrlingsbock":
            MessageLookupByLibrary.simpleMessage("Maschio di un anno"),
        "kahlwild": MessageLookupByLibrary.simpleMessage("Cervo"),
        "keiler": MessageLookupByLibrary.simpleMessage("Maschio"),
        "killer": MessageLookupByLibrary.simpleMessage("Cacciatore"),
        "kills": MessageLookupByLibrary.simpleMessage("Uccisioni"),
        "ksExport": MessageLookupByLibrary.simpleMessage("Esport"),
        "ksExportDialogTitle":
            MessageLookupByLibrary.simpleMessage("Esporta come"),
        "ksExportErrorSnackbar": MessageLookupByLibrary.simpleMessage(
            "Errore: nessuni uccisioni da esportare."),
        "ksExportSubtitle": MessageLookupByLibrary.simpleMessage(
            "Verranno esportate solo le uccisioni visualizzate."),
        "ksShowXFromYProgressBar": m1,
        "ksTerritoryTitle": MessageLookupByLibrary.simpleMessage("Territorio"),
        "loginDataInvalid": MessageLookupByLibrary.simpleMessage(
            "I tuoi dati di accesso non sono più validi!"),
        "maennlich": MessageLookupByLibrary.simpleMessage("Maschile"),
        "mapInitialPosition":
            MessageLookupByLibrary.simpleMessage("Posizione iniziale"),
        "monthlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Ripartizione mensile"),
        "murmeltier": MessageLookupByLibrary.simpleMessage("Marmotta"),
        "newKills": MessageLookupByLibrary.simpleMessage("Nuovi uccisioni"),
        "nichtBekannt": MessageLookupByLibrary.simpleMessage("Non conosciuto"),
        "nichtGefunden": MessageLookupByLibrary.simpleMessage(
            "Non trovato/ricerca non riuscita"),
        "nichtVerwertbar":
            MessageLookupByLibrary.simpleMessage("Non utilizzabile"),
        "noDataFoundText": MessageLookupByLibrary.simpleMessage(
            "Non c\'è niente da vedere qui..."),
        "noInternetError":
            MessageLookupByLibrary.simpleMessage("Errore: niente internet"),
        "noKillsFoundError": MessageLookupByLibrary.simpleMessage(
            "Errore: nessuna uccisione trovata!"),
        "noKillsLoadedError": MessageLookupByLibrary.simpleMessage(
            "Errore: caricamento delle uccisioni non riuscito!"),
        "number": MessageLookupByLibrary.simpleMessage("Numero"),
        "onlyShot": MessageLookupByLibrary.simpleMessage("Solo sparati"),
        "open": MessageLookupByLibrary.simpleMessage("Aperto"),
        "overseer": MessageLookupByLibrary.simpleMessage("Sorvegliante"),
        "perMonth": MessageLookupByLibrary.simpleMessage("al mese"),
        "points": MessageLookupByLibrary.simpleMessage("Punti"),
        "protokollBeschlagnahmt":
            MessageLookupByLibrary.simpleMessage("Protocollo / confiscato"),
        "rehwild": MessageLookupByLibrary.simpleMessage("Capriolo"),
        "rotwild": MessageLookupByLibrary.simpleMessage("Cervo"),
        "schmalreh": MessageLookupByLibrary.simpleMessage("Femmina sottile"),
        "schmaltier": MessageLookupByLibrary.simpleMessage("Femmina sottile"),
        "schneehase":
            MessageLookupByLibrary.simpleMessage("coniglietto di neve"),
        "schneehuhn": MessageLookupByLibrary.simpleMessage("Gallo cedrone"),
        "schwarzwild": MessageLookupByLibrary.simpleMessage("Cinghiale"),
        "searchXKills": m2,
        "seenByXonYatZ": m3,
        "selectYear": MessageLookupByLibrary.simpleMessage("Seleziona anno"),
        "settingsAbout": MessageLookupByLibrary.simpleMessage("Informazioni"),
        "settingsAccount": MessageLookupByLibrary.simpleMessage("Account"),
        "settingsDarkMode": MessageLookupByLibrary.simpleMessage("Tema scuro"),
        "settingsDevelopment": MessageLookupByLibrary.simpleMessage("Sviluppo"),
        "settingsDisplay": MessageLookupByLibrary.simpleMessage("Schermo"),
        "settingsDonate":
            MessageLookupByLibrary.simpleMessage("Donare la pancetta"),
        "settingsHuntersAssociationWebsite":
            MessageLookupByLibrary.simpleMessage(
                "Statistiche dell\'associazione di caccia"),
        "settingsKontakt": MessageLookupByLibrary.simpleMessage("Contatto"),
        "settingsLanguage": MessageLookupByLibrary.simpleMessage("Lingua"),
        "settingsLinks": MessageLookupByLibrary.simpleMessage("Link"),
        "settingsLogout": MessageLookupByLibrary.simpleMessage("Log out"),
        "settingsShowNamesBody": MessageLookupByLibrary.simpleMessage(
            "Potrebbe essere che solo le stelle possano essere visualizzate."),
        "settingsShowNamesTitle":
            MessageLookupByLibrary.simpleMessage("Mostrare nomi"),
        "settingsTitle": MessageLookupByLibrary.simpleMessage("Impostazioni"),
        "settingsWebsite": MessageLookupByLibrary.simpleMessage("Sito web"),
        "sexes": MessageLookupByLibrary.simpleMessage("Sessi"),
        "signOfOrigin":
            MessageLookupByLibrary.simpleMessage("Certificato d\'origine"),
        "sortCause": MessageLookupByLibrary.simpleMessage("Causa"),
        "sortDate": MessageLookupByLibrary.simpleMessage("Data"),
        "sortGameType":
            MessageLookupByLibrary.simpleMessage("Specie selvatiche"),
        "sortGender": MessageLookupByLibrary.simpleMessage("Sesso"),
        "sortNone": MessageLookupByLibrary.simpleMessage("Nessun smistamento"),
        "sortNumber": MessageLookupByLibrary.simpleMessage("Numero"),
        "sortPlace": MessageLookupByLibrary.simpleMessage("Luogo"),
        "sortTitle": MessageLookupByLibrary.simpleMessage("Ordinamento"),
        "sortUse": MessageLookupByLibrary.simpleMessage("Uso"),
        "sortWeight": MessageLookupByLibrary.simpleMessage("Peso"),
        "spielhahn": MessageLookupByLibrary.simpleMessage("Gallo forcello"),
        "statistics": MessageLookupByLibrary.simpleMessage("Statistiche"),
        "steinbock":
            MessageLookupByLibrary.simpleMessage("Capricorno maschile"),
        "steingeiss":
            MessageLookupByLibrary.simpleMessage("Capricorno femminile"),
        "steinhuhn": MessageLookupByLibrary.simpleMessage("Coturnice"),
        "steinwild": MessageLookupByLibrary.simpleMessage("Stambecco"),
        "strassenunfall":
            MessageLookupByLibrary.simpleMessage("Incidente stradale"),
        "sum": MessageLookupByLibrary.simpleMessage("Somma"),
        "tBock": MessageLookupByLibrary.simpleMessage("Maschio di più anni"),
        "time": MessageLookupByLibrary.simpleMessage("Tempo"),
        "trophaehenHirsch":
            MessageLookupByLibrary.simpleMessage("Maschio di più anni"),
        "ueberlaeuferBache":
            MessageLookupByLibrary.simpleMessage("Femmina di un anno"),
        "ueberlaeuferKeiler":
            MessageLookupByLibrary.simpleMessage("Maschio di un anno"),
        "usage": MessageLookupByLibrary.simpleMessage("Destinazione"),
        "usages": MessageLookupByLibrary.simpleMessage("Destinazioni"),
        "verkauf": MessageLookupByLibrary.simpleMessage("Vendita"),
        "vomZug": MessageLookupByLibrary.simpleMessage("Abbatuto del treno"),
        "weiblich": MessageLookupByLibrary.simpleMessage("Femmina"),
        "weiblicheRehe":
            MessageLookupByLibrary.simpleMessage("Caprioli femminili"),
        "weight": MessageLookupByLibrary.simpleMessage("Peso"),
        "wildkalb": MessageLookupByLibrary.simpleMessage("Non noto"),
        "xJagdzeiten": m4,
        "xKill_s": m5,
        "xNewKillsFound": m6,
        "yearly": MessageLookupByLibrary.simpleMessage("Annuale"),
        "yearlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Ripartizione annuale")
      };
}
