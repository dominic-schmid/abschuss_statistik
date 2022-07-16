class KillEntry {
  final int nummer;
  final String wildart;
  final String geschlecht;
  final String hegeinGebietRevierteil;
  final String datum;
  final String zeit;
  final String alter;
  final String alterw;
  final double gewicht;
  final String erleger;
  final String begleiter;
  final String ursache;
  final String verwendung;
  final String urpsrungszeichen;
  final String oertlichkeit;
  final Map<String, String>? jagdaufseher;

  KillEntry(
    this.nummer,
    this.wildart,
    this.geschlecht,
    this.datum,
    this.zeit,
    this.ursache,
    this.verwendung,
    this.oertlichkeit, {
    this.hegeinGebietRevierteil = "",
    this.alter = "",
    this.alterw = "",
    this.gewicht = 0.0,
    this.erleger = "",
    this.begleiter = "",
    this.urpsrungszeichen = "",
    this.jagdaufseher,
  });

  static KillEntry fromEntry(String htmlRow) {
    return KillEntry(
      0,
      "ich",
      "du",
      "heute",
      "zmorgate",
      "boh",
      "mein",
      "dohoam",
    );
  }

  //  "fortlnummer": int(cols[0].text),
  //         "wildart": cols[1].text,
  //         "geschlecht": cols[2].text,
  //         "hegein/gebiet/revierteil": uncoalesce(cols[3].text),
  //         "datum": cols[4].text[:10],
  //         "zeit": cols[4].text[10:],
  //         "alter":  uncoalesce(cols[5].text.strip()),
  //         "alter w":  uncoalesce(cols[6].text.strip()),
  //         "gewicht": float(str(cols[7].text).replace(',', '.')) if cols[7].text != "" else None,
  //         #"gewicht":  uncoalesce(cols[7].text),
  //         "erleger":  uncoalesce(cols[8].text), # Immer ***********
  //         "begleiter": uncoalesce(cols[9].text),
  //         "ursache": uncoalesce(cols[10].text),
  //         "verwendung": uncoalesce(cols[11].text),
  //         "ursprungszeichen": uncoalesce(cols[12].text),
  //         "oertlichkeit": str(cols[13].text).removesuffix('Auf Karte anzeigen'),
  //         "jagdaufseher":  {} if len(cols[14].text) < 20 else {
  //             "datum": cols[14].text[:10] ,
  //             "zeit": cols[14].text[11:19],
  //             "aufseher": cols[14].text[19:]
  //         }
}
