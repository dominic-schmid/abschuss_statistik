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
      "Dai un\'occhiata a quell\'cacciagione in ${x}!\n${y}";

  static String m1(x, y) => "Mostrando ${x} di ${y}";

  static String m2(x) => "Cerca tra ${x} dati della cacciagione";

  static String m3(x, y, z) => "Visto da ${x} il ${y} alle ${z}";

  static String m4(link) =>
      "Guarda l\'app delle statistiche di caccia!\n\n${link}";

  static String m5(x) => "Tempi caccia ${x} ";

  static String m6(howMany) =>
      "${Intl.plural(howMany, one: '1 cacciagione', other: '${howMany} Cacciagioni')}";

  static String m7(x) => "${x} nuove dati della cacciagione trovate!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M": MessageLookupByLibrary.simpleMessage("Maschile"),
        "W": MessageLookupByLibrary.simpleMessage("Femmina"),
        "addKill": MessageLookupByLibrary.simpleMessage("Aggiungi cacciagione"),
        "age": MessageLookupByLibrary.simpleMessage("Età"),
        "altgeiss": MessageLookupByLibrary.simpleMessage("Femmina adulta"),
        "alttier": MessageLookupByLibrary.simpleMessage("Femmina adulta"),
        "andereWildart":
            MessageLookupByLibrary.simpleMessage("Altre specie selvatiche"),
        "appSettings": MessageLookupByLibrary.simpleMessage("App"),
        "appTitle":
            MessageLookupByLibrary.simpleMessage("Statistiche sulla caccia"),
        "area": MessageLookupByLibrary.simpleMessage("Zona"),
        "bache": MessageLookupByLibrary.simpleMessage("Femmina"),
        "betaModeDescription": MessageLookupByLibrary.simpleMessage(
            "Alcune funzioni potrebbero non funzionare correttamente."),
        "betaModeTitle": MessageLookupByLibrary.simpleMessage("Modo beta"),
        "biometrics": MessageLookupByLibrary.simpleMessage("Biometrica"),
        "bockjahrling":
            MessageLookupByLibrary.simpleMessage("Maschio di un anno"),
        "bockkitz": MessageLookupByLibrary.simpleMessage("Piccolo maschio"),
        "border": MessageLookupByLibrary.simpleMessage("Confine"),
        "both": MessageLookupByLibrary.simpleMessage("Tutti e due"),
        "brutzeit": MessageLookupByLibrary.simpleMessage(
            "stagione degli accoppiamenti"),
        "causes": MessageLookupByLibrary.simpleMessage("Causi"),
        "chartBasedOnDownloaded": MessageLookupByLibrary.simpleMessage(
            "I grafici si basano sui dati scaricati. Se manca un anno, puoi selezionarlo e scaricarlo nella pagina iniziale.\n\nQuesti diagrammi forniscono informazioni sullo sviluppo storico del gioco nella tua zona e sono stati progettati in modo tale da poter configurare tu stesso la struttura!"),
        "checkOutThisKillXY": m0,
        "close": MessageLookupByLibrary.simpleMessage("Chiudere"),
        "companion": MessageLookupByLibrary.simpleMessage("Compagno"),
        "configuration": MessageLookupByLibrary.simpleMessage("Configurazione"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmare"),
        "confirmAddKillCancel": MessageLookupByLibrary.simpleMessage(
            "Sei sicuro di voler annullare l\'elaborazione della nuova cacciagione?"),
        "confirmDeleteDatabase": MessageLookupByLibrary.simpleMessage(
            "Sei sicuro di voler resettare il database?"),
        "copiedToClipboardSnackbar":
            MessageLookupByLibrary.simpleMessage("Copiato negli appunti!"),
        "credentialsScreen":
            MessageLookupByLibrary.simpleMessage("Credenziali"),
        "credsDisclaimerText": MessageLookupByLibrary.simpleMessage(
            "I tuoi dati di accesso vengono memorizzati solo localmente e utilizzati per scaricare le dati della cacciagione dal sito dell\'associazione dei cacciatori.\nNon saranno mai ceduti a terzi!"),
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
        "dateEmptyError": MessageLookupByLibrary.simpleMessage(
            "La data non può essere vuota"),
        "dateInFutureError":
            MessageLookupByLibrary.simpleMessage("Tempo invalido"),
        "defaultLocationDescription": MessageLookupByLibrary.simpleMessage(
            "Visualizzazione predefinita quando si aggiunge un\'cacciagione o si calcolano i tempi di tiro."),
        "defaultLocationTitle":
            MessageLookupByLibrary.simpleMessage("Imposta punto di partenza"),
        "deleteDatabaseDescription": MessageLookupByLibrary.simpleMessage(
            "Elimina le dati della cacciagione e scaricale nuovamente. Eseguire questa operazione per correggere eventuali errori."),
        "deleteDatabaseTitle":
            MessageLookupByLibrary.simpleMessage("Reimposta database"),
        "details": MessageLookupByLibrary.simpleMessage("Detagli"),
        "dialogLogoutBody": MessageLookupByLibrary.simpleMessage(
            "Vuoi davvero fare il log-out?\nI tuoi dati di accesso e tutte le tue impostazioni verranno cancellate!"),
        "dialogNo": MessageLookupByLibrary.simpleMessage("No"),
        "dialogYes": MessageLookupByLibrary.simpleMessage("Si"),
        "display": MessageLookupByLibrary.simpleMessage("Mostrare"),
        "distribution": MessageLookupByLibrary.simpleMessage("Distribuzione"),
        "editKill":
            MessageLookupByLibrary.simpleMessage("Modifica cacciagione"),
        "eigengebrauch": MessageLookupByLibrary.simpleMessage("Uso personale"),
        "eigengebrauchAbgabe": MessageLookupByLibrary.simpleMessage(
            "Uso personale - consegna per ulteriore elaborazione"),
        "empfohlen": MessageLookupByLibrary.simpleMessage("Consigliato"),
        "erlegt": MessageLookupByLibrary.simpleMessage("Abbattuto"),
        "error": MessageLookupByLibrary.simpleMessage("Errore"),
        "fallwild": MessageLookupByLibrary.simpleMessage("Trovato morto"),
        "feedbackMailSubject": MessageLookupByLibrary.simpleMessage(
            "Feedback sulla app delle statistiche di caccia"),
        "filter": MessageLookupByLibrary.simpleMessage("Filtro"),
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
        "jagdbegleiter":
            MessageLookupByLibrary.simpleMessage("Compagno di caccia"),
        "jagdzeiten": MessageLookupByLibrary.simpleMessage("Tempi caccia"),
        "jahrlingsHirsch":
            MessageLookupByLibrary.simpleMessage("Maschio di un anno"),
        "jahrlingsbock":
            MessageLookupByLibrary.simpleMessage("Maschio di un anno"),
        "jetztFestlegen": MessageLookupByLibrary.simpleMessage("Imposta ora"),
        "kahlwild": MessageLookupByLibrary.simpleMessage("Cervo"),
        "keiler": MessageLookupByLibrary.simpleMessage("Maschio"),
        "killer": MessageLookupByLibrary.simpleMessage("Cacciatore"),
        "kills": MessageLookupByLibrary.simpleMessage("Cacciagioni"),
        "ksExport": MessageLookupByLibrary.simpleMessage("Esport"),
        "ksExportDialogTitle":
            MessageLookupByLibrary.simpleMessage("Esporta come"),
        "ksExportErrorSnackbar": MessageLookupByLibrary.simpleMessage(
            "Errore: nessuni dati della cacciagione da esportare."),
        "ksExportSubtitle": MessageLookupByLibrary.simpleMessage(
            "Verranno esportate solo le dati della cacciagione visualizzate."),
        "ksShowXFromYProgressBar": m1,
        "ksTerritoryTitle": MessageLookupByLibrary.simpleMessage("Territorio"),
        "legend": MessageLookupByLibrary.simpleMessage("Leggenda"),
        "loginDataInvalid": MessageLookupByLibrary.simpleMessage(
            "I tuoi dati di accesso non sono più validi!"),
        "loslegen": MessageLookupByLibrary.simpleMessage("Iniziare"),
        "maennlich": MessageLookupByLibrary.simpleMessage("Maschile"),
        "map": MessageLookupByLibrary.simpleMessage("Carta geografica"),
        "mapInitialPosition":
            MessageLookupByLibrary.simpleMessage("Posizione iniziale"),
        "mitKeimruhe": MessageLookupByLibrary.simpleMessage("con dormienza"),
        "monate": MessageLookupByLibrary.simpleMessage("mesi"),
        "monthlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Ripartizione mensile"),
        "murmeltier": MessageLookupByLibrary.simpleMessage("Marmotta"),
        "needLogin": MessageLookupByLibrary.simpleMessage(
            "Poiché hai abilitato l\'autenticazione biometrica, devi essere loggato per vedere le dati della cacciagione!"),
        "newKills": MessageLookupByLibrary.simpleMessage(
            "Nuovi dati della cacciagione"),
        "nichtBekannt": MessageLookupByLibrary.simpleMessage("Non conosciuto"),
        "nichtGefunden": MessageLookupByLibrary.simpleMessage(
            "Non trovato/ricerca non riuscita"),
        "nichtVerwertbar":
            MessageLookupByLibrary.simpleMessage("Non utilizzabile"),
        "noBiometricsFound": MessageLookupByLibrary.simpleMessage(
            "Errore: nessun dato biometrico trovato!"),
        "noDataFoundText": MessageLookupByLibrary.simpleMessage(
            "Non c\'è niente da vedere qui..."),
        "noInternetError":
            MessageLookupByLibrary.simpleMessage("Errore: niente internet"),
        "noKillsFoundError": MessageLookupByLibrary.simpleMessage(
            "Errore: nessuna cacciagione trovata!"),
        "noKillsLoadedError": MessageLookupByLibrary.simpleMessage(
            "Errore: caricamento delle dati della cacciagione non riuscito!"),
        "number": MessageLookupByLibrary.simpleMessage("Numero"),
        "onboardStatDesc": MessageLookupByLibrary.simpleMessage(
            "Qual è l\'impatto delle malattie della fauna selvatica sul tuo territorio di caccia?\nSono stati abbattuti più caprioli negli ultimi anni rispetto a quest\'anno?\nE molto altro..."),
        "onboardTerritoryDesc": MessageLookupByLibrary.simpleMessage(
            "Tutte le dati della cacciagione visualizzate e mappate in modo moderno!\nInserisci le dati della cacciagione direttamente nell\'app"),
        "onboardUtilDesc": MessageLookupByLibrary.simpleMessage(
            "Controlla i tempi di caccia delle diverse specie di selvaggina e l\'ora di ripresa della giornata"),
        "onlyShot": MessageLookupByLibrary.simpleMessage("Solo sparati"),
        "open": MessageLookupByLibrary.simpleMessage("Aperto"),
        "ortFestlegen": MessageLookupByLibrary.simpleMessage(
            "È necessario prima impostare una posizione per l\'ora solare."),
        "overseer": MessageLookupByLibrary.simpleMessage("Sorvegliante"),
        "paarungszeiten":
            MessageLookupByLibrary.simpleMessage("Tempi di accoppiamento"),
        "perMonth": MessageLookupByLibrary.simpleMessage("al mese"),
        "pflichtfeld": MessageLookupByLibrary.simpleMessage("Obbligatorio"),
        "points": MessageLookupByLibrary.simpleMessage("Punti"),
        "protokollBeschlagnahmt":
            MessageLookupByLibrary.simpleMessage("Protocollo / confiscato"),
        "refreshListConfirmation": MessageLookupByLibrary.simpleMessage(
            "L\'elenco è stato aggiornato."),
        "rehwild": MessageLookupByLibrary.simpleMessage("Capriolo"),
        "rotwild": MessageLookupByLibrary.simpleMessage("Cervo"),
        "schmalreh": MessageLookupByLibrary.simpleMessage("Femmina sottile"),
        "schmaltier": MessageLookupByLibrary.simpleMessage("Femmina sottile"),
        "schneehase":
            MessageLookupByLibrary.simpleMessage("coniglietto di neve"),
        "schneehuhn": MessageLookupByLibrary.simpleMessage("Gallo cedrone"),
        "schusszeiten": MessageLookupByLibrary.simpleMessage("Tempi di caccia"),
        "schwarzwild": MessageLookupByLibrary.simpleMessage("Cinghiale"),
        "search": MessageLookupByLibrary.simpleMessage("Cercare"),
        "searchXKills": m2,
        "seenByXonYatZ": m3,
        "selectCoordinates": MessageLookupByLibrary.simpleMessage(
            "Scegli le coordinate sulla mappa"),
        "selectYear": MessageLookupByLibrary.simpleMessage("Seleziona anno"),
        "settingsAbout": MessageLookupByLibrary.simpleMessage("Informazioni"),
        "settingsAccount": MessageLookupByLibrary.simpleMessage("Account"),
        "settingsDarkMode": MessageLookupByLibrary.simpleMessage("Tema scuro"),
        "settingsDefaultYear": MessageLookupByLibrary.simpleMessage(
            "Mostra cacciagioni a partire dal"),
        "settingsDevelopment": MessageLookupByLibrary.simpleMessage("Sviluppo"),
        "settingsDisplay": MessageLookupByLibrary.simpleMessage("Schermo"),
        "settingsDonate": MessageLookupByLibrary.simpleMessage("Dare feedback"),
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
        "share": MessageLookupByLibrary.simpleMessage("Condividere l\'app"),
        "shareAppText": m4,
        "shouldUseLocalAuth": MessageLookupByLibrary.simpleMessage(
            "Se attivi l\'autenticazione biometrica, all\'avvio dell\'app ti verranno richiesti i dati di accesso memorizzati sul tuo dispositivo.\nVuoi abilitare la biometria? (consigliato)"),
        "signOfOrigin":
            MessageLookupByLibrary.simpleMessage("Certificato d\'origine"),
        "signOutResetAll": MessageLookupByLibrary.simpleMessage(
            "In caso di problemi di accesso, è possibile ripristinare tutte le impostazioni.\nAttenzione: Questo annullerà la tua registrazione e dovrai registrarti di nuovo!"),
        "sjvPublikation": MessageLookupByLibrary.simpleMessage(
            "Una pubblicazione dell\'Associazione Cacciatori Alto Adige"),
        "skip": MessageLookupByLibrary.simpleMessage("Saltare"),
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
        "tage": MessageLookupByLibrary.simpleMessage("giorni"),
        "time": MessageLookupByLibrary.simpleMessage("Tempo"),
        "timeEmptyError": MessageLookupByLibrary.simpleMessage(
            "Il tempo non può essere vuoto"),
        "timeInLocal": MessageLookupByLibrary.simpleMessage(
            "Gli orari si basano sull\'UTC e vengono convertiti nel formato del dispositivo.\nScorri verso destra o verso sinistra per cambiare il giorno."),
        "tragzeit":
            MessageLookupByLibrary.simpleMessage("periodo di gestazione"),
        "trophaehenHirsch":
            MessageLookupByLibrary.simpleMessage("Maschio di più anni"),
        "ueberlaeuferBache":
            MessageLookupByLibrary.simpleMessage("Femmina di un anno"),
        "ueberlaeuferKeiler":
            MessageLookupByLibrary.simpleMessage("Maschio di un anno"),
        "usage": MessageLookupByLibrary.simpleMessage("Destinazione"),
        "usages": MessageLookupByLibrary.simpleMessage("Destinazioni"),
        "useLocalAuth":
            MessageLookupByLibrary.simpleMessage("Autenticazione biometrica"),
        "verkauf": MessageLookupByLibrary.simpleMessage("Vendita"),
        "vomZug": MessageLookupByLibrary.simpleMessage("Abbatuto del treno"),
        "weiblich": MessageLookupByLibrary.simpleMessage("Femmina"),
        "weiblicheRehe":
            MessageLookupByLibrary.simpleMessage("Caprioli femminili"),
        "weight": MessageLookupByLibrary.simpleMessage("Peso"),
        "weightInKg": MessageLookupByLibrary.simpleMessage("Peso in kg"),
        "wild": MessageLookupByLibrary.simpleMessage("Specie"),
        "wildkalb": MessageLookupByLibrary.simpleMessage("Non noto"),
        "willBeLoggedInAuto": MessageLookupByLibrary.simpleMessage(
            "Verrai registrato automaticamente..."),
        "wochen": MessageLookupByLibrary.simpleMessage("settimane"),
        "xJagdzeiten": m5,
        "xKill_s": m6,
        "xNewKillsFound": m7,
        "yearly": MessageLookupByLibrary.simpleMessage("Annuale"),
        "yearlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Ripartizione annuale"),
        "yourTerritory":
            MessageLookupByLibrary.simpleMessage("Il tuo territorio"),
        "zahlNegativError":
            MessageLookupByLibrary.simpleMessage("Nessun numero negativo"),
        "zahlNichtGelesenError": MessageLookupByLibrary.simpleMessage(
            "Impossibile leggere il numero")
      };
}
