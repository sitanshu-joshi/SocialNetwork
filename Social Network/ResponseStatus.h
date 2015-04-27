//
//  ResponseStatus.h
//  Social Network
//
//  Created by Sagar Gondaliya on 4/15/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#ifndef Social_Network_ResponseStatus_h
#define Social_Network_ResponseStatus_h


#define kRequest_Forbidden_Unauthorized                    403

//REQUEST TIME OUT
#define kRequest_TimeOut                    1001
#define kRequest_Server_Not_Rechable        1004

//SUCCESS 200X
#define kSusscessully_Operation_Complete    2000
#define kSusscessully_Login                 2001
#define kSusscessully_logout                2002

//ALREADY EXIST 410X
#define kUSER_ALREADY_EXIST                 4100
#define kORGANIZATION_ALREADY_EXIST         4101
#define kROLE_ALREADY_EXIST                 4102

//NOT EXIST 404*
#define kDATA_NOT_EXIST                 4040
#define kORGANIZATION_NOT_EXIST         4041
#define kROLE_NOT_EXIST                 4042

//FAIL 50xx
#define kINTERNAL_SERVER_ERROR                 5000
#define kFAIL                                  5001
#define kLOGIN_FAILURE                         5002
#define kINVALID_USENAME_PASSWORD              5004

//VALIDATION RELATED 400X
#define kINVALID_REQUEST                       4000
#define kINVALID_SESSION                       4001
#define kNOT_ENOUGH_DATA_TO_PROCESS            4004

//ACCESS RELATED 403X
#define kPERMITON_DENIED                       4030

#endif
