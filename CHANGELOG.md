## 0.3.7

* Add `BuildContext` in `appbarActions` in `PlexDashboardConfig`.

## 0.3.6

* Add `BuildContext` in `navigationRailTopWidgets` and `navigationRailBottomWidgets` in `PlexDashboardConfig`.

## 0.3.5

* Add `enableCopy` in `PlexTable` & `PlexDataTableWithPages` to enable and disable copy text from eny cell.

## 0.3.4

* Add `navigationRailBackgroundColor`, `navigationRailBottomWidgets`, `navigationRailTopWidgets`, `hideNavigationRailVersionInfo`, `hideNavigationRailLogo`, `hideNavigationRailLogoHeight`, `hideNavigationRailLogoWidth` in `PlexDashboardConfig`
* Update Multiselect selection layout (`PlexInputWidget.typeMultiSelect`) for `PlexInputWidget`. Add `Chips` in selection view.
* Set `basePath` for `PlexNetworking` is optional.

## 0.3.3

* Add User Image Caching In the Dashboard
* Add Download File in `PlexNetworking` You can download any file using function `downloadFile`

## 0.3.2

* Fix bug in `POST` call. If post body is empty the `API` didn't send the call to server
* Add more extensions to List, String and DateTime.
* Update Documentations

## 0.3.1

* Add colorful loader in the `PlexScreen.showLoading()`
* Make colorful loader available in public API. You can use it by `PlexLoader()` anywhere.


## 0.3.0

* Add `AboutDialog` when click on version name in dashboard screen `appbar` actions.
* You can show `AboutDialog` anywhere by calling `PlexApp.app.showAboutDialogue(context);`. 
* About dialog get information from `PlexAppInfo` which is initialized when we create `PlexApp`.
* Add `PlexUser.getPictureUrl()`. You can override this functions to return image `URL` to be diaplayed on dashboard instead it will display user's name initials as user icon.

## 0.2.9

* Add Optional Input Action and KeyboardType in `PlexForm`. Can be accessed by `PlexFormField.input(this.inputType, this.inputAction)`

## 0.2.8

* You can add more menu in the dashboard app bar by accessing and adding `MenuItemButton` in the `appbarActions` list in the `dashboardConfig` of application
* You can `Hide` and `Show` theme controls by accessing dashboard `showThemeSwitch`, `showBrightnessSwitch` and `showMaterialSwitch` controls
* Fix Bug: Stop Dashboard Screen `onBackPress` and show error `404`
* Decrease font size of `BottomNavigationBar` on dashboard
* Add `shortTile` in `PlexRoute`. So that `Plex` can use this text when there is shortage of space. If not available it will use `title` instead automatically
* On LoggedIn user thumbnail hover, user full name will be shown as tooltip 
* Add Platform OS function `getPlatformName()`

## 0.2.7

* Fix exception when show message and widget is expired or unmounted

## 0.2.6

* Add `copyToClipboard('Your Text', showCopiedInfo = true)` function. Second argument is optional

## 0.2.5

* Add `PlexDataTableWithPages` widget. With this widget you can display large amount of data. Usage is same as `PlexDataTable`

## 0.2.4

* Make Dashboard `NavigationRail` scrollable

## 0.2.3

* Navigate to other dashboard screen by using `PlexApp.app.dashboardConfig?.navigateOnDashboard(index: 0);`
* Make version not visible if not given. Previously displaying `null`

## 0.2.2

* Dropdown field show preselection highlighted
* Print button can be hide in `PlexDataTable` by using `enablePrint` just like `enableSearch`

## 0.2.1

* Move `appLogo`, `appLogoDark` and `initialRoute` to `PlexAppInfo`
* Add `SideNavigation` header

## 0.2.0

* More than `5` menu items will be clubbed in `Mobile-View` and when user can navigate there by click `More` button
* Add `UserIcons` on top right of dashboard screen with name. Name will be hidden on small screens.

## 0.1.9

* Add `enableSerach` control in `PlexDataTable` to hide and show the search controls
* Add `PlexAppInfo` in the `PlexApp`. Use `appInfo` instead `title` in the `PlexApp`
* Add version info in `PlexLoginScreen` and `PlexDashboardScreen` top right menu
* Add `debugUsername` and `debugPassword` field in `PlexLoginConfig`, so `username` and `password` field appears pre-filled in debug mode for testing only

## 0.1.8

* Add `onLogout` Callback in `PlexApp` for post logout operations i.e. deleting some data etc

## 0.1.7

* Add `columnSpacing` Style In `PlexDataTable`

## 0.1.6

* Fix Bug In `PlexWidget`
 
## 0.1.5

* Formatting Code
* Remove Redundant Imports

## 0.1.4

* Fix Bug

## 0.1.3

* Fix PlexNetworking Bugs

## 0.1.2

* Updates in UI and Improvements
* Add Networking in the Library

## 0.1.1

* Update UI and Improvements
* Update Documentations

## 0.1.0

* Updates in `PlexDataTable`
* Bug Fixes and Improvements in `UI`
* Update dependencies to the latest available

## 0.0.9

* Update `PlexInputWidget` properties
* Make `Plex` usable without using `PlexApp`

## 0.0.8

* Add more documentations
* Updates and minor bug fixes

## 0.0.7

* Add documentations
* Update packages to latest versions
* Add examples to the code
* Add licence

## 0.0.6

* Major updates on design and theming
* Added `Material-3` in app
* Add `Dark Mode` in the application
* And many bug improvements and updates

## 0.0.5

* Add `InputAction` in the `PlexInputWidget`. By default, it will go to next text field.

## 0.0.4

* Fix bug in `PlexDataPicker`, crashes app when clear date if it's not already selected

## 0.0.3

* Fix `itemAsString` and mark it as not required

## 0.0.2

* Add default implementation for item as string
* Add default parameter names for callback functions

## 0.0.1

* Initial Build