# Twitter Bootstrap 2.3.2 with validation error messages
This re-introduces validation error messages to bootstrap:themed forms. Otherwise it's the same as https://github.com/seyhunak/twitter-bootstrap-rails

In the default branch of this gem, applying bootstrap:themed to scaffold-generated forms removes the validation error messages functionality. This is a dangerous default behavior because users may not know that this has been removed, nor what they should do in order to regain the functionality. 

I restored the functionality and also applied Bootstrap-compliant styling to the validation error message (see screenshot) in order to improve the default behavior of this gem for those who don't install SimpleForms.

![bootstrap-rails-with-validation-errors](https://cloud.githubusercontent.com/assets/801116/3719061/aee1bfde-163e-11e4-9af8-9fbb8eac6882.PNG)

I have requested a merge.
