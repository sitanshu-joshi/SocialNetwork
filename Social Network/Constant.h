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

#define kBase_URL               @"http://54.148.97.236:8080/Troyage/ws/"
#define kDB_Store               @"troyage.sqlite"

/*
 Segue Identifier
 */

#define kPush_To_Question           @"pushToQuestion"
#define kPush_To_NewsFeed           @"pushToNewsFeed"
#define kPush_To_City               @"pushToCity"
#define kPush_To_Comment            @"pushToComment"
#define kPush_To_SlideBar           @"pushToSlideBar"
#define kPush_To_SlideBar1          @"pushToSlideBar1"


/*
 Resource Path
 */

#define kResource_SignUp_Auth       @"signup/oauth"                             //POST
#define kResource_Login             @"login"                                    //POST
#define kLogout                     @"logout"
#define kAddCity                    @"city"                                     //POST
#define kWallPostOnUserCity         @"city/post/{cityId}"                       //POST
#define kGetPost                    @"city/post?page=%@"                        //GET
#define kUpdateWallPost             @"usercity/wall/post/{postId}"              //PUT
#define kDeleteWallPost             @"city/post/{postId}"                       //DELETE
#define kLikePost                   @"city/post/{postId}/like"                  //POST
#define kUnLikePost                 @"city/post/{postId}/unlike"                //POST
#define kGetLikeCount               @"city/post/{postId}/like"                  //GET
#define kAddComment                 @"city/post/{postId}/comment"               //POST
#define kUpdateComment              @"city/post/{postId}/comment/{commentId}"   //PUT
#define kDeleteComment              @"city/post/{postId}/comment/{commentId}"   //DELETE
#define kGetCommentsByPostId        @"city/post/{postId}/comment"               //GET


/*
 Auth Type
 */
#define kAuth_FB            0

/*
 Auth Param
 */
#define kLogin_User_Email       @"Login_Email"
#define kLogin_User_Password    @"Login_Password"
#define kIs_User_Logged_In      @"isUserLoggedIn"
/*
 Auth Login/SignUp
 */
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

/*
 Get Post
 */
#define kNumberOfPages      @"page"

/*
 Wall post on user city / Update wall post
 */
#define kPost_Text      @"POST_TEXT"

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

#endif
