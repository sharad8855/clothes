import 'package:flutter/material.dart';
import '../../languages/english_language.dart';
import '../../languages/hindi_language.dart';
import '../../languages/marathi_language.dart';

class AppLocalizations {
    String get bespokeAtelier => translate('bespoke_atelier');
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> get _localizedStrings {
    switch (locale.languageCode) {
      case 'mr':
        return marathiStrings;
      case 'hi':
        return hindiStrings;
      case 'en':
      default:
        return englishStrings;
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Getters
  String get sangamnerAi => translate('sangamner_ai');
  String get homeTitle => translate('home_title');
  String get homeSubtitle => translate('home_subtitle');
  String get welcomeToBaapCompany => translate('welcome_to_baap_company');
  String get changeLanguage => translate('change_language');
  String get marathi => translate('marathi');
  String get english => translate('english');
  String get hindi => translate('hindi');
  String get profile => translate('profile');
  

  // Choose language screen (pre-login)
  String get chooseYourLanguage => translate('choose_your_language');
  String get selectLanguageDesc => translate('select_language_desc');

  // bottom bar
  String get home => translate("home");
  String get footprints => translate("footprints");
  String get ai => translate("ai");
  String get categories => translate("categories");
  String get myActivity => translate("my_activity");
  String get bookings => translate("bookings");
  String get staff => translate("staff");
  String get sales => translate("sales");

  String get verifyNumber => translate('verify_number');
  String get enterOtp => translate('enter_otp');
  String get verificationCode => translate('verification_code');
  String get resendCode => translate('resend_code');
  String get changeNumber => translate('change_number');
  String get next => translate('next');
  String get setLocation => translate('set_location');
  String get locationDesc => translate('location_desc');
  String get enterLocation => translate('enter_location');
  String get welcome => translate('Welcome');
  String get skip => translate('skip');
  String get splashDiscover => translate('splash_discover');
  String get splashTrusted => translate('splash_trusted');
  String get splashVisit => translate('splash_visit');
  String get splashOffers => translate('splash_offers');
  String get splashEffort => translate('splash_effort');
  String get splashRewarded => translate('splash_rewarded');
  String get setYourLocation => translate('set_your_location');
  String get whereAreYouRightNow => translate('where_are_you_right_now');
  String get exploreDesc => translate('explore_desc');
  String get enterLocationManually => translate('enter_location_manually');
  String get useCurrentLocation => translate('use_current_location');
  String get welcomeTo => translate('welcome_to');
  String get findNearbyDesc => translate('find_nearby_desc');
  String get findServicesOffers => translate('find_services_offers');
  String get iHaveABusiness => translate('i_have_a_business');
  String get continueText => translate('continue');
  String get back => translate('back');
  String get verifyBusinessNumber => translate('verify_business_number');
  String get enterPhoneDesc => translate('enter_phone_desc');
  String get phoneNumber => translate('phone_number');
  String get enterMobileNumber => translate('enter_mobile_number');
  String get enterValidMobile => translate('enter_valid_mobile');
  String get sending => translate('sending');
  String get setUpYourBusiness => translate('set_up_business');
  String get aboutBusiness => translate('about_business');
  String get businessName => translate('business_name');
  String get enterBusinessName => translate('enter_business_name');
  String get businessNameRequired => translate('business_name_required');
  String get businessType => translate('business_type');
  String get searchSelectCategory => translate('search_select_category');
  String get businessPhoneNumber => translate('business_phone_number');
  String get enterBusinessContact => translate('enter_business_contact');
  String get businessLogo => translate('business_logo');
  String get dropFilesUpload => translate('drop_files_upload');
  String get browseFiles => translate('browse_files');
  String get uploadComplete => translate('upload_complete');
  String get searchCategoryHint => translate('search_category_hint');
  String get wholesaler => translate('wholesaler');
  String get retailer => translate('retailer');
  String get onlineReseller => translate('online_reseller');
  String get manufacturer => translate('manufacturer');
  String get distributor => translate('distributor');
  String get general => translate('general');
  String get seller => translate('seller');
  String get customer => translate('customer');
  String get agricultureServices => translate('agriculture_services');
  String get growBusinessLocally => translate('grow_business_locally');
  String get growBusinessDesc => translate('grow_business_desc');
  String get alreadyRegisteredLogin => translate('already_registered_login');
  String get registerMyBusiness => translate('register_my_business');

  String get servicesProvide => translate('services_provide');
  String get addServices => translate('add_services');
  String get addUpTo15Services => translate('add_up_to_15_services');
  String get searchServices => translate('search_services');
  String get productsSell => translate('products_sell');
  String get uploadFile => translate('upload_file');
  String get uploadExcel => translate('upload_excel');
  String get about => translate('about');
  String get offer => translate('offer');

  String get whenareyouopen => translate('when_are_you_open');
  String get workingDays => translate('working_days');
  String get businessHours => translate('business_hours');
  String get openingTime => translate('opening_time');
  String get closingTime => translate('closing_time');
  String get youAreAllSet => translate("you_are_all_set");
  String get confirm => translate("confirm");
  String get goToHome => translate("go_to_home");
  String get customersSeeTime => translate("customers_see_time");
  String get hoursVaryNote => translate("hours_vary_note");

  // ai chat lang
  String get greetingHi => translate('greeting_hi');
  String get quickopenNearby => translate("quick_open_nearby");
  String get quickoffersNearby => translate("quick_offers_nearby");
  String get quickbookAppointment => translate("quick_book_appointment");
  String get quickbestServices => translate("quick_best_services");
  String get quickfootprintsNearby => translate("quick_footprints_nearby");
  String get asksangamneraAi => translate("ask_sangamner_ai");
  String get buttonSearch => translate("button_search");
  String get buttonVoice => translate("button_voice");
  String get buttonAichat => translate("button_aichat");
  String get buttonMute => translate("button_mute");
  String get buttonCancel => translate("button_cancel");
  String get whereyourbusinessLocated =>
      translate("Where_your_business_located");

  // appoinment lang
  String get myAppoinments => translate("my_Appoinments");
  String get tabbarUpcoming => translate("tabbar_Upcoming");
  String get tabbarHistory => translate("tabbar_History");
  String get tabbarCompleted => translate("tabbar_Completed");
  String get tabbarCancelled => translate("tabbar_Cancelled");
  String get searchcarWashing => translate("search_car_Washing");
  String get noappointmentsFound => translate("no_appointments_Found");
  String get reschedule => translate("reschedule");
  String get getDirections => translate("get_directions");
  String get markAsNotInterested => translate("mark_as_not_interested");
  String get viewDetails => translate("view_details");
  String get callStore => translate("call_store");
  String get cancelBooking => translate("cancel_booking");
  String get cancelBookingConfirmMsg => translate("cancel_booking_confirm_msg");
  String get enterCancellationReason => translate("enter_cancellation_reason");
  String get pleaseEnterReason => translate("please_enter_reason");

  // appoinment review
  String get rateYourExperience => translate("rate_your_Experience");
  String get skipForNow => translate("skip_for_Now");
  String get submitReview => translate("submit_Review");
  String get ratingPoor => translate("rating_poor");
  String get ratingFair => translate("rating_fair");
  String get ratingGood => translate("rating_good");
  String get ratingVeryGood => translate("rating_very_good");
  String get ratingExcellent => translate("rating_excellent");
  String get cleanAndHygienic => translate("clean_and_hygienic");
  String get professionalStaff => translate("professional_staff");
  String get onTimeService => translate("on_time_service");
  String get friendlyBehaviour => translate("friendly_behaviour");
  String get goodValueForMoney => translate("good_value_for_money");
  String get smoothExperience => translate("smooth_experience");
  String get wellOrganized => translate("well_organized");
  String get easyBooking => translate("easy_booking");
  String get tellUsMore => translate("tell_us_more");
  String get reviewHintText => translate("review_hinttext");
  String get recommendServices => translate("recommend_services");

  // appoinment filter
  String get filters => translate("filters");
  String get date => translate("date");
  String get today => translate("today");
  String get tomorrow => translate("tomorrow");
  String get thisWeek => translate("this_week");
  String get serviceType => translate("service_type");
  String get carService => translate("car_service");
  String get beauty => translate("beauty");
  String get health => translate("health");
  String get restaurants => translate("restaurants");
  String get laundry => translate("laundry");
  String get homeServices => translate("home_services");
  String get status => translate("status");
  String get pending => translate("pending");
  String get accepted => translate("accepted");
  String get completed => translate("completed");
  String get cancelled => translate("cancelled");
  String get rejected => translate("rejected");
  String get bookingType => translate("booking_type");
  String get inPerson => translate("in_person");
  String get homeService => translate("home_service");
  String get pickupDrop => translate("pickup_drop");
  String get clearAll => translate("clear_all");
  String get showResults => translate("show_results");

  // Profile & auth
  String get myProfile => translate('my_profile');
  String get languageSelection => translate('language_selection');
  String get editProfile => translate('edit_profile');
  String get name => translate('name');
  String get emailAddress => translate('email_address');
  String get email => translate('email');
  String get enterEmail => translate('enter_email');
  String get emailRequired => translate('email_required');
  String get invalidEmail => translate('invalid_email');
  String get mobileNumber => translate('mobile_number');
  String get mobileNumberRequired => translate('mobile_number_required');
  String get mobileNumberInvalid => translate('mobile_number_invalid');
  String get profileUpdatedSuccess => translate('profile_updated_success');
  String get imageFileNotFound => translate('image_file_not_found');
  String get logoutSuccess => translate('logout_success');
  String get gender => translate('gender');
  String get logout => translate('logout');
  String get areYouSureLogout => translate('are_you_sure_logout');
  String get cancel => translate('cancel');
  String get nA => translate('n_a');
  String get saveChanges => translate('save_changes');
  String get welcomeBack => translate('welcome_back');
  String get pleaseLoginEmailPassword => translate('please_login_email_password');
  String get emailOrMobile => translate('email_or_mobile');
  String get enterEmailOrMobile => translate('enter_email_or_mobile');
  String get password => translate('password');
  String get enterPassword => translate('enter_password');
  String get createAccount => translate('create_account');
  String get joinSangamnerDesc => translate('join_sangamner_desc');
  String get confirmPassword => translate('confirm_password');
  String get reEnterPassword => translate('re_enter_password');
  String get loading => translate('loading');
  String get signUp => translate('sign_up');
  String get alreadyHaveAccount => translate('already_have_account');
  String get login => translate('login');
  String get forgotPassword => translate('forgot_password');
  String get dontHaveAccount => translate('dont_have_account');
  String get loggingIn => translate('logging_in');
  String get bySigningIn => translate('by_signing_in');
  String get and => translate('and');
  String get termsOfServices => translate('terms_of_services');
  String get privacyPolicy => translate('privacy_policy');

  // Business profile & dashboard
  String get gstVerified => translate('gst_verified');
  String get dashboard => translate('dashboard');
  String get openNow => translate('open_now');
  String get closed => translate('closed');
  String get closesAt => translate('closes_at');
  String get changeTime => translate('change_time');
  String get servicesAndPricing => translate('services_and_pricing');
  String get manage => translate('manage');
  String get offersAndPromotions => translate('offers_and_promotions');
  String get addOffer => translate('add_offer');
  String get shopLocation => translate('shop_location');
  String get addLocation => translate('add_location');
  String get businessAppsMadeForYou => translate('business_apps_made_for_you');
  String get tryAiFeature => translate('try_ai_feature');
  String get salonErpSystem => translate('salon_erp_system');
  String get exploreErp => translate('explore_erp');
  String get appointmentBookingSystem => translate('appointment_booking_system');
  String get getStarted => translate('get_started');
  String get aiHairstyleTryOn => translate('ai_hairstyle_try_on');
  String get topServicesToday => translate('top_services_today');
  String get todaysAppointments => translate('todays_appointments');
  String get todaysServices => translate('todays_services');
  String get noServicesFoundToday => translate('no_services_found_today');
  String get appointmentsToday => translate('appointments_today');
  String get goodMorning => translate('good_morning');
  String get goodAfternoon => translate('good_afternoon');
  String get goodEvening => translate('good_evening');
  String get youreAllSetBusyDay => translate('youre_all_set_busy_day');
  String get viewAppointments => translate('view_appointments');
  String get appointments => translate('appointments');
  String get revenue => translate('revenue');
  String get rating => translate('rating');
  String get appointmentConfirmation => translate('appointment_confirmation');
  String get appointmentWaitingConfirmation => translate('appointment_waiting_confirmation');
  String get review => translate('review');

  // Community & business detail
  String get community => translate('community');
  String get reels => translate('reels');
  String get saved => translate('saved');
  String get upload => translate('upload');
  String get follow => translate('follow');
  String get share => translate('share');
  String get followers => translate('followers');
  String get askToSangamnerAi => translate('ask_to_sangamner_ai');
  String get bookAppointment => translate('book_appointment');
  String get noDescriptionAvailable => translate('no_description_available');
  String get services => translate('services');
  String get reviews => translate('reviews');
  String get policies => translate('policies');
  String get tryHairstylesAi => translate('try_hairstyles_ai');
  String get previewHairstylesAi => translate('preview_hairstyles_ai');
  String get getDirection => translate('get_direction');
  String get viewAllReviews => translate('view_all_reviews');
  String get location => translate('location');
  String get similarBusinessesNearby => translate('similar_businesses_nearby');
  String get appointmentPolicy => translate('appointment_policy');
  String get appointmentsRecommended => translate('appointments_recommended');
  String get walkInsAccepted => translate('walk_ins_accepted');
  String get cancellationPolicy => translate('cancellation_policy');
  String get changesSubjectAvailability => translate('changes_subject_availability');
  String get servicePricingPolicy => translate('service_pricing_policy');
  String get finalDetailsConfirmed => translate('final_details_confirmed');
  String get offersApplySelected => translate('offers_apply_selected');
  String get completeGroomingDay => translate('complete_grooming_day');

  // My activity
  String get manageMyBusiness => translate('manage_my_business');
  String get orders => translate('orders');
  String get myCart => translate('my_cart');
  String get wishlist => translate('wishlist');
  String get rewards => translate('rewards');
  String get recentlyViewed => translate('recently_viewed');
  String get firstName => translate('first_name');
  String get lastName => translate('last_name');
  String get search => translate('search');
  String get searchCategories => translate('search_categories');
  String get noFootprintsFound => translate('no_footprints_found');
  String get validToday => translate('valid_today');
  String get noServiceCategoryFound => translate('no_service_category_found');
  String get noRecentlyViewedBusinessesFound =>
      translate('no_recently_viewed_businesses_found');
  String get noPopularBusinessesFound =>
      translate('no_popular_businesses_found');
  String get noCategoriesFound => translate('no_categories_found');
  String get completeProfile => translate('complete_profile');
  String get allowOnce => translate('allow_once');
  String get allowWhileUsingApp => translate('allow_while_using_app');
  String get dontAllow => translate('dont_allow');
  String get exploreNearby => translate('explore_nearby');
  String get noServicesAvailable => translate('no_services_available');
  String get enterCouponCode => translate('enter_coupon_code');
  String get enterRegisteredMobile => translate('enter_registered_mobile');
  String get enter6DigitOtp => translate('enter_6_digit_otp');
  String get enterNewPassword => translate('enter_new_password');
  String get reEnterNewPassword => translate('re_enter_new_password');
  String get resetPassword => translate('reset_password');
  String get upTo30Off => translate('up_to_30_off');
  String get bigSavings => translate('big_savings');
  String get electronics => translate('electronics');
  String get groceryService => translate('grocery_service');
  String get rememberPassword => translate('remember_password');
  String get backToLogin => translate('back_to_login');
  String get chooseNewPassword => translate('choose_new_password');
  String get newPassword => translate('new_password');
  String get retypePassword => translate('retype_password');
  String get male => translate('male');
  String get female => translate('female');
  String get otp => translate('otp');
  String get verifyOtp => translate('verify_otp');
  String get sendOtp => translate('send_otp');
  String get popular => translate('popular');
  String get availablenearby => translate('availablenearby');
  String get trending => translate('trending');
  String get shopstore => translate('shopstore');
  String get footprintsnearyou => translate('footprintsnearyou');
  String get browsebycategory => translate('browsebycategory');
  String get findservices => translate('findservices');
  String get recentlyviewed => translate('recentlyviewed');
  String get addNewBusiness => translate('add_new_business');
  String get chooseyourlanguage => translate('chooseyourlanguage');
  String get discover => translate('discover');
  String get youare => translate('youare');
  String get nearbyServices => translate('nearbyServices');
  String get explore => translate('explore');
  String get footprintsReward => translate('footprints_reward');
  String get localStores => translate('local_stores');
  String get specialOffer => translate('special_offer');
  String get unlockRewards => translate('unlock_rewards');
  String get lateArrivalsPolicy => translate('late_arrivals_policy');
  String get cancellationUpTo1Hour => translate('cancellation_up_to_1_hour');
  String get lateCancellationsNoOffers =>
      translate('late_cancellations_no_offers');
  String get servicePricesVary => translate('service_prices_vary');
  String get update => translate('update');
  String get add => translate('add');
  String get validTill => translate('valid_till');
  String get media => translate('media');
  String get aboutMe => translate('about_me');
  String get edit => translate('edit');
  String get max => translate('max');

  // Appointment Request Screen
  String get appointmentRequest => translate('appointment_request');
  String get searchRequest => translate('search_request');
  String get noRequestsFound => translate('no_requests_found');
  String get reject => translate('reject');
  String get approve => translate('approve');
  String get rejectAppointment => translate('reject_appointment');
  String get rejectReasonPrompt => translate('reject_reason_prompt');
  String get reason => translate('reason');
  String get error => translate('error');
  String get enterReason => translate('enter_reason');
  String get success => translate('success');
  String get appointmentUpdated => translate('appointment_updated');
  String get failedUpdateStatus => translate('failed_update_status');
  String get confirmed => translate('confirmed');
  String get callAction => translate('call_action');
  String get chatAction => translate('chat_action');
  String get paid => translate('paid');
  String get unknown => translate('unknown');
  String get markAsCompleted => translate('mark_as_completed');
  String get rebookAppointment => translate('rebook_appointment');
  String get appointmentMarkedCompleted => translate('appointment_marked_completed');
  String get rebookingComingSoon => translate('rebooking_coming_soon');
  String get create => translate('create');
  String get offertype => translate('offertype');
  String get chooseoffer => translate('chooseoffer');
  String get offertitle => translate('offertitle');
  String get entertitle => translate('entertitle');
  String get description => translate('description');
  String get offerdescription => translate('offerdescription');
  String get termsconditions => translate('termsconditions');
  String get entertermsconditions => translate('entertermsconditions');
  String get offerimage => translate('offerimage');
  String get rewardamount => translate('rewardamount');
  String get amount => translate('amount');
  String get validfrom => translate('validfrom');
  String get validto => translate('validto');
  String get uploadimage => translate('uploadimage');
  String get active => translate('active');
  String get selectdate => translate('selectdate');
  String get createoffer => translate('createoffer');
  String get checkservices => translate('checkservices');
  String get appointmentDetails => translate('appointment_details');
  String get noDataFound => translate('no_data_found');
  String get serviceDetails => translate('service_details');
  String get timeSlot => translate('time_slot');
  String get internalNote => translate('internal_note');
  String get appointmentTimeline => translate('appointment_timeline');
  String get bookingReceived => translate('booking_received');
  String get automatedSystem => translate('automated_system');
  String get bookingConfirmed => translate('booking_confirmed');
  String get waitingForCheckIn => translate('waiting_for_check_in');
  String get checkInCustomer => translate('check_in_customer');
  String get current => translate('current');
  String get totalAmount => translate('total_amount');
  String get payAtStoreLabel => translate('pay_at_store_label');
  String get visitingForFirstTime => translate('visiting_for_first_time');
  String get createNewOffer => translate('create_new_offer');
  String get addOfferBannerImage => translate('add_offer_banner_image');
  String get uploadMedia => translate('upload_media');
  String get offerBasics => translate('offer_basics');
  String get offerTitle => translate('offer_title');
  String get shortDescription => translate('short_description');
  String get offerType => translate('offer_type');
  String get discountConfiguration => translate('discount_configuration');
  String get discountPercentage => translate('discount_percentage');
  String get maxLimit => translate('max_limit');
  String get applicability => translate('applicability');
  String get addServiceAction => translate('add_service_action');
  String get staffSelectionOptional => translate('staff_selection_optional');
  String get allStaff => translate('all_staff');
  String get firstTimeCustomersOnly => translate('first_time_customers_only');
  String get validity => translate('validity');
  String get startDate => translate('start_date');
  String get endDate => translate('end_date');
  String get timeRestrictionsNote => translate('time_restrictions_note');
  String get termsUsage => translate('terms_usage');
  String get saveAsDraft => translate('save_as_draft');
  String get reviewOffer => translate('review_offer');
  String get offerSummary => translate('offer_summary');
  String get financialPreview => translate('financial_preview');
  String get originalPriceAvg => translate('original_price_avg');
  String get newFinalPrice => translate('new_final_price');
  String get minOrderValue => translate('min_order_value');
  String get systemValidation => translate('system_validation');
  String get noOverlappingOffers => translate('no_overlapping_offers');
  String get validDateRange => translate('valid_date_range');
  String get discountWithinRange => translate('discount_within_range');
  String get verified => translate('verified');
  String get editOffer => translate('edit_offer');
  String get proceedToPublish => translate('proceed_to_publish');
  String get confirmGoLive => translate('confirm_go_live');
  String get confirmationSummary => translate('confirmation_summary');
  String get riskNotice => translate('risk_notice');
  String get activationOption => translate('activation_option');
  String get activateNow => translate('activate_now');
  String get scheduleForLater => translate('schedule_for_later');
  String get authorizePublishCheckbox =>
      translate('authorize_publish_checkbox');
  String get publishOffer => translate('publish_offer');
  String get offerPublishedSuccessfully =>
      translate('offer_published_successfully');
  String get goToDashboard => translate('go_to_dashboard');
  String get createStep => translate('create_step');
  String get reviewStep => translate('review_step');
  String get confirmStep => translate('confirm_step');
  String get untitledOffer => translate('untitled_offer');
  String get activeSoon => translate('active_soon');
  String get allServices => translate('all_services');
  String get reviewNote => translate('review_note');
  String get draft => translate('draft');
  String get includedServices => translate('included_services');
  String get riskNoticeDesc => translate('risk_notice_desc');
  String get learnMorePublishing => translate('learn_more_publishing');
  String get activateNowDesc => translate('activate_now_desc');
  String get scheduleForLaterDesc => translate('schedule_for_later_desc');
  String get campaignSummary => translate('campaign_summary');
  String get activeUntil => translate('active_until');
  String get live => translate('live');
  String get offerDetails => translate('offer_details');
  String get retry => translate('retry');
  String get inactive => translate('inactive');
  String get businessInformation => translate('business_information');
  String get offerTypeDetails => translate('offer_type_details');
  String get category => translate('category');
  String get validityAndTerms => translate('validity_and_terms');
  String get termsAndConditions => translate('terms_and_conditions');
  String get noDescriptionProvidedMsg => translate('no_description_provided_msg');
  String get standardTermsAndConditionsApply => translate('standard_terms_and_conditions_apply');
  String get reward => translate('reward');
  String get typeLabel => translate('type_label');
  String get eligible => translate('eligible');
  String get youreEligible => translate('youre_eligible');
  String get withinRequiredRadius => translate('within_required_radius');
  String get yourDistance => translate('your_distance');
  String get requiredRadiusLabel => translate('required_radius_label');
  String get participatingIn => translate('participating_in');
  String get confirmCheckIn => translate('confirm_check_in');
  String get presentConfirmMsg => translate('present_confirm_msg');
  String get outOfRange => translate('out_of_range');
  String get youreTooFar => translate('youre_too_far');
  String get moveCloserTo => translate('move_closer_to');
  String get outsideRangeMsg => translate('outside_range_msg');
  String get view => translate('view');
  String get refreshMyLocation => translate('refresh_my_location');
  String get checkInToParticipate => translate('check_in_to_participate');
  String get verifying => translate('verifying');
  String get verifyingLocation => translate('verifying_location');
  String get takeFewSeconds => translate('take_few_seconds');
  String get cancelCheckIn => translate('cancel_check_in');
  String get aboutThisFootprint => translate('about_this_footprint');
  String get footprintEnds => translate('footprint_ends');
  String get eligibilityRules => translate('eligibility_rules');
  String get physicalPresentRule => translate('physical_present_rule');
  String get maxCheckInRule => translate('max_check_in_rule');
  String get oneCheckInPer24hRule => translate('one_check_in_per_24h_rule');
  String get mobileOtpRule => translate('mobile_otp_rule');
  String get activeCampaignsNearYou => translate('active_campaigns_near_you');
  String get winners => translate('winners');
  String get viewDetailsSimple => translate('view_details_simple');
  String get checkInSimple => translate('check_in_simple');
  String get endsIn => translate('ends_in');
  String get footprintRewardLabel => translate('footprint_reward_label');
  String get participants => translate('participants');
  String get perUser => translate('per_user');
  String get maxEntries => translate('max_entries');
  String get locationAndCheckIn => translate('location_and_check_in');
  String get distanceFromYou => translate('distance_from_you');
  String get requiredCheckInRadius => translate('required_check_in_radius');
  String get within => translate('within');
  String get ofStore => translate('of_store');
  String get storeAddress => translate('store_address');
  String get getDirectionSimple => translate('get_direction_simple');
  String get manageMedia => translate('manage_media');
  String get uploadOptions => translate('upload_options');
  String get camera => translate('camera');
  String get gallery => translate('gallery');
  String get addImage => translate('add_image');
  String get noMediaUploaded => translate('no_media_uploaded');
  String get updateCoverImage => translate('update_cover_image');
  String get generalInformation => translate('general_information');
  String get businessEmailLabel => translate('business_email');
  String get discardChanges => translate('discard_changes');
  String get updateProfile => translate('update_profile');
  String get businessProfile => translate('business_profile');
  String get username => translate('username');
  String get usernameHint => translate('username_hint');
  String get describeBusinessHint => translate('describe_business_hint');
  String get contactDetail => translate('contact_detail');
  String get editWorkingHours => translate('edit_working_hours');
  String get weeklySchedule => translate('weekly_schedule');
  String get setAvailabilityDesc => translate('set_availability_desc');
  String get applyToAllDays => translate('apply_to_all_days');
  String get adjustForHolidaysDesc => translate('adjust_for_holidays_desc');
  String get saveSchedule => translate('save_schedule');
  String get discard => translate('discard');
  String get manageOfferingsSubtitle => translate('manage_offerings_subtitle');
  String get statsOverview => translate('stats_overview');
  String get totalServices => translate('total_services');
  String get activeServicesCount => translate('active_services');
  String get averagePriceLabel => translate('average_price');
  String get addNewServiceLabel => translate('add_new_service');
  String get deleteServiceConfirm => translate('delete_service_confirm');
  String get deleteServiceTitle => translate('delete_service_title');
  String get enterShortDescription => translate('enter_short_description');
  String get searchServicesHint => translate('search_services_hint');
  String get serviceNameLabel => translate('service_name_label');
  String get enterServiceName => translate('enter_service_name');
  String get durationLabel => translate('duration_label');
  String get editPriceLabel => translate('edit_price_label');
  String get priceLabel => translate('price_label');
  String get deleteLabel => translate('delete_label');
  String get topServiceLabel => translate('top_service_label');
  String get createServiceLabel => translate('create_service_label');

  // Custom getters I added for Auth
  String get enterCredentials => translate('enter_credentials');
  String get useOtpInstead => translate('use_otp_instead');
  String get rememberDevice => translate('remember_device');
  String get enterAtelier => translate('enter_atelier');
  String get newToSuite => translate('new_to_suite');
  String get joinAsPartner => translate('join_as_partner');

  // ── Home Screen ──
  String get hello => translate('hello');
  String get activeOrdersSubtitle => translate('active_orders_subtitle');
  String get aiInsights => translate('ai_insights');
  String get aiInsightsDelayed => translate('ai_insights_delayed');
  String get aiInsightsSuggestion => translate('ai_insights_suggestion');
  String get viewDelayedOrders => translate('view_delayed_orders');
  String get dismissText => translate('dismiss');
  String get createOrder => translate('create_order');
  String get customerLabel => translate('customer_label');
  String get totalOrders => translate('total_orders');
  String get pendingLabel => translate('pending_label');
  String get deliveredLabel => translate('delivered');
  String get collectedLabel => translate('collected');
  String get thisMonth => translate('this_month');
  String get recentBoutiqueActivity => translate('recent_boutique_activity');
  String get seeAll => translate('see_all');
  String get noRecentActivity => translate('no_recent_activity');
  String get financialOverview => translate('financial_overview');
  String get monthlyTarget => translate('monthly_target');
  String get achievedLabel => translate('achieved');
  String get remainingLabel => translate('remaining');
  String get inProgressLabel => translate('in_progress');

  // ── Add Customer Screen ──
  String get addCustomer => translate('add_customer');
  String get save => translate('save');
  String get contactDetails => translate('contact_details');
  String get fullName => translate('full_name');
  String get fullNameHint => translate('full_name_hint');
  String get pleaseEnterFullName => translate('please_enter_full_name');
  String get phoneNumberLabel => translate('phone_number_label');
  String get enter10DigitNumber => translate('enter_10_digit_number');
  String get emailAddressLabel => translate('email_address_label');
  String get emailHint => translate('email_hint');
  String get saveCustomer => translate('save_customer');
  String get customerAddedSuccessfully => translate('customer_added_successfully');
  String get errorPrefix => translate('error_prefix');

  // ── Confirm Customer Bottom Sheet ──
  String get reviewClientProfile => translate('review_client_profile');
  String get confirmNewCustomer => translate('confirm_new_customer');
  String get verifyProfileDetails => translate('verify_profile_details');
  String get contact => translate('contact');
  String get fullNameLabel => translate('full_name_label');
  String get phoneLabel => translate('phone_label');
  String get emailLabel => translate('email_label');
  String get preferences => translate('preferences');
  String get priorityLabel => translate('priority');
  String get urgentLabel => translate('urgent');
  String get standardLabel => translate('standard');
  String get fitStyle => translate('fit_style');
  String get fabricClass => translate('fabric_class');
  String get super150sWool => translate('super_150s_wool');
  String get internalNotes => translate('internal_notes');
  String get editDetails => translate('edit_details');
  String get cancelButton => translate('cancel_button');
  String get confirmProfile => translate('confirm_profile');

  // ── Customers Screen ──
  String get customersTitle => translate('customers_title');
  String get manageBespokeClients => translate('manage_bespoke_clients');
  String get searchClientsHint => translate('search_clients_hint');
  String get noMoreCustomers => translate('no_more_customers');
  String get billPrefix => translate('bill_prefix');
  String get statusLabel => translate('status_label');
  String get noEmailProvided => translate('no_email_provided');
  String get viewProfile => translate('view_profile');
  String get billNoLabel => translate('bill_no_label');
  String get generateAiStyleProfile => translate('generate_ai_style_profile');

  // ── Staff Management Screen ──
  String get staffManagement => translate('staff_management');
  String get staffManagementDesc => translate('staff_management_desc');
  String get addStaff => translate('add_staff');
  String get activeUpper => translate('active_upper');
  String get totalArtisans => translate('total_artisans');
  String get currentWorkload => translate('current_workload');
  String get ordersText => translate('orders');
  String get efficiencyRate => translate('efficiency_rate');
  String get staffArtisanUpper => translate('staff_artisan_upper');
  String get assignedOrders => translate('assigned_orders');
  String get overCapacity => translate('over_capacity');
  String get capacityLabel => translate('capacity_label');
  String get onboardNewArtisan => translate('onboard_new_artisan');

  // ── Orders Management Screen ──
  String get productionLabel => translate('production_label');
  String get ordersTitle => translate('orders_title');
  String get searchCustomerOrId => translate('search_customer_or_id');
  String get noOrdersFound => translate('no_orders_found');
  String get createdBy => translate('created_by');
  String get invPrefix => translate('inv_prefix');
  String get totalCountLabel => translate('total_count_label');

  // ── Add Staff Screen ──
  String get addStaffTitle => translate('add_staff_title');
  String get basicInformation => translate('basic_information');
  String get fullNameRequired => translate('full_name_required');
  String get phoneNumberRequired => translate('phone_number_required');
  String get emailOptional => translate('email_optional');
  String get designationRequired => translate('designation_required');
  String get egJohnDoe => translate('eg_john_doe');
  String get egSeniorStylist => translate('eg_senior_stylist');
  String get phoneMustBe10Digits => translate('phone_must_be_10_digits');
  String get pleaseEnterValidEmail => translate('please_enter_valid_email');
  String get pleaseFillRequiredFields => translate('please_fill_required_fields');
  String get staffInvitedSuccessfully => translate('staff_invited_successfully');
  String get inviteStaff => translate('invite_staff');

  // ── Gallery Screen ──
  String get galleryCuratedPortfolio => translate('gallery_curated_portfolio');
  String get galleryArchiveOfExcellence => translate('gallery_archive_of_excellence');
  String get galleryAddPortfolioItem => translate('gallery_add_portfolio_item');
  String get galleryTapToUploadPhoto => translate('gallery_tap_to_upload_photo');
  String get galleryItemTitle => translate('gallery_item_title');
  String get galleryEgTitle => translate('gallery_eg_title');
  String get galleryMaterialSubtitle => translate('gallery_material_subtitle');
  String get galleryEgSubtitle => translate('gallery_eg_subtitle');
  String get galleryAddToArchive => translate('gallery_add_to_archive');
  String get galleryFilterAllWorks => translate('gallery_filter_all_works');
  String get galleryFilterSuits => translate('gallery_filter_suits');
  String get galleryFilterCasual => translate('gallery_filter_casual');
  String get galleryFilterFabrics => translate('gallery_filter_fabrics');
  String get galleryFilterFittings => translate('gallery_filter_fittings');

  // ── Staff Hello Screen ──
  String get staffPortalTitle => translate('staff_portal_title');
  String get queueOverview => translate('queue_overview');
  String get activeTasksFor => translate('active_tasks_for');
  String get searchOrdersHint => translate('search_orders_hint');
  String get totalTasksLabel => translate('total_tasks_label');
  String get inProgressUpper => translate('in_progress_upper');
  String get highPriorityUpper => translate('high_priority_upper');
  String get completedUpper => translate('completed_upper');
  String get noTasksInQueue => translate('no_tasks_in_queue');
  String get tasksTab => translate('tasks_tab');
  String get ordersTab => translate('orders_tab');
  String get logOut => translate('log_out');
  String get aiEfficiencySuggest => translate('ai_efficiency_suggest');
  String get batchCuttingRecommendation => translate('batch_cutting_recommendation');
  String get optimizeWorkflow => translate('optimize_workflow');
  String get fabricAvailability => translate('fabric_availability');
  String get navySilk => translate('navy_silk');
  String get inStockUpper => translate('in_stock_upper');
  String get tweedHarris => translate('tweed_harris');
  String get lowStockUpper => translate('low_stock_upper');
  String get clientLabel => translate('client_label');
  String get dueLabel => translate('due_label');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['mr', 'en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
