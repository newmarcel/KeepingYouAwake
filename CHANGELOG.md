# KeepingYouAwake

## Changelog

### v.1.6.8

- added a light/dark/clear app icon for macOS 26 Tahoe

### v1.6.7 (2025-07-18)

- fixed two issues with the "Activate when an external display is connected" advanced setting:
	- fixed an issue where multiple `caffeinate` tasks were spawned when an external display was connected ([#203](https://github.com/newmarcel/KeepingYouAwake/issues/203))
	- fixed an issue where a mirrored display was not treated internally as external display ([#210](https://github.com/newmarcel/KeepingYouAwake/issues/210))
- fixed an issue where the menu bar icon did not update properly when the URL scheme was used to activate or deactivate ([#224](https://github.com/newmarcel/KeepingYouAwake/issues/224))
- updated the Spanish translations ([#223](https://github.com/newmarcel/KeepingYouAwake/pull/223))
	- *Thank you [agusbattista](https://github.com/agusbattista)!*
- added Vietnamese translations ([#222](https://github.com/newmarcel/KeepingYouAwake/pull/222))
	- *Thank you [ksajolaer](https://github.com/ksajolaer)!*
- added Hindi translations ([#232](https://github.com/newmarcel/KeepingYouAwake/pull/232))
	- *Thank you [AnandChowdhary](https://github.com/AnandChowdhary)!*
- added Greek and Finnish translations ([#230](https://github.com/newmarcel/KeepingYouAwake/pull/230))
	- *Thank you [ziz1zaza](https://github.com/ziz1zaza)!*
- since macOS 26 Tahoe allows hiding the app's menu bar icon, the settings window was extended to handle this situation better:
	- the settings window will now be presented when the app is launched again while running
	- added a Quit button to the General settings
- updated the app icon to not be trapped in a grey box on macOS 26 Tahoe

### v1.6.6 (2024-10-26)

- added Slovak translations ([#209](https://github.com/newmarcel/KeepingYouAwake/pull/209))
    - *Thank you Tomáš Švec!*
- updated the Turkish translations ([#212](https://github.com/newmarcel/KeepingYouAwake/pull/212))
	- *Thank you [egesucu](https://github.com/egesucu)!*
- updated the Chinese translations ([#213](https://github.com/newmarcel/KeepingYouAwake/pull/213))
	- *Thank you [LZhenHong](https://github.com/LZhenHong)!*
- updated the Russian translations ([#216](https://github.com/newmarcel/KeepingYouAwake/pull/216))
	- *Thank you [user334](https://github.com/user334)!*
- updated the Ukrainian translations ([#218](https://github.com/newmarcel/KeepingYouAwake/pull/218))
	- *Thank you [gelosi](https://github.com/gelosi)!*
- updated Sparkle to v2.6.4 ([#214](https://github.com/newmarcel/KeepingYouAwake/pull/214))

### v1.6.5 (2023-10-02)

- updated the Traditional Chinese translation ([#198](https://github.com/newmarcel/KeepingYouAwake/pull/198))
    - *Thank you [YuerLee](https://github.com/YuerLee)!*
- updated the French translation ([#201](https://github.com/newmarcel/KeepingYouAwake/pull/201))
    - *Thank you [tmuguet](https://github.com/tmuguet)!*
- removed the advanced setting "Disable menu bar icon highlight color", this behavior can still be enabled using the `defaults` command: `defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.MenuBarIconHighlightDisabled -bool YES`

### v1.6.4 (2022-11-14)

- shows in the "Login Items" > "Open at Login" section in System Settings on macOS Ventura if "Start at Login" is enabled
- fixes a regression introduced in 1.6.3 where the `keepingyouawake:///activate` URL scheme stopped working as expected ([#193](https://github.com/newmarcel/KeepingYouAwake/issues/193))

### v1.6.3 (2022-10-30)

- added Battery preferences with support for Low Power Mode on compatible Macs ([#181](https://github.com/newmarcel/KeepingYouAwake/pull/181))
- added a Japanese translation ([#182](https://github.com/newmarcel/KeepingYouAwake/issues/182))
    - *Thank you [hiroto-t](https://github.com/hiroto-t)!*
- updated the Turkish translation ([#183](https://github.com/newmarcel/KeepingYouAwake/issues/183))
    - *Thank you [egemenu](https://github.com/egemenu)!*
- added an Italian translation ([#184](https://github.com/newmarcel/KeepingYouAwake/issues/184))
    - *Thank you [gmcinalli](https://github.com/gmcinalli)!*
- added an advanced preference to auto-activate when an external screen is connected ([#186](https://github.com/newmarcel/KeepingYouAwake/issues/186), [#84](https://github.com/newmarcel/KeepingYouAwake/issues/84))
	- *Thank you [sturza](https://github.com/sturza)!*
 - added an advanced preference to deactivate while another user account is active

**Please note: The 1.6.3 release does not support macOS Sierra anymore. You can continue using version 1.6.2 on this version of macOS.**

### v1.6.2 (2022-02-20)

- updated the Danish translation ([#171](https://github.com/newmarcel/KeepingYouAwake/pull/171), [#180](https://github.com/newmarcel/KeepingYouAwake/pull/180))
    - *Thank you [JacobSchriver](https://github.com/JacobSchriver)!*
- updated the [Sparkle](https://github.com/sparkle-project/Sparkle) update framework to version 2.0 ([#178](https://github.com/newmarcel/KeepingYouAwake/pull/178))
- added a Ukrainian translation ([#179](https://github.com/newmarcel/KeepingYouAwake/issues/179))
    - *Thank you [gelosi](https://github.com/gelosi)!*

### v1.6.1 (2021-07-24)

- added support for notifications, use `System Preferences` to manage notification settings ([#164](https://github.com/newmarcel/KeepingYouAwake/pull/164))
  - please note, this feature is only available on macOS 11 or newer; the previous experimental notifications support has been removed
- updated the French translation ([#146](https://github.com/newmarcel/KeepingYouAwake/issues/146), [#169](https://github.com/newmarcel/KeepingYouAwake/pull/169))
    - *Thank you [alexandreleroux](https://github.com/alexandreleroux)!*

### v1.6.0 (2020-11-06)

- raised minimum deployment target to macOS Sierra ([#142](https://github.com/newmarcel/KeepingYouAwake/pull/142))
- updated icons using the macOS Big Sur style ([#141](https://github.com/newmarcel/KeepingYouAwake/pull/141))
- added support for the arm64 architecture on macOS Big Sur
- created an official website [https://keepingyouawake.app/](https://keepingyouawake.app/)
- added a Russian translation ([#147](https://github.com/newmarcel/KeepingYouAwake/issues/147), [#155](https://github.com/newmarcel/KeepingYouAwake/pull/155))
    - *Thank you [Kromsator](https://github.com/Kromsator)!*

### v1.5.2 (2020-07-04)

- added the ability to allow the display to sleep ([#148](https://github.com/newmarcel/KeepingYouAwake/issues/148))
	- _Thanks [creamelectricart](https://github.com/creamelectricart)!_

### v1.5.1 (2019-12-26)

- added the ability to customize activation durations in _Preferences_ ([#132](https://github.com/newmarcel/KeepingYouAwake/pull/132))
- added an advanced preference to quit the app when the activation duration is over ([#133](https://github.com/newmarcel/KeepingYouAwake/pull/133))
	- _Thanks [jamesgecko](https://github.com/jamesgecko) for the [suggestion](https://github.com/newmarcel/KeepingYouAwake/issues/128)!_
- added an Indonesian translation ([#137](https://github.com/newmarcel/KeepingYouAwake/pull/137))
    - *Thank you [ibnuh](https://github.com/ibnuh)!*

**Please note: The 1.5.x series of releases will be the last supporting macOS Yosemite and El Capitan. If you see any critical reason for supporting those, please leave a comment on [GitHub](https://github.com/newmarcel/KeepingYouAwake/issues/126).**

### v1.5.0 (2019-01-20)

- added an _Updates_ tab to _Preferences_ ([#107](https://github.com/newmarcel/KeepingYouAwake/pull/107))
- enabled the _Hardened Runtime_ security feature ([#111](https://github.com/newmarcel/KeepingYouAwake/pull/111))
- enabled the _App Sandbox_ security feature ([#112](https://github.com/newmarcel/KeepingYouAwake/pull/112))
	- custom icons need to be placed in `~/Library/Containers/info.marcel-dierkes.KeepingYouAwake/Data/Documents` now and will be migrated during the app update
- _Start at login_ uses a launcher helper app now ([#110](https://github.com/newmarcel/KeepingYouAwake/pull/110))
    - the previous login item is not compatible anymore and **it is recommended to disable _Start at login_ before updating**!
    - please check [this wiki page](https://github.com/newmarcel/KeepingYouAwake/wiki/1.5:-Start-at-Login-Problems) if you encounter problems
- updated Sparkle to the `ui-separation-and-xpc` version ([#109](https://github.com/newmarcel/KeepingYouAwake/pull/109)) ([#113](https://github.com/newmarcel/KeepingYouAwake/pull/113))

### v1.4.3 (2018-08-15)

- the icon can be dragged out of the menubar to quit on macOS Sierra and newer ([#82](https://github.com/newmarcel/KeepingYouAwake/issues/82), suggested by [Eitot](https://github.com/Eitot))
- support for the `keepingyouawake:///toggle` action ([#96](https://github.com/newmarcel/KeepingYouAwake/pull/96)), *thanks [code918](https://github.com/code918)*!
- new localizations
	- Polish ([#90](https://github.com/newmarcel/KeepingYouAwake/pull/90)) _Thank you [karolgorecki](https://github.com/karolgorecki)!_
	- Portuguese ([#94](https://github.com/newmarcel/KeepingYouAwake/pull/94)) _Thank you [luizpedone](https://github.com/luizpedone)!_
	- Update German for informal style ([#74](https://github.com/newmarcel/KeepingYouAwake/pull/74)) _Thank you [Eitot](https://github.com/Eitot)!_
- allows Dark Aqua appearance on macOS Mojave

### v1.4.2 (2017-09-16)

- support cmd+w and cmd+q keyboard shortcuts in the preferences window ([#56](https://github.com/newmarcel/KeepingYouAwake/issues/56))
- preferences now remember the window position
- allow option-click on the menubar icon ([#59](https://github.com/newmarcel/KeepingYouAwake/issues/59))
- fixed the incorrect fullscreen behavior of the preferences window ([#71](https://github.com/newmarcel/KeepingYouAwake/pull/71)), *thanks [Eitot](https://github.com/Eitot)!*
- more localization updates
	- Spanish ([#70](https://github.com/newmarcel/KeepingYouAwake/pull/70))
		- *Thank you [nbalonso](https://github.com/nbalonso)!*
	- Dutch ([#73](https://github.com/newmarcel/KeepingYouAwake/pull/73))
		- *Thank you [Eitot](https://github.com/Eitot)!*
	- improvements to the French translation by [alexandreleroux](https://github.com/alexandreleroux) ([#63](https://github.com/newmarcel/KeepingYouAwake/pull/63))
	- Danish ([#78](https://github.com/newmarcel/KeepingYouAwake/pull/78))
		- *Thank you [JacobSchriver](https://github.com/JacobSchriver)!*
	- Turkish ([#79](https://github.com/newmarcel/KeepingYouAwake/pull/79))
		- *Thank you [durul](https://github.com/durul)!*
	- Chinese (Simplified) ([#87](https://github.com/newmarcel/KeepingYouAwake/pull/87))
		- *Thank you [zangyongyi](https://github.com/zangyongyi)!*
	- Chinese (Traditional zh-Hant-TW) ([#89](https://github.com/newmarcel/KeepingYouAwake/pull/89))
		- *Thank you [passerbyid](https://github.com/passerbyid)!*
- updated Sparkle to 1.18.1

### v1.4.1 (2016-12-30)

- Localization support
	- German
	- French ([Issue #51](https://github.com/newmarcel/KeepingYouAwake/issues/51))
		- *Thank you [rei-vilo](https://github.com/rei-vilo)!*
	- Korean ([Issue #64](https://github.com/newmarcel/KeepingYouAwake/pull/64))
		- *Thank you [Pusnow](https://github.com/Pusnow)!*
- removed advanced preference to allow the display to sleep *(didn't work properly and lead to confusion)*
	- the `info.marcel-dierkes.KeepingYouAwake.AllowDisplaySleep` preference was removed
	- a similar, more powerful replacement feature will be introduced soon

### v1.4 (2016-04-16)

- Added a preferences window that replaces seldom used menu items and surfaces advanced and experimental preferences
- You can now set the default activation duration for the menu bar icon in preferences
- Removed the advanced preference for `info.marcel-dierkes.KeepingYouAwake.PreventSleepOnACPower`
- Added an advanced preference to allow display sleep while still preventing system sleep ([Issue #25](https://github.com/newmarcel/KeepingYouAwake/issues/25))
- Ability to set a battery level on MacBooks where the app will deactivate itself ([Issue #24](https://github.com/newmarcel/KeepingYouAwake/issues/24))
	- *Thank you [timbru31](https://github.com/timbru31) for the suggestion!*
- Upgraded to Sparkle 1.14.0 to fix potential security issues

### v1.3.1 (2015-12-08)

- Fixed Sparkle Updates *(Broken thanks to App Transport Security in OS X 10.11 and GitHub disabling HTTPS for pages)* If you know someone with Version 1.3.0, please let them know that 1.3.1 is available and can be downloaded manually to receive future updates. This is a nightmare come true… 😱
- Fixed rendering for custom icons: They are now rendered as template images
- Added advanced settings to disable the blue highlight rectangle on click. Enable it with *(replace YES with NO to disable it again)*:

		defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.MenuBarIconHighlightDisabled -bool YES



### v1.3 (2015-11-02)

- Basic command line interface through URI schemes
	- *Thank you [KyleKing](https://github.com/KyleKing) for the suggestion!*
	- you can activate/deactivate the sleep timer with unlimited time intervals
	- you can open *KeepingYouAwake* from the command line with a custom sleep timer duration
	- the *seconds*, *minutes* and *hours* parameters are rounded up to the nearest integer number and cannot be combined at the moment

	open keepingyouawake://  
	open keepingyouawake:///activate    # indefinite duration  
	open keepingyouawake:///activate?seconds=5  
	open keepingyouawake:///activate?minutes=5  
	open keepingyouawake:///activate?hours=5  
	open keepingyouawake:///deactivate

- Support for custom menu bar icons. Just place four images named `ActiveIcon.png`, `ActiveIcon@2x.png`, `InactiveIcon.png`, `InactiveIcon@2x.png` in your `~/Library/Application Support/KeepingYouAwake/` folder. The recommended size for these images is 22x20 pts
- hold down the option key and click inside the *"Activate for Duration"* menu to set the default duration for the menu bar icon


### v1.2.1 (2015-01-11)

- Fixed an issue where "Start at Login" would crash when clicked multiple times in a row *(Fixed by [registered99](https://github.com/registered99), thank you!)*
- Less aggressive awake handling when the MacBook lid is closed by using the `caffeinate -di` command instead of `caffeinate -disu`
- You can revert back to the previous behaviour by pasting the following snippet into *Terminal.app*:

		defaults write info.marcel-dierkes.KeepingYouAwake.PreventSleepOnACPower -bool YES

- `ctrl` + `click` will now display the menu

### v1.2 (2014-11-23)
- There are no significant changes since beta1
- Tweaked the experimental *(and hidden)* notifications
- You can enable the notifications preview by pasting the following snippet into *Terminal.app*:

		defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.NotificationsEnabled -bool YES
		
- and to disable it again:
	
		defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.NotificationsEnabled -bool NO


### v1.2beta1
- Activation timer
- [Sparkle](http://sparkle-project.org) integration for updates
	- Sparkle will check for updates once a day
	- A second beta will follow in the coming days to test automatic updates
- This is **beta** software. If you notice any issues, please report them [here](https://github.com/newmarcel/KeepingYouAwake/issues/)

### v1.1 (2014-11-13)
- Signed with Developer ID
- Start At Login menu item added

### v1.0 (2014-10-19)
- Initial Release
- Keeps your Mac awake
