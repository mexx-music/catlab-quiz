// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'CatLab 🐱 Quiz';

  @override
  String get chooseQuizbook => 'Wähle einen Quizbogen:';

  @override
  String get quizOfTheDay => 'Quiz des Tages';

  @override
  String get dailyQuizSubtitle => '5 zufällige Fragen aus allen Kategorien';

  @override
  String bestScore(int score, int total) {
    return 'Bestpunktzahl: $score / $total';
  }

  @override
  String get questionOfTheDay => 'Frage des Tages';

  @override
  String get quizbooks => 'Quizbögen';

  @override
  String get postCopy => 'Post kopieren';

  @override
  String get resolutionCopy => 'Auflösung kopieren';

  @override
  String get questionOfDayCopied => 'Frage des Tages kopiert';

  @override
  String get resolutionCopied => 'Auflösung kopiert';

  @override
  String get showPostText => 'Post-Text anzeigen';

  @override
  String get postTextCopied => 'Post-Text kopiert';

  @override
  String get adminAccess => 'Admin-Zugang';

  @override
  String get codeLabel => 'Code';

  @override
  String get unlock => 'Freischalten';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get wrongCode => 'Falscher Code';

  @override
  String get lockAdmin => '🔒 Admin sperren';

  @override
  String get next => 'Weiter';

  @override
  String get showResult => 'Ergebnis anzeigen';

  @override
  String get result => 'Ergebnis';

  @override
  String points(int score, int total) {
    return '$score / $total Punkte';
  }

  @override
  String get levelExpert => 'Katzenexperte';

  @override
  String get levelExpertDesc =>
      'Du kennst dich erstaunlich gut mit Katzen aus.';

  @override
  String get levelKnower => 'Katzenkenner';

  @override
  String get levelKnowerDesc =>
      'Du weißt schon einiges über Katzen – beeindruckend!';

  @override
  String get levelFriend => 'Katzenfreund';

  @override
  String get levelFriendDesc => 'Du liebst Katzen und lernst immer mehr dazu.';

  @override
  String get levelBeginner => 'Katzen-Anfänger';

  @override
  String get levelBeginnerDesc =>
      'Noch Luft nach oben – aber du bist auf dem richtigen Weg!';

  @override
  String get newHighscore => '🎉 Neuer Highscore!';

  @override
  String get copyResult => 'Ergebnis kopieren';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get resultCopied => 'Ergebnis kopiert';

  @override
  String get catQuestionBadge => '🐱 Katzenfrage';

  @override
  String get whatDoYouThink => 'Was denkst du? 👇';

  @override
  String get testYourKnowledge => 'Teste dein Katzenwissen:';

  @override
  String get copy => 'Kopieren';

  @override
  String get close => 'Schließen';

  @override
  String get done => 'Fertig';

  @override
  String get download => 'Herunterladen';

  @override
  String get postCreatorTitle => 'Post Creator';

  @override
  String get copyText => 'Text kopieren';

  @override
  String get shareBtn => 'Teilen';

  @override
  String get sharingInProgress => 'Wird geteilt…';

  @override
  String get createPng => 'PNG erstellen';

  @override
  String get creatingPng => 'Wird erstellt…';

  @override
  String get pngCreationFailed => 'PNG-Erzeugung fehlgeschlagen';

  @override
  String get pngCreatedTitle => 'PNG wurde erzeugt';

  @override
  String get imageSharedTitle => 'Bild geteilt';

  @override
  String get quizTextCopiedHint =>
      'Der Quiztext wurde kopiert – bitte im Facebook-Textfeld einfügen.';

  @override
  String get recopyText => 'Text erneut kopieren';

  @override
  String get quizTextRecopied => 'Quiztext erneut kopiert';

  @override
  String get imageSharedTextCopied => 'Bild geteilt – Text wurde kopiert';

  @override
  String get quizbookLabel => 'Quizbogen';

  @override
  String get questionSelectorLabel => 'Frage';

  @override
  String get formatLabel => 'Format';

  @override
  String get chooseQuizHint => 'Quiz wählen...';

  @override
  String get firstChooseQuizbook => 'Erst Quizbogen wählen';

  @override
  String get chooseQuestionHint => 'Frage wählen...';

  @override
  String get questionPostLabel => '🐱 Frage-Post';

  @override
  String get resolutionComingSoon => '✅ Auflösung (bald)';

  @override
  String get pasteHint =>
      'Text kopieren und in Facebook, Instagram, Threads oder Pinterest einfügen.';

  @override
  String get prepareSharingTitle => 'Teilen vorbereiten';

  @override
  String get sizeLabel => 'Größe';

  @override
  String get fileLabel => 'Datei';

  @override
  String get exportTitle => 'Export';

  @override
  String get postsTotalLabel => 'Posts gesamt';

  @override
  String get openPostsLabel => 'Offen';

  @override
  String get donePostsLabel => 'Erledigt';

  @override
  String get copyJson => 'JSON kopieren';

  @override
  String get copyCsv => 'CSV kopieren';

  @override
  String get jsonCopied => 'JSON kopiert';

  @override
  String get csvCopied => 'CSV kopiert';

  @override
  String get schedulerHint =>
      'Kompatibel mit Publer · Buffer · Metricool und anderen\nScheduling-Tools.';

  @override
  String get todayPostTitle => 'Heute posten';

  @override
  String get plannedToday => 'Heute geplant:';

  @override
  String get questionPosted => 'Frage gepostet';

  @override
  String get resolutionPosted => 'Auflösung gepostet';

  @override
  String get questionPostCopied => 'Frage-Post kopiert';

  @override
  String get noOpenQuestions =>
      'Keine offenen Fragen – alle wurden bereits gepostet.';

  @override
  String get noResolutionsWaiting => 'Keine Fragen warten auf ihre Auflösung.';

  @override
  String get allPostsUsed => 'Alle aktuellen Posts wurden verwendet.';

  @override
  String get contentLibraryTitle => 'Content Library';

  @override
  String get allFilter => 'Alle';

  @override
  String get allQuizbooks => 'Alle Quizbögen';

  @override
  String get noPostsInSelection => 'Keine Posts in dieser Auswahl.';

  @override
  String get questionPostSection => 'Frage-Post';

  @override
  String get resolutionPostSection => 'Auflösungs-Post';

  @override
  String get copyResolution => 'Auflösung kopieren';

  @override
  String get markQuestion => 'Frage markieren';

  @override
  String get markResolution => 'Auflösung markieren';

  @override
  String get resetStatus => 'Zurücksetzen';
}
