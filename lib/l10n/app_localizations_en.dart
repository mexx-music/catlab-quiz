// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CatLab 🐱 Quiz';

  @override
  String get chooseQuizbook => 'Choose a quiz:';

  @override
  String get quizOfTheDay => 'Quiz of the Day';

  @override
  String get dailyQuizSubtitle => '5 random questions from all categories';

  @override
  String bestScore(int score, int total) {
    return 'Best score: $score / $total';
  }

  @override
  String get questionOfTheDay => 'Question of the Day';

  @override
  String get quizbooks => 'Quiz Books';

  @override
  String get postCopy => 'Copy post';

  @override
  String get resolutionCopy => 'Copy resolution';

  @override
  String get questionOfDayCopied => 'Question of the Day copied';

  @override
  String get resolutionCopied => 'Resolution copied';

  @override
  String get showPostText => 'Show post text';

  @override
  String get postTextCopied => 'Post text copied';

  @override
  String get adminAccess => 'Admin Access';

  @override
  String get codeLabel => 'Code';

  @override
  String get unlock => 'Unlock';

  @override
  String get cancel => 'Cancel';

  @override
  String get wrongCode => 'Wrong code';

  @override
  String get lockAdmin => '🔒 Lock admin';

  @override
  String get next => 'Next';

  @override
  String get showResult => 'Show Result';

  @override
  String get result => 'Result';

  @override
  String points(int score, int total) {
    return '$score / $total Points';
  }

  @override
  String get levelExpert => 'Cat Expert';

  @override
  String get levelExpertDesc => 'You know cats amazingly well.';

  @override
  String get levelKnower => 'Cat Connoisseur';

  @override
  String get levelKnowerDesc =>
      'You already know quite a bit about cats – impressive!';

  @override
  String get levelFriend => 'Cat Friend';

  @override
  String get levelFriendDesc => 'You love cats and keep learning more.';

  @override
  String get levelBeginner => 'Cat Beginner';

  @override
  String get levelBeginnerDesc =>
      'Still room to grow – but you\'re on the right track!';

  @override
  String get newHighscore => '🎉 New Highscore!';

  @override
  String get copyResult => 'Copy Result';

  @override
  String get playAgain => 'Play Again';

  @override
  String get resultCopied => 'Result copied';

  @override
  String get catQuestionBadge => '🐱 Cat Question';

  @override
  String get whatDoYouThink => 'What do you think? 👇';

  @override
  String get testYourKnowledge => 'Test your cat knowledge:';

  @override
  String get copy => 'Copy';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get download => 'Download';

  @override
  String get postCreatorTitle => 'Post Creator';

  @override
  String get copyText => 'Copy text';

  @override
  String get shareBtn => 'Share';

  @override
  String get sharingInProgress => 'Sharing…';

  @override
  String get createPng => 'Create PNG';

  @override
  String get creatingPng => 'Creating…';

  @override
  String get pngCreationFailed => 'PNG creation failed';

  @override
  String get pngCreatedTitle => 'PNG created';

  @override
  String get imageSharedTitle => 'Image shared';

  @override
  String get quizTextCopiedHint =>
      'The quiz text has been copied – please paste it in the Facebook text field.';

  @override
  String get recopyText => 'Copy text again';

  @override
  String get quizTextRecopied => 'Quiz text copied again';

  @override
  String get imageSharedTextCopied => 'Image shared – text was copied';

  @override
  String get quizbookLabel => 'Quiz Book';

  @override
  String get questionSelectorLabel => 'Question';

  @override
  String get formatLabel => 'Format';

  @override
  String get chooseQuizHint => 'Choose quiz...';

  @override
  String get firstChooseQuizbook => 'Choose a quiz first';

  @override
  String get chooseQuestionHint => 'Choose question...';

  @override
  String get questionPostLabel => '🐱 Question post';

  @override
  String get resolutionComingSoon => '✅ Resolution (soon)';

  @override
  String get pasteHint =>
      'Copy and paste into Facebook, Instagram, Threads or Pinterest.';

  @override
  String get prepareSharingTitle => 'Prepare to share';

  @override
  String get sizeLabel => 'Size';

  @override
  String get fileLabel => 'File';

  @override
  String get exportTitle => 'Export';

  @override
  String get postsTotalLabel => 'Total posts';

  @override
  String get openPostsLabel => 'Open';

  @override
  String get donePostsLabel => 'Done';

  @override
  String get copyJson => 'Copy JSON';

  @override
  String get copyCsv => 'Copy CSV';

  @override
  String get jsonCopied => 'JSON copied';

  @override
  String get csvCopied => 'CSV copied';

  @override
  String get schedulerHint =>
      'Compatible with Publer · Buffer · Metricool and other\nscheduling tools.';

  @override
  String get todayPostTitle => 'Post today';

  @override
  String get plannedToday => 'Planned today:';

  @override
  String get questionPosted => 'Question posted';

  @override
  String get resolutionPosted => 'Resolution posted';

  @override
  String get questionPostCopied => 'Question post copied';

  @override
  String get noOpenQuestions => 'No open questions – all have been posted.';

  @override
  String get noResolutionsWaiting =>
      'No questions are waiting for their resolution.';

  @override
  String get allPostsUsed => 'All current posts have been used.';

  @override
  String get contentLibraryTitle => 'Content Library';

  @override
  String get allFilter => 'All';

  @override
  String get allQuizbooks => 'All Quiz Books';

  @override
  String get noPostsInSelection => 'No posts in this selection.';

  @override
  String get questionPostSection => 'Question post';

  @override
  String get resolutionPostSection => 'Resolution post';

  @override
  String get copyResolution => 'Copy resolution';

  @override
  String get markQuestion => 'Mark question';

  @override
  String get markResolution => 'Mark resolution';

  @override
  String get resetStatus => 'Reset';

  @override
  String get webShareFallbackTitle => 'Sharing Not Supported';

  @override
  String get webShareFallbackHint =>
      'iPhone web may not be able to share the image directly. The quiz text has been copied – please save the PNG and post manually.';

  @override
  String get downloadPng => 'Download PNG';
}
