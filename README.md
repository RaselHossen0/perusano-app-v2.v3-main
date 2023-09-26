# frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Mimimun Requirements and Installation:

We recommended follow the flutter tutorial from https://docs.flutter.dev/get-started/install. Select your own Operating System and follow the steps.

## Program Structure
The application has many folders, but we work in two main folders.

The first one is assets folder which contains files like images, languages files, documents, fonts, etc.

The second and probably most important is lib folder. It contains all pages that the application uses. Starting with main.dart, this is the first script to be executed.
Lib is subdivided into 4 folders:
- Components folders contains all components that will be repetitive used in the pages of the application.
- Pages folder contains all the pages that the application will use. Inside the pages are separated into other folders that represent the application modules, like Recipes, CRED, Calendar, etc.
- Services folders contains the apis that the app will use when it is connected to the network, the files which works with the local storage, the synchronization folder which contains the files to make de synchronization between local storage and network database, and finally contains file to control the notifications and the translate of the app.
- Util folder contains the class of all kind of data that the app uses, also contains a network controller and other usefull files like globals variables, headers to works with the apis, internal Variables and color of the app.

Another important file is pubspec.yaml which is where we declarate all new library that we will use in the app.

## Extra Notes
	- In globalVariables you can change the endpoint that the app will use to connect to the network.
	- In pages exist a HealthCenter folder which contains files that just the health personal will use to control the app, but is not implemented at the momento to write this Readme.
	- InternVariables exist to allow us get data that will be use in diferents files, in that way we avoid send the same data between diferents pages. 
