## 0.5.2

### Fixes
* Fix the `PlexInputWidget` multiselection UI Bug

## 0.5.1

### Update
* To update UI from Form add `BuildContext` in `getFields(State<StatefulWidget>)` method of class `PlexForm` 

## 0.5.0

### Fixes
* Fix scroll in `PlexAdvanceDataTable`

## 0.4.9

### Fixes
* Update Remember User UI On Login Screen

## 0.4.8

### Updates
* Add remember user functionality in `Plex Login Screen`

### Fix
* Bug fix when calling `isNetworkAvailable()` utility function

## 0.4.7

### Updates
* Bug Fix in `PlexNetworking.isNetworkAvailable()`

## 0.4.6

### Feature
* Check network available or not `PlexNetworking.isNetworkAvailable()`

### Updates
* `PlexNetworking` will return No Network Error Before Sending API Call

## 0.4.5

### Updates
* Update Libraries and Dependencies

## 0.4.4

### New Feature
* Initial route can also be set by login user by overriding `getInitialPath()` in `UserModel` which is implementing `PlexUse` 

## 0.4.3

### New Feature
* Add `POST` api support with `Multipart Body`

## 0.4.2

### Updates
* Remove `PlexDataTable` and `PlexDataTableWithPages` Deprecation

## 0.4.1

### New Feature
* Add Notification in `PlexDashboard` screen. Enable `enableNotifications = true` in `PlexDashboardConfig`. Get and set notifications can be used by `PlexApp.app.getNotifications();` and `PlexApp.app.setNotifications(List<PlexNotification> notifications);` respectively.
* Add `AutoCompleteInput` Field. Just Use `PlexInputWidget` with type `PlexInputWidgetType.typeAutoComplete`. 

### New Utilities
* In `PlexAdvanceDataTable` you can initialize grouping by `initialColumnGroup`
* Groups can be auto expand or collapse by default using `autoExpandGroups` in `PlexAdvanceDataTable`
* Custom group summary can be set using `groupSummary` in `PlexAdvanceDataTable` you can initialize grouping by `initialColumnGroup`
* Group summary can have custom format by overriding `groupSummaryFormate` in `PlexAdvanceDataTable`
* If `PlexWidgetController` is of `num` type. You can call `controller.increment()` or `controller.decrement()`

### Issues & Bugs Fixes
* Print `Exceptions` on console if `ViewModel` state is undefined, and it tries to update UI

---

## 0.4.0

### New Feature
* Add `PlexViewModel` to help achieve `MVVM` pattern in the application and reduce boilerplate code

### New Utilities
* Add new storage in preferences `PlexSp.setList(key, value)` and `PlexSp.getList(key)`
* Add functions to check size of screen `isSmallScreen(context)`, `isMediumScreen(context)` and `isLargeScreen(context)` 

### Issues & Bugs Fixes
* Fix UI errors in `PlexAdvanceDataTable` on `small` and `medium` sized screens

---

## 0.3.21

* Add optional custom `HttpOverrides` implementation 
* Make `PlexUser` and `PlexForm` as `mixin class` 

---

## 0.3.20

* Update Dependency Injection, You can use it without and with tag now

---

## 0.3.19

* Update Dependency Injection: `injectFactory((parm) => object, tag: 'anyTag')` and get it anywhere by `var obj = fromPlex<Type>('tagName', parm: null)`
* Add new builder DI for singleton: `injectSingeltonLazy((parm) => object, tag: 'anyTag')`

---

## 0.3.18

* Add Dependency Injection in `plex`. Inject any dependency by `injectSingelton({object}, tag: 'anyTag')` or by `injectFactory(() => object, tag: 'anyTag')` and get it anywhere by `var obj = fromPlex<Type>('tagName')`
* You can now show,hide and check loading on dashboard screen by using `PlexApp.app.showDashboardLoading()`, `PlexApp.app.hideDashboardLoading()` and `PlexApp.app.isDashboardLoading()` respectively.
* Add Brightness Mode option as `System`, `Light` and `Dark`
* Add auto code generation for model. Add part `part '{modelName}.plex.dart';` and annotation `@plexAnnotationModel` and run command in terminal `flutter pub run build_runner build --delete-conflicting-outputs`. It will create `copy()` and `asString()` function automatically for you.

---

## 0.3.17

* Bug Fix in MultiSelection List

---

## 0.3.16

* Add two new types for `PlexInputWidget` first `PlexInputWidgetType.typeTime` and second is `PlexInputWidgetType.typeDateTime`
* Highlight the selected menu in side rail in `PlexDashboardScreen`

---

## 0.3.15

* Update `Group Icon` in `PlexAdvanceDataTable`

---

## 0.3.14

* Add `Group Columns` data in `PlexAdvanceDataTable`

---

## 0.3.13

* Add `PlexAdvanceDataTable` in the library
* Add `PDF` print in the library

---

## 0.3.12

* Bug fix in `PlexNetworking`
* Add animations in UI
* Create `Date.toDateString()` and `Date.toDateTimeString()` extension functions
* Add Improvements in Input fields

---

## 0.3.11

* Make `PlexInputWidget.dropdown` scrollable and fix hidden beneath the `keyboard`

---

## 0.3.10

* Add custom theme for Application by using static theme `PlexTheme.apptheme = ThemeData(Custom Theme Data...)`

---

## 0.3.9

* Use `PlexTheme.appTextyTheme = GoogleFonts.outfitTextTheme();` to override any text theme for the application.

---

## 0.3.8

* Fix Bug In `PlexNetworking`. Show error when API response is not an `object` and is `String` instead.

---

## 0.3.7

* Add `BuildContext` in `appbarActions` in `PlexDashboardConfig`.

---

## 0.3.6

* Add `BuildContext` in `navigationRailTopWidgets` and `navigationRailBottomWidgets` in `PlexDashboardConfig`.

---

## 0.3.5

* Add `enableCopy` in `PlexTable` & `PlexDataTableWithPages` to enable and disable copy text from eny cell.

---

## 0.3.4

* Add `navigationRailBackgroundColor`, `navigationRailBottomWidgets`, `navigationRailTopWidgets`, `hideNavigationRailVersionInfo`, `hideNavigationRailLogo`, `hideNavigationRailLogoHeight`, `hideNavigationRailLogoWidth` in `PlexDashboardConfig`
* Update Multiselect selection layout (`PlexInputWidgetType.typeMultiSelect`) for `PlexInputWidget`. Add `Chips` in selection view.
* Set `basePath` for `PlexNetworking` is optional.

---

## 0.3.3

* Add User Image Caching In the Dashboard
* Add Download File in `PlexNetworking` You can download any file using function `downloadFile`

---

## 0.3.2

* Fix bug in `POST` call. If post body is empty the `API` didn't send the call to server
* Add more extensions to List, String and DateTime.
* Update Documentations

---

## 0.3.1

* Add colorful loader in the `PlexScreen.showLoading()`
* Make colorful loader available in public API. You can use it by `PlexLoader()` anywhere.

---

## 0.3.0

* Add `AboutDialog` when click on version name in dashboard screen `appbar` actions.
* You can show `AboutDialog` anywhere by calling `PlexApp.app.showAboutDialogue(context);`. 
* About dialog get information from `PlexAppInfo` which is initialized when we create `PlexApp`.
* Add `PlexUser.getPictureUrl()`. You can override this functions to return image `URL` to be diaplayed on dashboard instead it will display user's name initials as user icon.

---

## 0.2.9

* Add Optional Input Action and KeyboardType in `PlexForm`. Can be accessed by `PlexFormField.input(this.inputType, this.inputAction)`

---

## 0.2.8

* You can add more menu in the dashboard app bar by accessing and adding `MenuItemButton` in the `appbarActions` list in the `dashboardConfig` of application
* You can `Hide` and `Show` theme controls by accessing dashboard `showThemeSwitch`, `showBrightnessSwitch` and `showMaterialSwitch` controls
* Fix Bug: Stop Dashboard Screen `onBackPress` and show error `404`
* Decrease font size of `BottomNavigationBar` on dashboard
* Add `shortTile` in `PlexRoute`. So that `Plex` can use this text when there is shortage of space. If not available it will use `title` instead automatically
* On LoggedIn user thumbnail hover, user full name will be shown as tooltip 
* Add Platform OS function `getPlatformName()`

---

## 0.2.7

* Fix exception when show message and widget is expired or unmounted

---

## 0.2.6

* Add `copyToClipboard('Your Text', showCopiedInfo = true)` function. Second argument is optional

---

## 0.2.5

* Add `PlexDataTableWithPages` widget. With this widget you can display large amount of data. Usage is same as `PlexDataTable`

---

## 0.2.4

* Make Dashboard `NavigationRail` scrollable

---

## 0.2.3

* Navigate to other dashboard screen by using `PlexApp.app.dashboardConfig?.navigateOnDashboard(index: 0);`
* Make version not visible if not given. Previously displaying `null`

---

## 0.2.2

* Dropdown field show preselection highlighted
* Print button can be hide in `PlexDataTable` by using `enablePrint` just like `enableSearch`

---

## 0.2.1

* Move `appLogo`, `appLogoDark` and `initialRoute` to `PlexAppInfo`
* Add `SideNavigation` header

---

## 0.2.0

* More than `5` menu items will be clubbed in `Mobile-View` and when user can navigate there by click `More` button
* Add `UserIcons` on top right of dashboard screen with name. Name will be hidden on small screens.

---

## 0.1.9

* Add `enableSerach` control in `PlexDataTable` to hide and show the search controls
* Add `PlexAppInfo` in the `PlexApp`. Use `appInfo` instead `title` in the `PlexApp`
* Add version info in `PlexLoginScreen` and `PlexDashboardScreen` top right menu
* Add `debugUsername` and `debugPassword` field in `PlexLoginConfig`, so `username` and `password` field appears pre-filled in debug mode for testing only

---

## 0.1.8

* Add `onLogout` Callback in `PlexApp` for post logout operations i.e. deleting some data etc

---

## 0.1.7

* Add `columnSpacing` Style In `PlexDataTable`

---

## 0.1.6

* Fix Bug In `PlexWidget`

---

## 0.1.5

* Formatting Code
* Remove Redundant Imports

---

## 0.1.4

* Fix Bug

---

## 0.1.3

* Fix PlexNetworking Bugs

---

## 0.1.2

* Updates in UI and Improvements
* Add Networking in the Library

---

## 0.1.1

* Update UI and Improvements
* Update Documentations

---

## 0.1.0

* Updates in `PlexDataTable`
* Bug Fixes and Improvements in `UI`
* Update dependencies to the latest available

---

## 0.0.9

* Update `PlexInputWidget` properties
* Make `Plex` usable without using `PlexApp`

---

## 0.0.8

* Add more documentations
* Updates and minor bug fixes

---

## 0.0.7

* Add documentations
* Update packages to latest versions
* Add examples to the code
* Add licence

---

## 0.0.6

* Major updates on design and theming
* Added `Material-3` in app
* Add `Dark Mode` in the application
* And many bug improvements and updates

---

## 0.0.5

* Add `InputAction` in the `PlexInputWidget`. By default, it will go to next text field.

---

## 0.0.4

* Fix bug in `PlexDataPicker`, crashes app when clear date if it's not already selected

---

## 0.0.3

* Fix `itemAsString` and mark it as not required

---

## 0.0.2

* Add default implementation for item as string
* Add default parameter names for callback functions

---

## 0.0.1

* Initial Build