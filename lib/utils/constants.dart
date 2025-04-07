import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:get/get.dart';

class Constants {
  static const baseUrl = 'https://alsat-api.flutterrwave.pro/app/v1';
  static const token1 =
      "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIwNGYwYWQ4MC0wMDkyLTQ4YjAtYjY3MS1jMzI5ZmEzYWEzOGYiLCJhdWQiOiJtb2JpbGUiLCJpc3MiOiJBbHNhdCBBUEkiLCJzdWIiOiJkZGEwMTQxNS01ZWViLTQ3MTItYjk1Mi0wYTE0MTY4NmNjMjQiLCJleHAiOjE3NDUwNDIxMTUsImlhdCI6MTc0Mzc0NjExNSwibmJmIjoxNzQzNzQ2MTE0LCJhdXRoZW50aWNhdGVkIjp0cnVlLCJ0d29fZmFfYXV0aGVudGljYXRlZCI6ZmFsc2V9.AlcAbAFEJQszzpm_xyaVUm8h8Wm730mHaBoE0BatUWv7Z7adiAGy8iIfwgufSEadK-u9bLHuhtvnRsK3MYPUEh4LrHgeQ0-LHafMQ8KyQxClJK9pbiVw21OZqzKMIw9uY-eRk_h7uJ6bITDLaWvndPQ46rVOH1PuhfkqOvpRSseH_bW4F320A8_4JXAUEU8ehRjUfmqcdGnwksbrHbaRH6EQDP479xv8_UV6EOwYbui9nMnWwnHC9Hs7lhtCNACAffo582bUfZY-gmvxZjYhu96kqeihM_nkBsuXDfXREk5EzJhpIpjycXpCohb0VyXGQWglN5mKTMI9MngMaKjkaA";
  static const token2 =
      "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzNzA5OTMwMi0wYzZiLTQwZGYtODYzZC1lZDFlZmZiZDkzN2EiLCJhdWQiOiJtb2JpbGUiLCJpc3MiOiJBbHNhdCBBUEkiLCJzdWIiOiIwODRiMThiMS02ZGI5LTQ1NjQtYjViOS1jNjNmMjQ3YTY3ZDYiLCJleHAiOjE3NDQxNDM0NzMsImlhdCI6MTc0Mjg0NzQ3MywibmJmIjoxNzQyODQ3NDcyLCJhdXRoZW50aWNhdGVkIjp0cnVlLCJ0d29fZmFfYXV0aGVudGljYXRlZCI6ZmFsc2V9.jSzMylWg_larT6baVgxmsOMSstrkiSh_OBVPh5b1T3On_8HFnqL_LubWzpZhyV4C6boZKTVti-7om9QnqxCyGp0bgxAJTJj7woheyW2jOd2mhPWHDHIc-0oZS0mouNOLgy6EL0G_oXVwa5Nc_huzzMeNJRwa1nSmmjbXY7opDZ46f0AqNS63sUKTRVFL1o8vMOWw6c9bnPNExEBBnpBlILm3f6U6OiIkVSDGqlLzx4GJ178vTp42oqPdmRsJh1PeKSC4Iao8aTkbiVpV98LKBPWgCPh8yySLFu_-39VVIFe14EIkIsS3R-VamrmR0v3BMrod_ZMHd7x3E-_Olbq-Ug";
  static String token = 'Bearer ${token1}';
  static const filter = '/posts';

  static const getOtp = '/otp';
  static const varifyOtp = '/join';

  static const userProfile = '/users/profile';
  static const userConversationList = '/chats';
  static const conversationMessages = '/messages';
  static const postProduct = '/posts';
  static const categories = '/categories';
  static const stories = '/stories';
  static const storiesArchive = '/stories/archives';
  static const notification = '/notifications';
  static const banners = '/banners';
  static const user = '/users';
  static const fcmStore = '/users/device';
  static const follower = '/users/followers';
  static const following = '/users/following';
  static const carBrandEndPoint = '/carBrands?limit=200000';
  static const upgradeToPremium = '/users/upgrade';
  static const updateProfilePicture = '/users/picture?file_name=télécharger.jpg&content_type=image/jpg';
}
