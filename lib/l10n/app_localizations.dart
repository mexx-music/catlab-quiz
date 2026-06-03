import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// App title displayed in the header
  ///
  /// In de, this message translates to:
  /// **'CatLab 🐱 Quiz'**
  String get appTitle;

  /// No description provided for @chooseQuizbook.
  ///
  /// In de, this message translates to:
  /// **'Wähle einen Quizbogen:'**
  String get chooseQuizbook;

  /// No description provided for @quizOfTheDay.
  ///
  /// In de, this message translates to:
  /// **'Quiz des Tages'**
  String get quizOfTheDay;

  /// No description provided for @dailyQuizSubtitle.
  ///
  /// In de, this message translates to:
  /// **'5 zufällige Fragen aus allen Kategorien'**
  String get dailyQuizSubtitle;

  /// No description provided for @bestScore.
  ///
  /// In de, this message translates to:
  /// **'Bestpunktzahl: {score} / {total}'**
  String bestScore(int score, int total);

  /// No description provided for @questionOfTheDay.
  ///
  /// In de, this message translates to:
  /// **'Frage des Tages'**
  String get questionOfTheDay;

  /// No description provided for @quizbooks.
  ///
  /// In de, this message translates to:
  /// **'Quizbögen'**
  String get quizbooks;

  /// No description provided for @postCopy.
  ///
  /// In de, this message translates to:
  /// **'Post kopieren'**
  String get postCopy;

  /// No description provided for @resolutionCopy.
  ///
  /// In de, this message translates to:
  /// **'Auflösung kopieren'**
  String get resolutionCopy;

  /// No description provided for @questionOfDayCopied.
  ///
  /// In de, this message translates to:
  /// **'Frage des Tages kopiert'**
  String get questionOfDayCopied;

  /// No description provided for @resolutionCopied.
  ///
  /// In de, this message translates to:
  /// **'Auflösung kopiert'**
  String get resolutionCopied;

  /// No description provided for @showPostText.
  ///
  /// In de, this message translates to:
  /// **'Post-Text anzeigen'**
  String get showPostText;

  /// No description provided for @postTextCopied.
  ///
  /// In de, this message translates to:
  /// **'Post-Text kopiert'**
  String get postTextCopied;

  /// No description provided for @adminAccess.
  ///
  /// In de, this message translates to:
  /// **'Admin-Zugang'**
  String get adminAccess;

  /// No description provided for @codeLabel.
  ///
  /// In de, this message translates to:
  /// **'Code'**
  String get codeLabel;

  /// No description provided for @unlock.
  ///
  /// In de, this message translates to:
  /// **'Freischalten'**
  String get unlock;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @wrongCode.
  ///
  /// In de, this message translates to:
  /// **'Falscher Code'**
  String get wrongCode;

  /// No description provided for @lockAdmin.
  ///
  /// In de, this message translates to:
  /// **'🔒 Admin sperren'**
  String get lockAdmin;

  /// No description provided for @next.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get next;

  /// No description provided for @showResult.
  ///
  /// In de, this message translates to:
  /// **'Ergebnis anzeigen'**
  String get showResult;

  /// No description provided for @result.
  ///
  /// In de, this message translates to:
  /// **'Ergebnis'**
  String get result;

  /// No description provided for @points.
  ///
  /// In de, this message translates to:
  /// **'{score} / {total} Punkte'**
  String points(int score, int total);

  /// No description provided for @levelExpert.
  ///
  /// In de, this message translates to:
  /// **'Katzenexperte'**
  String get levelExpert;

  /// No description provided for @levelExpertDesc.
  ///
  /// In de, this message translates to:
  /// **'Du kennst dich erstaunlich gut mit Katzen aus.'**
  String get levelExpertDesc;

  /// No description provided for @levelKnower.
  ///
  /// In de, this message translates to:
  /// **'Katzenkenner'**
  String get levelKnower;

  /// No description provided for @levelKnowerDesc.
  ///
  /// In de, this message translates to:
  /// **'Du weißt schon einiges über Katzen – beeindruckend!'**
  String get levelKnowerDesc;

  /// No description provided for @levelFriend.
  ///
  /// In de, this message translates to:
  /// **'Katzenfreund'**
  String get levelFriend;

  /// No description provided for @levelFriendDesc.
  ///
  /// In de, this message translates to:
  /// **'Du liebst Katzen und lernst immer mehr dazu.'**
  String get levelFriendDesc;

  /// No description provided for @levelBeginner.
  ///
  /// In de, this message translates to:
  /// **'Katzen-Anfänger'**
  String get levelBeginner;

  /// No description provided for @levelBeginnerDesc.
  ///
  /// In de, this message translates to:
  /// **'Noch Luft nach oben – aber du bist auf dem richtigen Weg!'**
  String get levelBeginnerDesc;

  /// No description provided for @newHighscore.
  ///
  /// In de, this message translates to:
  /// **'🎉 Neuer Highscore!'**
  String get newHighscore;

  /// No description provided for @copyResult.
  ///
  /// In de, this message translates to:
  /// **'Ergebnis kopieren'**
  String get copyResult;

  /// No description provided for @playAgain.
  ///
  /// In de, this message translates to:
  /// **'Nochmal spielen'**
  String get playAgain;

  /// No description provided for @resultCopied.
  ///
  /// In de, this message translates to:
  /// **'Ergebnis kopiert'**
  String get resultCopied;

  /// No description provided for @catQuestionBadge.
  ///
  /// In de, this message translates to:
  /// **'🐱 Katzenfrage'**
  String get catQuestionBadge;

  /// No description provided for @whatDoYouThink.
  ///
  /// In de, this message translates to:
  /// **'Was denkst du? 👇'**
  String get whatDoYouThink;

  /// No description provided for @testYourKnowledge.
  ///
  /// In de, this message translates to:
  /// **'Teste dein Katzenwissen:'**
  String get testYourKnowledge;

  /// No description provided for @copy.
  ///
  /// In de, this message translates to:
  /// **'Kopieren'**
  String get copy;

  /// No description provided for @close.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get close;

  /// No description provided for @done.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get done;

  /// No description provided for @download.
  ///
  /// In de, this message translates to:
  /// **'Herunterladen'**
  String get download;

  /// No description provided for @postCreatorTitle.
  ///
  /// In de, this message translates to:
  /// **'Post Creator'**
  String get postCreatorTitle;

  /// No description provided for @copyText.
  ///
  /// In de, this message translates to:
  /// **'Text kopieren'**
  String get copyText;

  /// No description provided for @shareBtn.
  ///
  /// In de, this message translates to:
  /// **'Teilen'**
  String get shareBtn;

  /// No description provided for @sharingInProgress.
  ///
  /// In de, this message translates to:
  /// **'Wird geteilt…'**
  String get sharingInProgress;

  /// No description provided for @createPng.
  ///
  /// In de, this message translates to:
  /// **'PNG erstellen'**
  String get createPng;

  /// No description provided for @creatingPng.
  ///
  /// In de, this message translates to:
  /// **'Wird erstellt…'**
  String get creatingPng;

  /// No description provided for @pngCreationFailed.
  ///
  /// In de, this message translates to:
  /// **'PNG-Erzeugung fehlgeschlagen'**
  String get pngCreationFailed;

  /// No description provided for @pngCreatedTitle.
  ///
  /// In de, this message translates to:
  /// **'PNG wurde erzeugt'**
  String get pngCreatedTitle;

  /// No description provided for @imageSharedTitle.
  ///
  /// In de, this message translates to:
  /// **'Bild geteilt'**
  String get imageSharedTitle;

  /// No description provided for @quizTextCopiedHint.
  ///
  /// In de, this message translates to:
  /// **'Der Quiztext wurde kopiert – bitte im Facebook-Textfeld einfügen.'**
  String get quizTextCopiedHint;

  /// No description provided for @recopyText.
  ///
  /// In de, this message translates to:
  /// **'Text erneut kopieren'**
  String get recopyText;

  /// No description provided for @quizTextRecopied.
  ///
  /// In de, this message translates to:
  /// **'Quiztext erneut kopiert'**
  String get quizTextRecopied;

  /// No description provided for @imageSharedTextCopied.
  ///
  /// In de, this message translates to:
  /// **'Bild geteilt – Text wurde kopiert'**
  String get imageSharedTextCopied;

  /// No description provided for @quizbookLabel.
  ///
  /// In de, this message translates to:
  /// **'Quizbogen'**
  String get quizbookLabel;

  /// No description provided for @questionSelectorLabel.
  ///
  /// In de, this message translates to:
  /// **'Frage'**
  String get questionSelectorLabel;

  /// No description provided for @formatLabel.
  ///
  /// In de, this message translates to:
  /// **'Format'**
  String get formatLabel;

  /// No description provided for @chooseQuizHint.
  ///
  /// In de, this message translates to:
  /// **'Quiz wählen...'**
  String get chooseQuizHint;

  /// No description provided for @firstChooseQuizbook.
  ///
  /// In de, this message translates to:
  /// **'Erst Quizbogen wählen'**
  String get firstChooseQuizbook;

  /// No description provided for @chooseQuestionHint.
  ///
  /// In de, this message translates to:
  /// **'Frage wählen...'**
  String get chooseQuestionHint;

  /// No description provided for @questionPostLabel.
  ///
  /// In de, this message translates to:
  /// **'🐱 Frage-Post'**
  String get questionPostLabel;

  /// No description provided for @resolutionComingSoon.
  ///
  /// In de, this message translates to:
  /// **'✅ Auflösung (bald)'**
  String get resolutionComingSoon;

  /// No description provided for @pasteHint.
  ///
  /// In de, this message translates to:
  /// **'Text kopieren und in Facebook, Instagram, Threads oder Pinterest einfügen.'**
  String get pasteHint;

  /// No description provided for @prepareSharingTitle.
  ///
  /// In de, this message translates to:
  /// **'Teilen vorbereiten'**
  String get prepareSharingTitle;

  /// No description provided for @sizeLabel.
  ///
  /// In de, this message translates to:
  /// **'Größe'**
  String get sizeLabel;

  /// No description provided for @fileLabel.
  ///
  /// In de, this message translates to:
  /// **'Datei'**
  String get fileLabel;

  /// No description provided for @exportTitle.
  ///
  /// In de, this message translates to:
  /// **'Export'**
  String get exportTitle;

  /// No description provided for @postsTotalLabel.
  ///
  /// In de, this message translates to:
  /// **'Posts gesamt'**
  String get postsTotalLabel;

  /// No description provided for @openPostsLabel.
  ///
  /// In de, this message translates to:
  /// **'Offen'**
  String get openPostsLabel;

  /// No description provided for @donePostsLabel.
  ///
  /// In de, this message translates to:
  /// **'Erledigt'**
  String get donePostsLabel;

  /// No description provided for @copyJson.
  ///
  /// In de, this message translates to:
  /// **'JSON kopieren'**
  String get copyJson;

  /// No description provided for @copyCsv.
  ///
  /// In de, this message translates to:
  /// **'CSV kopieren'**
  String get copyCsv;

  /// No description provided for @jsonCopied.
  ///
  /// In de, this message translates to:
  /// **'JSON kopiert'**
  String get jsonCopied;

  /// No description provided for @csvCopied.
  ///
  /// In de, this message translates to:
  /// **'CSV kopiert'**
  String get csvCopied;

  /// No description provided for @schedulerHint.
  ///
  /// In de, this message translates to:
  /// **'Kompatibel mit Publer · Buffer · Metricool und anderen\nScheduling-Tools.'**
  String get schedulerHint;

  /// No description provided for @todayPostTitle.
  ///
  /// In de, this message translates to:
  /// **'Heute posten'**
  String get todayPostTitle;

  /// No description provided for @plannedToday.
  ///
  /// In de, this message translates to:
  /// **'Heute geplant:'**
  String get plannedToday;

  /// No description provided for @questionPosted.
  ///
  /// In de, this message translates to:
  /// **'Frage gepostet'**
  String get questionPosted;

  /// No description provided for @resolutionPosted.
  ///
  /// In de, this message translates to:
  /// **'Auflösung gepostet'**
  String get resolutionPosted;

  /// No description provided for @questionPostCopied.
  ///
  /// In de, this message translates to:
  /// **'Frage-Post kopiert'**
  String get questionPostCopied;

  /// No description provided for @noOpenQuestions.
  ///
  /// In de, this message translates to:
  /// **'Keine offenen Fragen – alle wurden bereits gepostet.'**
  String get noOpenQuestions;

  /// No description provided for @noResolutionsWaiting.
  ///
  /// In de, this message translates to:
  /// **'Keine Fragen warten auf ihre Auflösung.'**
  String get noResolutionsWaiting;

  /// No description provided for @allPostsUsed.
  ///
  /// In de, this message translates to:
  /// **'Alle aktuellen Posts wurden verwendet.'**
  String get allPostsUsed;

  /// No description provided for @contentLibraryTitle.
  ///
  /// In de, this message translates to:
  /// **'Content Library'**
  String get contentLibraryTitle;

  /// No description provided for @allFilter.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get allFilter;

  /// No description provided for @allQuizbooks.
  ///
  /// In de, this message translates to:
  /// **'Alle Quizbögen'**
  String get allQuizbooks;

  /// No description provided for @noPostsInSelection.
  ///
  /// In de, this message translates to:
  /// **'Keine Posts in dieser Auswahl.'**
  String get noPostsInSelection;

  /// No description provided for @questionPostSection.
  ///
  /// In de, this message translates to:
  /// **'Frage-Post'**
  String get questionPostSection;

  /// No description provided for @resolutionPostSection.
  ///
  /// In de, this message translates to:
  /// **'Auflösungs-Post'**
  String get resolutionPostSection;

  /// No description provided for @copyResolution.
  ///
  /// In de, this message translates to:
  /// **'Auflösung kopieren'**
  String get copyResolution;

  /// No description provided for @markQuestion.
  ///
  /// In de, this message translates to:
  /// **'Frage markieren'**
  String get markQuestion;

  /// No description provided for @markResolution.
  ///
  /// In de, this message translates to:
  /// **'Auflösung markieren'**
  String get markResolution;

  /// No description provided for @resetStatus.
  ///
  /// In de, this message translates to:
  /// **'Zurücksetzen'**
  String get resetStatus;

  /// No description provided for @webShareFallbackTitle.
  ///
  /// In de, this message translates to:
  /// **'Teilen nicht unterstützt'**
  String get webShareFallbackTitle;

  /// No description provided for @webShareFallbackHint.
  ///
  /// In de, this message translates to:
  /// **'iPhone Web kann das Bild eventuell nicht direkt teilen. Der Quiztext wurde kopiert – bitte PNG speichern und manuell posten.'**
  String get webShareFallbackHint;

  /// No description provided for @downloadPng.
  ///
  /// In de, this message translates to:
  /// **'PNG herunterladen'**
  String get downloadPng;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
