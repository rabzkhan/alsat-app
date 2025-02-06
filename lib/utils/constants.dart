class Constants {
  static const baseUrl = 'https://alsat-api.flutterrwave.pro/app/v1';
  static const token1 =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3YWQ2NDEzYS1jYzkxLTRiODEtODcxNy00Y2UxMzdkZDNjYjEiLCJhdWQiOiJtb2JpbGUiLCJpc3MiOiJBbHNhdCBBUEkiLCJzdWIiOiI0YjJkYzZjNi1hZjU4LTQ5YzMtYjdjYi1lNWVmNGYwYjIyMjMiLCJleHAiOjE3Mzk0NDQ4MTIsImlhdCI6MTczODE0ODgxMiwibmJmIjoxNzM4MTQ4ODExLCJhdXRoZW50aWNhdGVkIjp0cnVlLCJ0d29fZmFfYXV0aGVudGljYXRlZCI6ZmFsc2V9.y0hSFMvgUT5tiV6yOGqA4tYj_efsP2MrnmxDZpNes1xqMZV4lYzpOtO7beczLvSKPmAZ-t2GhDKnDu6l80FFlIQyZ8m7ENec6cuGsC-PeU8VapV2bV7jS-WoMgm0bxeyqXDDRgJA6xLs0E2fDXcZUIot9pv_OtDgANEkcUSmjA3ebcUSADoXllx0wGj2qPyT3UzFU56VJGlqxU_chJFHbGKQhMF_HUiEJo6rHKmw-878yq8sgY2ybd1U9v1eh_py3fgZ9wrljHXjAA_kZRTW-FCpMG79lFL1TcBUbYoGd_cb1W78gQj6PzEHWCV8TfSck_aqUxBIX3cG7QEFoV178w';
  static const token = 'Bearer $token1';
  static const filter = '/posts';

  static const getOtp = '/otp';
  static const varifyOtp = '/join';

  static const userProfile = '/users/profile';
  static const userConversationList = '/chats';
  static const conversationMessages = '/messages';
  static const postProduct = '/posts';
  static const categories = '/categories';
  static const stories = '/stories';
  static const banners = '/banners';
  static const user = '/users';
  static const fcmStore = '/users/device';
  static const follower = '/users/followers';
  static const following = '/users/following';
  static const carBrandEndPoint = '/carBrands?limit=200000';
  static const upgradeToPremium = '/users/upgrade';
  static const updateProfilePicture =
      '/users/picture?file_name=télécharger.jpg&content_type=image/jpg';
}
