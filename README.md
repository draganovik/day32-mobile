
# Day32 - Events and Calendar

Day32 is a calendar Flutter client, with line sync with Google Calendar and public events hosted on Google Firebase.

<img src="https://user-images.githubusercontent.com/15861333/150196348-6269d62b-1c86-4d87-89cd-5c259c2292e2.png" width="200">


## License

[GPL-3.0](https://github.com/draganovik/Day32/blob/25a9e21f6ba9ccc0b6b5e8db338188cc88847ed2/LICENSE)


## Features

- Light/dark adaptive mode
- Preview, edit and remove Google Calendar events
- Publish events to public list for other to join
- Cross platform solution


## Screenshots

| Login Screen  | My events | Explore (public events) |
| ------------- | ------------- | ------------- |
| ![IMG_2512](https://user-images.githubusercontent.com/15861333/150196728-2bc65650-375e-4baf-9b85-f04a367630cd.PNG) | ![IMG_2513](https://user-images.githubusercontent.com/15861333/150196712-d1e9ca0c-8106-41f2-b7dd-dbb530cdd575.PNG)  | ![IMG_B9595ACEE171-1](https://user-images.githubusercontent.com/15861333/150196621-fa5b3247-45ed-432e-a852-8172823c0273.jpeg) |


## Tech Stack

**Client:**

- Flutter
    - intl
    - provider
    - shared_preferences
    - date_time_picker
    - syncfusion_flutter_calendar
    - Google Auth packages
        - googleapis
        - googleapis_auth
        - google_sign_in
        - extension_google_sign_in_as_googleapis_auth
    - FlutterFire packages
        - firebase_auth
        - firebase_core
        - firebase_database

**Server:**

- Google Calendar API,
- Google Firebase
    - Firebase Realtime Database
    - Firebase Google Authentication


## Run Locally

Clone the project

```bash
  git clone https://github.com/draganovik/day32.git
```

Go to the project directory

```bash
  cd day32
  cd dev-flutter
```

Install dependencies

```bash
  flutter pub get
```

Start the appliaction

```bash
  flutter run
```


## FAQ

#### How do I set up Google Auth in my app

Please follow https://firebase.flutter.dev/docs/overview/

#### How do I use [package name]

Search the package name on https://pub.dev


## Authors

- Mladen Draganović [[@draganovik]](https://www.github.com/draganovik)


## Acknowledgements

 - [Awesome Readme Templates](https://awesomeopensource.com/project/elangosundar/awesome-README-templates)
 - [Awesome README](https://github.com/matiassingers/awesome-readme)
 - [How to write a Good readme](https://bulldogjob.com/news/449-how-to-write-a-good-readme-for-your-github-project)

