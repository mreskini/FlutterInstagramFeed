class Post {
  String username;
  String profileImageUrl;
  String postImageUrl;
  int likesAmount;
  String captionText;
  int commentsAmount;
  String postTime;
  bool hasLikedPost;
  bool hasBookmarkedPost = false;
  double aspectRatio;
  Post({
    this.username,
    this.profileImageUrl,
    this.postImageUrl,
    this.likesAmount,
    this.captionText,
    this.commentsAmount,
    this.postTime,
    this.hasLikedPost,
    this.aspectRatio,
  });
}
