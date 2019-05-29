# TMDB Upcoming
## What?
A TMDB Upcoming Movie List with search field and movie details!
## How it works?
User can see the list of the upcoming movies in TMDb API. Also, the user can search within the movie list byu the title of the movie. And after this, see the movie details.

## How to run:
1. You can [clone](https://help.github.com/en/articles/cloning-a-repository) or [download](https://stackoverflow.com/questions/6466945/fastest-way-to-download-a-github-project) the repository
2. [Install CocoaPods on your machine](https://guides.cocoapods.org/using/getting-started.html) (Just if you don't have it yet)
3. Run `pod install` in the project folder
4. Open tmdbupcmonig.xcworkspace
5. Hit the "Run" button, or "Command + B" on keyboard.

## Detailed explanation
#### There are two screens on the project:
1. **Home screen:** Here the user see the movies list and can search by movie title.
2. **Detail screen:** Here the user see the movie detail, according to wich movie was selected in the Home Screen

## Libraries used
1. [MaterialComponents](https://github.com/material-components/material-components-ios)
     - For Cards layout on movies list.
2. [Alamofire](https://github.com/Alamofire/Alamofire)
     - For web requests. In this case, for request movies and genres.
3. [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
     - For async load movies images.
4. [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)
     - For map request results.
