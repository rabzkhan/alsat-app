import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('tr')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get hello;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @change_theme.
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get change_theme;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get change_language;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet_connection;

  /// No description provided for @server_not_responding.
  ///
  /// In en, this message translates to:
  /// **'Server is not responding!'**
  String get server_not_responding;

  /// No description provided for @some_thing_went_worng.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get some_thing_went_worng;

  /// No description provided for @api_not_found.
  ///
  /// In en, this message translates to:
  /// **'The route you are trying to access is not found!'**
  String get api_not_found;

  /// No description provided for @server_error.
  ///
  /// In en, this message translates to:
  /// **'Server issue'**
  String get server_error;

  /// No description provided for @url_not_found.
  ///
  /// In en, this message translates to:
  /// **'URL issue'**
  String get url_not_found;

  /// No description provided for @good_morning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get good_morning;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Emad Beltaje'**
  String get name;

  /// No description provided for @attendance_registration.
  ///
  /// In en, this message translates to:
  /// **'Attendance Registration'**
  String get attendance_registration;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'09:00 PM'**
  String get time;

  /// No description provided for @vocation.
  ///
  /// In en, this message translates to:
  /// **'Vacations'**
  String get vocation;

  /// No description provided for @remaining_tasks.
  ///
  /// In en, this message translates to:
  /// **'Remaining tasks'**
  String get remaining_tasks;

  /// No description provided for @daysOf_delays.
  ///
  /// In en, this message translates to:
  /// **'Days of delays'**
  String get daysOf_delays;

  /// No description provided for @absent_days.
  ///
  /// In en, this message translates to:
  /// **'Absent days'**
  String get absent_days;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @vacationing_employees.
  ///
  /// In en, this message translates to:
  /// **'Employees on vacation'**
  String get vacationing_employees;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get view_all;

  /// No description provided for @gaza.
  ///
  /// In en, this message translates to:
  /// **'Gaza'**
  String get gaza;

  /// No description provided for @abd_qader.
  ///
  /// In en, this message translates to:
  /// **'Abd-Qader Shareef'**
  String get abd_qader;

  /// No description provided for @loai.
  ///
  /// In en, this message translates to:
  /// **'Loai Arafat'**
  String get loai;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @internet_error.
  ///
  /// In en, this message translates to:
  /// **'Internet connection error ⚠️'**
  String get internet_error;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get product;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @post_add.
  ///
  /// In en, this message translates to:
  /// **'Post Ad'**
  String get post_add;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @confirmExit.
  ///
  /// In en, this message translates to:
  /// **'Confirm Exit'**
  String get confirmExit;

  /// No description provided for @doYouWantToGoBack.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to go back?'**
  String get doYouWantToGoBack;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @addPost.
  ///
  /// In en, this message translates to:
  /// **'Add Post'**
  String get addPost;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @modelType.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelType;

  /// No description provided for @bodyType.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get bodyType;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @engine.
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get engine;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @passedKm.
  ///
  /// In en, this message translates to:
  /// **'Passed KM'**
  String get passedKm;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @floorType.
  ///
  /// In en, this message translates to:
  /// **'Floor Type'**
  String get floorType;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @lift.
  ///
  /// In en, this message translates to:
  /// **'Lift'**
  String get lift;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @contactWithSeller.
  ///
  /// In en, this message translates to:
  /// **'Contact With Seller'**
  String get contactWithSeller;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @add_story.
  ///
  /// In en, this message translates to:
  /// **'Add Story'**
  String get add_story;

  /// No description provided for @chat_with_admin.
  ///
  /// In en, this message translates to:
  /// **'Chat With Admin'**
  String get chat_with_admin;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @chat_history.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chat_history;

  /// No description provided for @search_here.
  ///
  /// In en, this message translates to:
  /// **'Search Here'**
  String get search_here;

  /// No description provided for @by_posting_you_confirm.
  ///
  /// In en, this message translates to:
  /// **'By posting, you confirm the agreement with terms and conditions of'**
  String get by_posting_you_confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @at_least_one_image.
  ///
  /// In en, this message translates to:
  /// **'At least one image'**
  String get at_least_one_image;

  /// No description provided for @please_select_all_required_fields.
  ///
  /// In en, this message translates to:
  /// **'Please select all required fields'**
  String get please_select_all_required_fields;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @add_your_stuff.
  ///
  /// In en, this message translates to:
  /// **'Post ads'**
  String get add_your_stuff;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @not_chosen_yet.
  ///
  /// In en, this message translates to:
  /// **'Not chosen yet'**
  String get not_chosen_yet;

  /// No description provided for @sub_category.
  ///
  /// In en, this message translates to:
  /// **'Sub Category'**
  String get sub_category;

  /// No description provided for @product_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get product_name;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @filled.
  ///
  /// In en, this message translates to:
  /// **'Filled'**
  String get filled;

  /// No description provided for @describe_your_product.
  ///
  /// In en, this message translates to:
  /// **'Describe your product'**
  String get describe_your_product;

  /// No description provided for @vin_code.
  ///
  /// In en, this message translates to:
  /// **'VIN code'**
  String get vin_code;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @possible_exchange.
  ///
  /// In en, this message translates to:
  /// **'Possible Exchange'**
  String get possible_exchange;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @individual_info.
  ///
  /// In en, this message translates to:
  /// **'Individual Info'**
  String get individual_info;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @when_i_am.
  ///
  /// In en, this message translates to:
  /// **'When I am free for call'**
  String get when_i_am;

  /// No description provided for @free_to_call.
  ///
  /// In en, this message translates to:
  /// **'Free To Call'**
  String get free_to_call;

  /// No description provided for @from_na.
  ///
  /// In en, this message translates to:
  /// **'From N/A'**
  String get from_na;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'TO'**
  String get to;

  /// No description provided for @to_na.
  ///
  /// In en, this message translates to:
  /// **'TO N/A'**
  String get to_na;

  /// No description provided for @allow_me_to_call.
  ///
  /// In en, this message translates to:
  /// **'Allow calling to me'**
  String get allow_me_to_call;

  /// No description provided for @contact_only_in_chat.
  ///
  /// In en, this message translates to:
  /// **'Allow chatting'**
  String get contact_only_in_chat;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @body_type.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get body_type;

  /// No description provided for @transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// No description provided for @engine_type.
  ///
  /// In en, this message translates to:
  /// **'Engine Type'**
  String get engine_type;

  /// No description provided for @passed_km.
  ///
  /// In en, this message translates to:
  /// **'Passed, km'**
  String get passed_km;

  /// No description provided for @estate_type.
  ///
  /// In en, this message translates to:
  /// **'Estate type'**
  String get estate_type;

  /// No description provided for @deal_type.
  ///
  /// In en, this message translates to:
  /// **'Renovation type'**
  String get deal_type;

  /// No description provided for @select_number_of_floor.
  ///
  /// In en, this message translates to:
  /// **'Select Number of Floor'**
  String get select_number_of_floor;

  /// No description provided for @select_number_of_room.
  ///
  /// In en, this message translates to:
  /// **'Select Number of Room'**
  String get select_number_of_room;

  /// No description provided for @lift_available.
  ///
  /// In en, this message translates to:
  /// **'Lift Available'**
  String get lift_available;

  /// No description provided for @no_messages.
  ///
  /// In en, this message translates to:
  /// **'No Messages'**
  String get no_messages;

  /// No description provided for @we_cant_find_what_youre_looking_for.
  ///
  /// In en, this message translates to:
  /// **'We can\'t find what you\'re looking for.'**
  String get we_cant_find_what_youre_looking_for;

  /// No description provided for @no_data_available_yet.
  ///
  /// In en, this message translates to:
  /// **'No Data Available Yet'**
  String get no_data_available_yet;

  /// No description provided for @active_now.
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get active_now;

  /// No description provided for @last_seen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get last_seen;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @block_user.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get block_user;

  /// No description provided for @you_have_blocked_this_user.
  ///
  /// In en, this message translates to:
  /// **'You have blocked this user'**
  String get you_have_blocked_this_user;

  /// No description provided for @you_cant_send_message_to_this_user.
  ///
  /// In en, this message translates to:
  /// **'You can\'t send message to this user'**
  String get you_cant_send_message_to_this_user;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'UnBlock'**
  String get unblock;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @reply_message.
  ///
  /// In en, this message translates to:
  /// **'Reply Message'**
  String get reply_message;

  /// No description provided for @type_message.
  ///
  /// In en, this message translates to:
  /// **'Type message'**
  String get type_message;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @prevents.
  ///
  /// In en, this message translates to:
  /// **'Prevents'**
  String get prevents;

  /// No description provided for @unwanted.
  ///
  /// In en, this message translates to:
  /// **'Unwanted'**
  String get unwanted;

  /// No description provided for @wanted.
  ///
  /// In en, this message translates to:
  /// **'Wanted'**
  String get wanted;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @they_wont_be_able_to_send_you_messages.
  ///
  /// In en, this message translates to:
  /// **'They won\'t be able to send you messages'**
  String get they_wont_be_able_to_send_you_messages;

  /// No description provided for @they.
  ///
  /// In en, this message translates to:
  /// **'They'**
  String get they;

  /// No description provided for @wont.
  ///
  /// In en, this message translates to:
  /// **'Won\'t'**
  String get wont;

  /// No description provided for @want.
  ///
  /// In en, this message translates to:
  /// **'Want'**
  String get want;

  /// No description provided for @be_notified.
  ///
  /// In en, this message translates to:
  /// **'Be notified'**
  String get be_notified;

  /// No description provided for @we_wont_tell_them_if_you_block_them.
  ///
  /// In en, this message translates to:
  /// **'We won\'t tell them if you block them. Unblock them to send messages'**
  String get we_wont_tell_them_if_you_block_them;

  /// No description provided for @report_description.
  ///
  /// In en, this message translates to:
  /// **'Report Description'**
  String get report_description;

  /// No description provided for @report_reason.
  ///
  /// In en, this message translates to:
  /// **'Report Reason'**
  String get report_reason;

  /// No description provided for @my_listings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get my_listings;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get liked;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @upgrade_to_premium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgrade_to_premium;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get user_name;

  /// No description provided for @about_me.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get about_me;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Updated Successfully'**
  String get updated_successfully;

  /// No description provided for @alert_information.
  ///
  /// In en, this message translates to:
  /// **'Alert Information'**
  String get alert_information;

  /// No description provided for @popular_categories.
  ///
  /// In en, this message translates to:
  /// **'Popular Categories'**
  String get popular_categories;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get see_all;

  /// No description provided for @find_users.
  ///
  /// In en, this message translates to:
  /// **'Find Users'**
  String get find_users;

  /// No description provided for @no_location.
  ///
  /// In en, this message translates to:
  /// **'No Location'**
  String get no_location;

  /// No description provided for @buyer_protection.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get buyer_protection;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// No description provided for @successfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully'**
  String get successfully;

  /// No description provided for @delete_account_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action cannot be undone.'**
  String get delete_account_confirmation;

  /// No description provided for @select_category.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get select_category;

  /// No description provided for @min_to_max.
  ///
  /// In en, this message translates to:
  /// **'Min To Max'**
  String get min_to_max;

  /// No description provided for @max_to_min.
  ///
  /// In en, this message translates to:
  /// **'Max To Min'**
  String get max_to_min;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @new_to_old.
  ///
  /// In en, this message translates to:
  /// **'New To Old'**
  String get new_to_old;

  /// No description provided for @old_to_new.
  ///
  /// In en, this message translates to:
  /// **'Old To New'**
  String get old_to_new;

  /// No description provided for @active_account.
  ///
  /// In en, this message translates to:
  /// **'Active Account'**
  String get active_account;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get select_location;

  /// No description provided for @default_.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default_;

  /// No description provided for @the_newest.
  ///
  /// In en, this message translates to:
  /// **'The Newest'**
  String get the_newest;

  /// No description provided for @the_cheaper_price_first.
  ///
  /// In en, this message translates to:
  /// **'The Cheaper Price First'**
  String get the_cheaper_price_first;

  /// No description provided for @the_highest_price_first.
  ///
  /// In en, this message translates to:
  /// **'The Highest Price First'**
  String get the_highest_price_first;

  /// No description provided for @mobile_brand.
  ///
  /// In en, this message translates to:
  /// **'Mobile Brand'**
  String get mobile_brand;

  /// No description provided for @account_type.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get account_type;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @ordinary.
  ///
  /// In en, this message translates to:
  /// **'Ordinary'**
  String get ordinary;

  /// No description provided for @choose_brand.
  ///
  /// In en, this message translates to:
  /// **'Choose Brand'**
  String get choose_brand;

  /// No description provided for @drive_type.
  ///
  /// In en, this message translates to:
  /// **'Drive Type'**
  String get drive_type;

  /// No description provided for @exchange.
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get exchange;

  /// No description provided for @has_a_vin_code.
  ///
  /// In en, this message translates to:
  /// **'Has A VIN Code'**
  String get has_a_vin_code;

  /// No description provided for @year_range.
  ///
  /// In en, this message translates to:
  /// **'Year Range'**
  String get year_range;

  /// No description provided for @product_fetching_failed.
  ///
  /// In en, this message translates to:
  /// **'Product fetching failed'**
  String get product_fetching_failed;

  /// No description provided for @rate_successfully.
  ///
  /// In en, this message translates to:
  /// **'Rate Successfully'**
  String get rate_successfully;

  /// No description provided for @rate_failed.
  ///
  /// In en, this message translates to:
  /// **'Rate Failed'**
  String get rate_failed;

  /// No description provided for @follow_failed.
  ///
  /// In en, this message translates to:
  /// **'Follow Failed'**
  String get follow_failed;

  /// No description provided for @failed_to_get_conversation_info.
  ///
  /// In en, this message translates to:
  /// **'Failed to get conversation info'**
  String get failed_to_get_conversation_info;

  /// No description provided for @post_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Post deleted successfully'**
  String get post_deleted_successfully;

  /// No description provided for @failed_to_delete_post.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete post'**
  String get failed_to_delete_post;

  /// No description provided for @product_not_found.
  ///
  /// In en, this message translates to:
  /// **'Product Not Found'**
  String get product_not_found;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'User Not Found'**
  String get user_not_found;

  /// No description provided for @product_posted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Product posted successfully'**
  String get product_posted_successfully;

  /// No description provided for @product_posting_failed.
  ///
  /// In en, this message translates to:
  /// **'Product posting failed'**
  String get product_posting_failed;

  /// No description provided for @product_like_failed.
  ///
  /// In en, this message translates to:
  /// **'Product like failed'**
  String get product_like_failed;

  /// No description provided for @unliked.
  ///
  /// In en, this message translates to:
  /// **'Unliked'**
  String get unliked;

  /// No description provided for @no_comment_available_right_now.
  ///
  /// In en, this message translates to:
  /// **'No Comment Available Right Now'**
  String get no_comment_available_right_now;

  /// No description provided for @please_enter_comment.
  ///
  /// In en, this message translates to:
  /// **'Please enter comment'**
  String get please_enter_comment;

  /// No description provided for @write_a_comment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment'**
  String get write_a_comment;

  /// No description provided for @update_your_stuff.
  ///
  /// In en, this message translates to:
  /// **'Update Your Stuff'**
  String get update_your_stuff;

  /// No description provided for @post_images.
  ///
  /// In en, this message translates to:
  /// **'Post Images'**
  String get post_images;

  /// No description provided for @please_select_image.
  ///
  /// In en, this message translates to:
  /// **'Please select image'**
  String get please_select_image;

  /// No description provided for @upload_images.
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get upload_images;

  /// No description provided for @you_can_not_delete_the_last_image.
  ///
  /// In en, this message translates to:
  /// **'You can not delete the last image'**
  String get you_can_not_delete_the_last_image;

  /// No description provided for @post_videos.
  ///
  /// In en, this message translates to:
  /// **'Post Videos'**
  String get post_videos;

  /// No description provided for @please_pick_videos.
  ///
  /// In en, this message translates to:
  /// **'Please pick videos'**
  String get please_pick_videos;

  /// No description provided for @upload_videos.
  ///
  /// In en, this message translates to:
  /// **'Upload Videos'**
  String get upload_videos;

  /// No description provided for @post_title.
  ///
  /// In en, this message translates to:
  /// **'Post Title'**
  String get post_title;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update_info.
  ///
  /// In en, this message translates to:
  /// **'Update Info'**
  String get update_info;

  /// No description provided for @resend_otp_in.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in'**
  String get resend_otp_in;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resend_otp;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying'**
  String get verifying;

  /// No description provided for @verify_and_login.
  ///
  /// In en, this message translates to:
  /// **'Verify & Login'**
  String get verify_and_login;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @unlock_premium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get unlock_premium;

  /// No description provided for @upgrade_code.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to premium by entering your 8-digit code.'**
  String get upgrade_code;

  /// No description provided for @dont_have_code.
  ///
  /// In en, this message translates to:
  /// **'Don’t have a code? Contact support to learn more about premium features.'**
  String get dont_have_code;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'apply'**
  String get apply;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout from all devices ?'**
  String get logout_confirmation;

  /// No description provided for @refresh_completed.
  ///
  /// In en, this message translates to:
  /// **'Refresh Completed'**
  String get refresh_completed;

  /// No description provided for @pull_up_load.
  ///
  /// In en, this message translates to:
  /// **'Pull up to load more'**
  String get pull_up_load;

  /// No description provided for @load_failed.
  ///
  /// In en, this message translates to:
  /// **'Load failed!'**
  String get load_failed;

  /// No description provided for @release_to_load_more.
  ///
  /// In en, this message translates to:
  /// **'Release to load more'**
  String get release_to_load_more;

  /// No description provided for @no_more_data.
  ///
  /// In en, this message translates to:
  /// **'No more data available'**
  String get no_more_data;

  /// No description provided for @my_stories.
  ///
  /// In en, this message translates to:
  /// **'My Stories'**
  String get my_stories;

  /// No description provided for @login_required.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get login_required;

  /// No description provided for @login_required_long.
  ///
  /// In en, this message translates to:
  /// **'You need to log in to access this feature.'**
  String get login_required_long;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit.'**
  String get pressBackAgainToExit;

  /// No description provided for @car_class.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get car_class;

  /// No description provided for @choose_location.
  ///
  /// In en, this message translates to:
  /// **'Choose Location'**
  String get choose_location;

  /// No description provided for @live_stories.
  ///
  /// In en, this message translates to:
  /// **'Live Stories'**
  String get live_stories;

  /// No description provided for @archive_stories.
  ///
  /// In en, this message translates to:
  /// **'Archive Stories'**
  String get archive_stories;

  /// No description provided for @re_post.
  ///
  /// In en, this message translates to:
  /// **'Re-post'**
  String get re_post;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @user_agrement.
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get user_agrement;

  /// No description provided for @variy_your_number.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Phone Number'**
  String get variy_your_number;

  /// No description provided for @to_authenticate.
  ///
  /// In en, this message translates to:
  /// **'To authenticate, a message will be sent from the number you entered to'**
  String get to_authenticate;

  /// No description provided for @send_message.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get send_message;

  /// No description provided for @by_continuing.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you consent to send this message. Standard rates may apply.'**
  String get by_continuing;

  /// No description provided for @login_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Login as Guest'**
  String get login_as_guest;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
