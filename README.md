# SenchaApp iOS

| Branch  |                                                                               Status                                                                               |
| :-----: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| main  |  |
| develop |  |

## Getting Started

- Use [git flow](http://www.atmarkit.co.jp/ait/articles/1311/18/news017.html).

### Prepare environment

1) Install Ruby using `rbenv`

   ```
   brew update
   brew install rbenv ruby-build
   echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
   source ~/.bash_profile
   ```

2) Run setup script

   ```
   make setup
   ```

3) Create your own Appfile under fastlane/ and fill `apple_id`

   ```
   cp fastlane/Appfile.template fastlane/Appfile
   emacs fastlane/Appfile
   ```

6) Use latest Xcode

## Deploy to the Firebase App Distribution

To deploy to the Firebase App Distribution, use `fastlane`.

    bundle exec fastlane beta

## Deploy to AppStore

To deploy to AppStore, use `fastlane`.

    bundle exec fastlane deploy
