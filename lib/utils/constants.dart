class Constants {
  static const baseUrl = 'https://alsat-api.flutterrwave.pro/app/v1';
  static const token1 =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzYTUzNGFkNS0zYWZmLTQ0ZGItYTAxYy0yMmNkZTM4OGVjYjYiLCJhdWQiOiJtb2JpbGUiLCJpc3MiOiJBbHNhdCBBUEkiLCJzdWIiOiI0YjJkYzZjNi1hZjU4LTQ5YzMtYjdjYi1lNWVmNGYwYjIyMjMiLCJleHAiOjE3NDAxMzA2ODAsImlhdCI6MTczODgzNDY4MCwibmJmIjoxNzM4ODM0Njc5LCJhdXRoZW50aWNhdGVkIjp0cnVlLCJ0d29fZmFfYXV0aGVudGljYXRlZCI6ZmFsc2V9.WzGrXixkHr9nnaUy2f_WGWmhyWRVB20dJyI7KftlPh65DmD7PKdBXaCbD-W8eZYKdKuhD8tuf5cuscwQd2GEQBulWVSn03KcOgUjI2w3dOQ5hPE9wEObdv1m-1kyki_9rrAcvwnfp1AcOiWHWGo44TYr8xS2WUbpi8JzupsRC7PasMmUYh1bIjPRc-KbC5O2sbjRzv2oWn78msaGOFao6BJcjqds7k5uwoopRpCceDjlOvXcSniM-ZUvV7DFuNEZ50zyqtBQXVRuHPbWxGulJWGljxkPoK-XCh0Gvv8HLoCLK9a31nkFfyvpfX_i1753bhNgKw4ZnYdiOcNEGQSzqw';
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
