# flutter_challenge

Flutter News challenge to do a news app using newsapi.org

The app works both on android and iphone.

### Android app video demo
https://github.com/ivofernandes/flutterNewsChallenge/blob/develop/flutter_news_challenge/screenshots/flutterNewsVideo.mp4?raw=true

### IOS_NewsScreen
![IOS_NewsScreen.png](https://github.com/ivofernandes/flutterNewsChallenge/blob/develop/flutter_news_challenge/screenshots/IOS_NewsScreen.png?raw=true)

### IOS_FavoritesScreen
![IOS_FavoritesScreen](https://github.com/ivofernandes/flutterNewsChallenge/blob/develop/flutter_news_challenge/screenshots/IOS_FavoritesScreen.png?raw=true)

### IOS_NewsScreen
![IOS_NewsScreen](https://github.com/ivofernandes/flutterNewsChallenge/blob/develop/flutter_news_challenge/screenshots/IOS_SettingsScreen.png?raw=true)

### IOS_ArticleWebView
![IOS_ArticleWebView.png](https://github.com/ivofernandes/flutterNewsChallenge/blob/develop/flutter_news_challenge/screenshots/IOS_ArticleWebView.png?raw=true)


## Challenge Details

### Assignment
This is a simple exercise to test your skills in Android SDK and Kotlin, using Android Studio IDE. Before setting up the project, read through the whole exercise.
After completion, commit your solution to a public Git repository on Github, Gitlab or Bitbucket, and provide the repository URL. If you prefer, you can push it to a private Git repository, and give read permission to user tornelas (Tiago Ornelas) on any of the
aforementioned services.
### Setup
Using Android Studio, start a new project and name it AndroidChallenge, fill in the company domain then move to the next step. On Target Android Devices, select only Phone and Tablet, and target minimum API 23: Android 6.0.0. Feel free to do any other change in the
project that you see fit, to better organize it and avoid duplicated code. Also, try to use Design Patterns and inline comments where you feel it makes sense.
Worry only about supporting the english language. Also, worry only about supporting phone layouts, ignore tablets.
The app colors/theme is not the most important detail about this test. However, the color scheme should be pleasant and consistent
The app consists on 3 main screens
All of these 3 screens should support portrait and landscape orientation. The application should support both light and dark modes.
### Home/News screen
This screen lists the latest headlines available on the user language. It's a vertical scrollable list containing the articles fetched from the API. See API reference bellow. Consult screenshots for layout reference.
When on portrait mode, the list should display one column only, when on landscape, 2 columns. (See screenshots)
The articles fetched should be in the language of the user's device(Check API reference).
By clicking on an article, the user is take to the Article Details Screen
Display an image placeholder while the real image is not loaded or if there's no image to load (Check screenshots)
### Article Details screen
On this screen, the user can consult more detailed information about the news article. Also, he can share the article or open it on the browser (the 2 action buttons on the top bar). Consult screenshots for layout reference.
Settings screen
Composed by 3 components: 
1. Static text saying "Android app admission test, provided by frontkom.com" 
2. Ability to change the app theme (between system default, light and dark themes) Note: The selected theme should be persisted between sessions i.e., if the
user selects light theme, then closes the app and opens it again, the app should be in light mode, even if the phone is in dark mode. 
3. A label that fetches the app version and displays it
### API reference
This app only requires one API request to get the content to be presented on the home screen. This app uses the free News API v2
Base URL: https://newsapi.org/v2
Endpoint: /top-headlines
Query parameters:
language : String
apiKey : String, use e9f236f020e5427aa5f6b1ff104e955e
pageSize : Int, use 100
Screenshots
Check here
For extra reference, you can also download the apk and check it for yourself
### Extras
Feel free to implement any other extra features you want to. Here are some suggestions:
. Improve offline storage, to display articles even when there is no internet connection . Display error messages when content is not available 
. Create the ability to add/remove articles to a favourites list (by clicking on a favourite button in the article list item)
. Create a new screen to display articles the user has added/removed to the favourites 
. Pagination on the home screen 



## How to run the project

1- Import the dependencies

    flutter pub get
    
2- Run the project in android or iphone


## How to make this project work on web
During the implementation noticed that the image widget doesn't support web
https://pub.dev/packages/cached_network_image

So for make it work on web the list articles, probably would need a kIsWeb conditional to use another image widget on web
https://github.com/ivofernandes/flutterNewsChallenge/blob/main/flutter_news_challenge/lib/components/article/articleSnapshot.dart
