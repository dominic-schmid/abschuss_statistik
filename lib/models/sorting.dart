import 'package:jagdverband_scraper/models/kill_entry.dart';

enum SortType {
  kein,
  datum,
  nummer,
  wildart,
  geschlecht,
  gewicht,
  ursache,
  verwendung,
  oertlichkeit,
}

class Sorting {
  final String label;
  final SortType sortType;
  bool ascending;

  String get getLabel => sortType == SortType.kein
      ? label
      : ascending
          ? '$label (aufsteigend)'
          : '$label (absteigend)';

  Sorting({
    required this.label,
    required this.sortType,
    this.ascending = true,
  });

  static List<Sorting> generateDefault() {
    return <Sorting>[
      Sorting(label: 'Keine Sortierung', sortType: SortType.kein),
      Sorting(
        label: 'Datum',
        sortType: SortType.datum,
        ascending: false,
      ),
      Sorting(
        label: 'Nummer',
        sortType: SortType.nummer,
        ascending: true,
      ),
      Sorting(
        label: 'Wildart',
        sortType: SortType.wildart,
        ascending: true,
      ),
      Sorting(
        label: 'Geschlecht',
        sortType: SortType.geschlecht,
        ascending: true,
      ),
      Sorting(
        label: 'Gewicht',
        sortType: SortType.gewicht,
        ascending: false,
      ),
      Sorting(
        label: 'Ursache',
        sortType: SortType.ursache,
        ascending: true,
      ),
      Sorting(
        label: 'Verwendung',
        sortType: SortType.verwendung,
        ascending: true,
      ),
      Sorting(
        label: 'Örtlichkeit',
        sortType: SortType.oertlichkeit,
        ascending: true,
      ),
    ];
  }

  void toggleDirection() {
    ascending = !ascending;
  }

  List<KillEntry> sort(List<KillEntry> kills) {
    switch (sortType) {
      case SortType.kein:
        return kills;
      case SortType.datum:
        if (ascending) {
          kills.sort((a, b) => a.datetime.compareTo(b.datetime));
        } else {
          kills.sort((a, b) => b.datetime.compareTo(a.datetime));
        }
        break;
      case SortType.nummer:
        if (ascending) {
          kills.sort((a, b) => a.nummer.compareTo(b.nummer));
        } else {
          kills.sort((a, b) => b.nummer.compareTo(a.nummer));
        }
        break;
      case SortType.wildart:
        if (ascending) {
          kills.sort((a, b) => a.wildart.compareTo(b.wildart));
        } else {
          kills.sort((a, b) => b.wildart.compareTo(a.wildart));
        }
        break;
      case SortType.geschlecht:
        if (ascending) {
          kills.sort((a, b) => a.geschlecht.compareTo(b.geschlecht));
        } else {
          kills.sort((a, b) => b.geschlecht.compareTo(a.geschlecht));
        }
        break;
      case SortType.gewicht:
        if (ascending) {
          kills.sort((a, b) {
            if (a.gewicht != null && b.gewicht != null) {
              return a.gewicht!.compareTo(b.gewicht!);
            } else if (a.gewicht != null) {
              return 1;
            } else if (b.gewicht != null) {
              return -1;
            } else {
              return 0;
            }
          });
        } else {
          kills.sort((a, b) {
            if (a.gewicht != null && b.gewicht != null) {
              return b.gewicht!.compareTo(a.gewicht!);
            } else if (a.gewicht != null) {
              return -1;
            } else if (b.gewicht != null) {
              return 1;
            } else {
              return 0;
            }
          });
        }
        break;
      case SortType.ursache:
        if (ascending) {
          kills.sort((a, b) => a.ursache.compareTo(b.ursache));
        } else {
          kills.sort((a, b) => b.ursache.compareTo(a.ursache));
        }
        break;
      case SortType.verwendung:
        if (ascending) {
          kills.sort((a, b) => a.verwendung.compareTo(b.verwendung));
        } else {
          kills.sort((a, b) => b.verwendung.compareTo(a.verwendung));
        }
        break;
      case SortType.oertlichkeit:
        if (ascending) {
          kills.sort((a, b) => a.oertlichkeit.compareTo(b.oertlichkeit));
        } else {
          kills.sort((a, b) => b.oertlichkeit.compareTo(a.oertlichkeit));
        }
        break;
    }

    return kills;
  }
}
