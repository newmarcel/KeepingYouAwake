# KeepingYouAwake #

## Changelog ##

### v1.5.0pre ###

- support for App Transport Security and App Sandbox
	- start at login_ uses a helper app now
	- the previous login item is not compatible anymore and it is recommended to disable start at login_ before the update!
	- custom icons need to be placed in `~/Library/Containers/info.marcel-dierkes.KeepingYouAwake/Data/Documents` now and will be migrated with the update

### v1.4.3pre ###

- the icon can be dragged out of the menubar to quit on macOS Sierra and newer ([#82](https://github.com/newmarcel/KeepingYouAwake/issues/82), suggested by [Eitot](https://github.com/Eitot))
- support for the `keepingyouawake:///toggle` action ([#96](https://github.com/newmarcel/KeepingYouAwake/pull/96)), *thanks [code918](https://github.com/code918)*!
- new localizations
	- Polish ([#90](https://github.com/newmarcel/KeepingYouAwake/pull/90)) _Thank you [karolgorecki](https://github.com/karolgorecki)!_
	- Portuguese ([#94](https://github.com/newmarcel/KeepingYouAwake/pull/94)) _Thank you [luizpedone](https://github.com/luizpedone)!_
	- Update German for informal style ([#74](https://github.com/newmarcel/KeepingYouAwake/pull/74)) _Thank you [Eitot](https://github.com/Eitot)!_

### v1.4.2 ###

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

### v1.4.1 ###

- Localization support
	- German
	- French ([Issue #51](https://github.com/newmarcel/KeepingYouAwake/issues/51))
		- *Thank you [rei-vilo](https://github.com/rei-vilo)!*
	- Korean ([Issue #64](https://github.com/newmarcel/KeepingYouAwake/pull/64))
		- *Thank you [Pusnow](https://github.com/Pusnow)!*
- removed advanced preference to allow the display to sleep *(didn't work properly and lead to confusion)*
	- the `info.marcel-dierkes.KeepingYouAwake.AllowDisplaySleep` preference was removed
	- a similar, more powerful replacement feature will be introduced soon

### v1.4 ###

- Added a preferences window that replaces seldom used menu items and surfaces advanced and experimental preferences
- You can now set the default activation duration for the menu bar icon in preferences
- Removed the advanced preference for `info.marcel-dierkes.KeepingYouAwake.PreventSleepOnACPower`
- Added an advanced preference to allow display sleep while still preventing system sleep ([Issue #25](https://github.com/newmarcel/KeepingYouAwake/issues/25))
- Ability to set a battery level on MacBooks where the app will deactivate itself ([Issue #24](https://github.com/newmarcel/KeepingYouAwake/issues/24))
	- *Thank you [timbru31](https://github.com/timbru31) for the suggestion!*
- Upgraded to Sparkle 1.14.0 to fix potential security issues

### v1.3.1 ###

- Fixed Sparkle Updates *(Broken thanks to App Transport Security in OS X 10.11 and GitHub disabling HTTPS for pages)* If you know someone with Version 1.3.0, please let them know that 1.3.1 is available and can be downloaded manually to receive future updates. This is a nightmare come true… 😱
- Fixed rendering for custom icons: They are now rendered as template images
- Added advanced settings to disable the blue highlight rectangle on click. Enable it with *(replace YES with NO to disable it again)*:

		defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.MenuBarIconHighlightDisabled -bool YES



### v1.3 ###

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


### v1.2.1 ###

- Fixed an issue where "Start at Login" would crash when clicked multiple times in a row *(Fixed by [registered99](https://github.com/registered99), thank you!)*
- Less aggressive awake handling when the MacBook lid is closed by using the `caffeinate -di` command instead of `caffeinate -disu`
- You can revert back to the previous behaviour by pasting the following snippet into *Terminal.app*:

		defaults write info.marcel-dierkes.KeepingYouAwake.PreventSleepOnACPower -bool YES

- `ctrl` + `click` will now display the menu

### v1.2 ###
- There are no significant changes since beta1
- Tweaked the experimental *(and hidden)* notifications
- You can enable the notifications preview by pasting the following snippet into *Terminal.app*:

		defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.NotificationsEnabled -bool YES
		
- and to disable it again:
	
		defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.NotificationsEnabled -bool NO


### v1.2beta1 ###
- Activation timer
- [Sparkle](http://sparkle-project.org) integration for updates
	- Sparkle will check for updates once a day
	- A second beta will follow in the coming days to test automatic updates
- This is **beta** software. If you notice any issues, please report them [here](https://github.com/newmarcel/KeepingYouAwake/issues/)

### v1.1 ###
- Signed with Developer ID
- Start At Login menu item added

### v1.0 ###
- Initial Release
- Keeps your Mac awake
