! Bottom keyboard row has been remapped in Windows Registry as follows.
!
!   Old:  [Control_L][Fn][  Super_L][    Alt_L][Space][Alt_R][Control_R]
!   New:  [  Super_L][Fn][Control_L][Control_R][Space][Alt_L][    Alt_R]
!
! Outcomes
! --------
!
! * Thumbs press Control and Alt keys, just like Macbook Pro.
!     + Less strain on left hand and pinky.
!     + Great for Emacs (possibly the best key mapping).
! * More logical consistency between Control_L/R and Alt_L/R locations.
!     + Even with incorrect physical labels, still easy to remember.
! * Super_L in more appropriate location based on its relative usage.
!     + Still easy to get to when needed.
!     + Allows physical Windows key presses to pass-through to applications.
! * Caps_Lock conveniently located in native location.
!     + No need to use uncomfortable workarounds.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! Default Modifier Keys
! ---------------------
!
!     Mod1 = Alt_L Meta_L (though Meta_L is usually nonexistent)
!     Mod2 = Alt_R Num_Lock (rarely used, but should not change)
!     Mod3 = (blank -- save this for future use)
!
! Custom Modifier Keys
! --------------------

clear Control
! --- Control = Control_R Control_L (remapping to Mod3)
add   Control = Control_R

clear Mod4
! +++ Mod4 = Super_L Super_R Hyper_L (useless on Windows)
add   Mod4 = Control_L
