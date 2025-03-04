class Constants {
  static const baseUrl = 'https://alsat-api.flutterrwave.pro/app/v1';
  static const token1 =
      "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4MDEzOGVhYS00MGQ4LTQ3ZDUtYmY5Ny03NDRkOGEzMmJhYWMiLCJhdWQiOiJtb2JpbGUiLCJpc3MiOiJBbHNhdCBBUEkiLCJzdWIiOiI0YjJkYzZjNi1hZjU4LTQ5YzMtYjdjYi1lNWVmNGYwYjIyMjMiLCJleHAiOjE3NDE3OTcxNjMsImlhdCI6MTc0MDUwMTE2MywibmJmIjoxNzQwNTAxMTYyLCJhdXRoZW50aWNhdGVkIjp0cnVlLCJ0d29fZmFfYXV0aGVudGljYXRlZCI6ZmFsc2V9.AlJazucj7VLtYKnwmcXd2HZW31ZeYSdlhUqhTyE8jminjEahJjkxKt766tks07qW77rBWi6alVU0xRkXk9VfNyN8dGC-NBjCrnlzVc4HFxAI1MtwL4iYano1ZwReLmhU4K5FX5VVFQ_ulZRRGIYtNe-VdrNGcuiEB3zToLWoWwyJjTk415lvcAs9-LsnyIEG3FKZLWvXea4HcA4CQmsgYRMS_R2HFU9d-m3eNv6_5YN1rW_c0tW5vZCtGQkbX_ROud1f8TLLyCNFv3ToJCIba-iN9b9IwtSSd-fiLtvL0mlm_HqAIReuuT4nyoptfneEIhUnia41867MprfhSWoYTQ";
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
  static const notification = '/notifications';
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
