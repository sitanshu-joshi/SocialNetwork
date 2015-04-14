//
//  Constant.h
//  Social Network
//
//  Created by Sitanshu Joshi on 7/26/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#ifndef Social_Network_Constant_h
#define Social_Network_Constant_h

#define KEYBOARD_HEIGHT 260

// App Title
#define kAppTitle               @"Troyage"
// Base URL
#define kBase_URL               @"http://52.11.4.241:8080/Troyage/ws/"
#define kBase_Place_URL         @"https://maps.googleapis.com/maps/api/place/textsearch/"

#define kDB_Store               @"troyage.sqlite"

#define kFBProfilePicURL        @"http://graph.facebook.com/%@/picture?type=large"

// Place API Key
#define kPlace_API_Key          @"AIzaSyCBSMStqX_2Rd0aSUCqHleFr-8arl0GTUY"

//Questions

#define Question1       @"Which cities will you want to visit ?"
#define Question2       @"Which cities did you visit ?"



/*
 Segue Identifier
 */

#define kPush_To_Question           @"pushToQuestion"
#define kPush_To_NewsFeed           @"pushToNewsFeed"
#define kPush_To_City               @"pushToCity"
#define kPush_To_Comment            @"pushToComment"
#define kPush_To_SlideBar           @"pushToSlideBar"
#define kPush_To_SlideBar1          @"pushToSlideBar1"
#define kPush_To_Setting            @"pushToSetting"
#define kPushToCityFromNews         @"pushToCityFromNews"
#define kPush_To_CommentFromNews    @"pushToCommentFromNews"

/*
 Resource Path
 */
#define kResource_SignUp_Auth       @"signup/oauth"                             //POST
#define kResource_Login             @"login"                                    //POST
#define kLogout                     @"logout"

#define kGetMyListOfCity            @"usercity/"                                 // GET
#define kGetListOfCity              @"city?page=%d"                             //GET
#define kGetCityId                  @"city?CITY_NAME=%@&STATE=%@&COUNTRY=%@"    //GET
#define kAddCity                    @"city"                                     //POST
#define kWallPostOnUserCity         @"city/post/%@"                             //POST
#define kGetPost                    @"city/post/%@?page=%d"                     //GET
#define kUpdateWallPost             @"usercity/post/%@"                    //PUT
#define kDeleteWallPost             @"city/post/%@"                             //DELETE
#define kResource_LikePost          @"city/post/%@/like"                        //POST
#define kResource_UnLikePost        @"city/post/%@/unlike"                      //POST
#define kGetLikeCount               @"city/post/%@/like"                        //GET
#define kAddComment                 @"city/post/%@/comment"                     //POST
#define kUpdateComment              @"city/post/%@/comment/%@"                  //PUT
#define kResource_DeleteComment     @"city/post/%@/comment/%@"                  //DELETE
#define kGetCommentsByPostId        @"city/post/%@/comment"                     //GET
// News
#define kResource_mycity_delete     @"usercity/%@"              //Delete
#define kResource_GetNewsFeed       @"usercity/post?page=%d"    //GET
#define kResource_NF_count          @"notification/count"
#define kResource_NF_List           @"notification?page=1"
#define kResource_NF_Read_Count     @"notification/count"

// Places
#define kResource_Place             @"json?query=%@&key=%@&types=locality"


/*
 Auth Type
 */
#define kAuth_FB            0

/*
 Facebook Response Parameters
 */
#define kUserLocation        @"location"
#define kLocationName        @"name"
#define kUserGender          @"gender"
#define kUserBirthDate       @"birthday"

//Response Code
#define kCode_Success               200
#define kInvaliduser                301
#define kCode_Error                 500

#define kUserNotAuthenticate        1012
#define kCode_Request_Time_Out          1001
#define kCode_Could_Not_Connect_Server  1004
#define kCode_NSURLErrorNotConnectedToInternet 1009

/*
 Auth Param
 */
#define kLogin_User_Email       @"Login_Email"
#define kLogin_User_Password    @"Login_Password"
#define kIs_User_Logged_In      @"isUserLoggedIn"


/*
 Auth Login/SignUp
 */
#define kUSER_ID            @"USER_ID"
#define kUSER_FIRST_NAME    @"USER_FIRST_NAME"
#define kUSER_LAST_NAME     @"USER_LAST_NAME"
#define kUSER_EMAIL         @"USER_EMAIL"
#define kUSER_NAME          @"USER_NAME"
#define kUSER_AUTH_TOKEN    @"USER_AUTH_TOKEN"
#define kUSER_TYPE          @"USER_TYPE"
#define kUSER_TIMEZONE      @"USER_TIMEZONE"
#define kUSER_BDAY          @"USER_BDAY"

/*
 Add City
 */

#define kCITY_NAME          @"CITY_NAME"
#define kSTATE              @"STATE"
#define kCOUNTRY            @"COUNTRY"
#define kDESCRIPTION        @"DESCRIPTION"
#define kIS_VISITED         @"IS_VISITED"
#define kWANTS_TO_VISIT     @"WANTS_TO_VISIT"

/*
 Get Post
 */
#define kNumberOfPages      @"page"

/*
 Wall post on user city / Update wall post
 */
#define kPost_Text      @"POST_TEXT"
#define kComment_Text   @"COMMENT_TEXT"
#define kMedia_Type     @"MEDIA_TYPE"
#define kFile           @"FILE"
#define kFileType       @"#Type"

/*
 Add comment / Update comment
 */
#define kCOMMENT_TEXT      @"COMMENT_TEXT"


/*
 NS Defauts
 */
#define kNotification_FB                      @"notification_fb"
#define kNotification_LoginSuccess            @"notification_LoginSuccess"
#define kNotification_QueAnsSuccess           @"notification_QueAnsSuccess"

/*
 UIAlertView/ActionSheet Button Title
 */
#define kOkButton       @"Ok"
#define kCancelButton   @"Cancel"
#define kYesButton      @"Yes"
#define kNoButton       @"No"
#define kTakeVideo      @"Take Video"
#define kTakePhoto      @"Take Photo"
#define kPhotoLibrary   @"Photo Library"
#define kVideoLibrary   @"Video Library"
#define kCamera         @"Camera"



//Activity Indicator Message
#define kActivityIndicatorMessage       @"Please wait"


//Alert
#define kAlert_NoInternet                   @"Internet connection is not found, please check your connection setting."
#define kAlert_Logout                       @"Are you want to logout ?"
#define kAlert_Enter_City                   @"Please Select City"
#define kCameraAlert                        @"Camera is not available"
#define kVideoLengthAlert                   @"Video length should be maximum of 20 Seconds.Please select another Video"
#define kAlert_FacebookConnectionProblem            @"Error while connecting Facebook, please check your internet connection."
#define kAlert_Facebook_Session_Closed              @"You have disallowed Facebook profile to providing access for your basic information. Please change your Facebook profile settings."


// City
#define  tagColorForCity        [UIColor colorWithRed:96.0/255.0 green:92.0/255.0 blue:168.0/255.0 alpha:1.0]


// Fonts
#define Font_Roboto_Header_Title  [UIFont fontWithName:@"Roboto-Bold" size:18.0]

#define Font_Roboto_Section_Title  [UIFont fontWithName:@"Roboto-Bold" size:16.0]

#define Font_Roboto_Light_13  [UIFont fontWithName:@"RobotoCondensed-Light" size:13.0]
#define Font_Roboto_Light_14  [UIFont fontWithName:@"RobotoCondensed-Light" size:14.0]
#define Font_Roboto_Light_15  [UIFont fontWithName:@"RobotoCondensed-Light" size:15.0]
#define Font_Roboto_Light_16  [UIFont fontWithName:@"RobotoCondensed-Light" size:16.0]
#define Font_Roboto_Light_17  [UIFont fontWithName:@"RobotoCondensed-Light" size:17.0]
#define Font_Roboto_Light_18  [UIFont fontWithName:@"RobotoCondensed-Light" size:18.0]
#define Font_Roboto_Light_19  [UIFont fontWithName:@"RobotoCondensed-Light" size:19.0]
#define Font_Roboto_Light_20  [UIFont fontWithName:@"RobotoCondensed-Light" size:20.0]
#define Font_Roboto_Light_21  [UIFont fontWithName:@"RobotoCondensed-Light" size:21.0]
#define Font_Roboto_Light_22  [UIFont fontWithName:@"RobotoCondensed-Light" size:22.0]

#define Font_Roboto_Condensed_11  [UIFont fontWithName:@"RobotoCondensed-Regular" size:11.0]
#define Font_Roboto_Condensed_13  [UIFont fontWithName:@"RobotoCondensed-Regular" size:13.0]
#define Font_Roboto_Condensed_14  [UIFont fontWithName:@"RobotoCondensed-Regular" size:14.0]
#define Font_Roboto_Condensed_15  [UIFont fontWithName:@"RobotoCondensed-Regular" size:15.0]
#define Font_Roboto_Condensed_16  [UIFont fontWithName:@"RobotoCondensed-Regular" size:16.0]
#define Font_Roboto_Condensed_17  [UIFont fontWithName:@"RobotoCondensed-Regular" size:17.0]
#define Font_Roboto_Condensed_18  [UIFont fontWithName:@"RobotoCondensed-Regular" size:18.0]
#define Font_Roboto_Condensed_19  [UIFont fontWithName:@"RobotoCondensed-Regular" size:19.0]
#define Font_Roboto_Condensed_20  [UIFont fontWithName:@"RobotoCondensed-Regular" size:20.0]
#define Font_Roboto_Condensed_21  [UIFont fontWithName:@"RobotoCondensed-Regular" size:21.0]
#define Font_Roboto_Condensed_22  [UIFont fontWithName:@"RobotoCondensed-Regular" size:22.0]

#define Font_Roboto_Regular_8  [UIFont fontWithName:@"Roboto-Regular" size:8.0]
#define Font_Roboto_Regular_10  [UIFont fontWithName:@"Roboto-Regular" size:8.0]
#define Font_Roboto_Regular_11  [UIFont fontWithName:@"Roboto-Regular" size:11.0]
#define Font_Roboto_Regular_12  [UIFont fontWithName:@"Roboto-Regular" size:12.0]
#define Font_Roboto_Regular_13  [UIFont fontWithName:@"Roboto-Regular" size:13.0]
#define Font_Roboto_Regular_14  [UIFont fontWithName:@"Roboto-Regular" size:14.0]
#define Font_Roboto_Regular_15  [UIFont fontWithName:@"Roboto-Regular" size:15.0]
#define Font_Roboto_Regular_16  [UIFont fontWithName:@"Roboto-Regular" size:16.0]
#define Font_Roboto_Regular_17  [UIFont fontWithName:@"Roboto-Regular" size:17.0]
#define Font_Roboto_Regular_18  [UIFont fontWithName:@"Roboto-Regular" size:18.0]
#define Font_Roboto_Regular_19  [UIFont fontWithName:@"Roboto-Regular" size:19.0]
#define Font_Roboto_Regular_20  [UIFont fontWithName:@"Roboto-Regular" size:20.0]
#define Font_Roboto_Regular_21  [UIFont fontWithName:@"Roboto-Regular" size:21.0]
#define Font_Roboto_Regular_22  [UIFont fontWithName:@"Roboto-Regular" size:22.0]

#define Font_Roboto_Bold_13  [UIFont fontWithName:@"Roboto-Bold" size:13.0]
#define Font_Roboto_Bold_14  [UIFont fontWithName:@"Roboto-Bold" size:14.0]
#define Font_Roboto_Bold_15  [UIFont fontWithName:@"Roboto-Bold" size:15.0]
#define Font_Roboto_Bold_16  [UIFont fontWithName:@"Roboto-Bold" size:16.0]
#define Font_Roboto_Bold_17  [UIFont fontWithName:@"Roboto-Bold" size:17.0]
#define Font_Roboto_Bold_18  [UIFont fontWithName:@"Roboto-Bold" size:18.0]
#define Font_Roboto_Bold_19  [UIFont fontWithName:@"Roboto-Bold" size:19.0]
#define Font_Roboto_Bold_20  [UIFont fontWithName:@"Roboto-Bold" size:20.0]

#define Font_Roboto_Condensed_Bold_11  [UIFont fontWithName:@"RobotoCondensed-Bold" size:11.0]
#define Font_Roboto_Condensed_Bold_13  [UIFont fontWithName:@"RobotoCondensed-Bold" size:13.0]
#define Font_Roboto_Condensed_Bold_14  [UIFont fontWithName:@"RobotoCondensed-Bold" size:14.0]
#define Font_Roboto_Condensed_Bold_15  [UIFont fontWithName:@"RobotoCondensed-Bold" size:15.0]
#define Font_Roboto_Condensed_Bold_16  [UIFont fontWithName:@"RobotoCondensed-Bold" size:16.0]
#define Font_Roboto_Condensed_Bold_17  [UIFont fontWithName:@"RobotoCondensed-Bold" size:17.0]
#define Font_Roboto_Condensed_Bold_18  [UIFont fontWithName:@"RobotoCondensed-Bold" size:18.0]
#define Font_Roboto_Condensed_Bold_19  [UIFont fontWithName:@"RobotoCondensed-Bold" size:19.0]
#define Font_Roboto_Condensed_Bold_20  [UIFont fontWithName:@"RobotoCondensed-Bold" size:20.0]
#define Font_Roboto_Condensed_Bold_22  [UIFont fontWithName:@"RobotoCondensed-Bold" size:22.0]
#define Font_Roboto_Condensed_Bold_30  [UIFont fontWithName:@"RobotoCondensed-Bold" size:30.0]

#endif
