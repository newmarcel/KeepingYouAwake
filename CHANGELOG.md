# KeepingYouAwake #

## Changelog ##

### v1.2.2 ###

- Basic command line interface through URI schemes
	- *Thank you [KyleKing](https://github.com/KyleKing) for the suggestion!*
	- you can activate/deactivate the sleep timer with unlimited time intervals
	- you can open *KeepingYouAwake* from the command line with a custom sleep timer duration
	- the *seconds*, *minutes* and *hours* parameters accept integer numbers and cannot be combined at the moment

	open keepingyouawake://  
	open keepingyouawake:///activate    # indefinite duration  
	open keepingyouawake:///activate?seconds=5  
	open keepingyouawake:///activate?minutes=5  
	open keepingyouawake:///activate?hours=5  
	open keepingyouawake:///deactivate


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
