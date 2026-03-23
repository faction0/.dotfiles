// allow userchrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// dark mode
user_pref("layout.css.prefers-color-scheme.content-override", 0);

// diy blank new tab
user_pref("browser.newtabpage.enabled"                       , false);
user_pref("browser.newtabpage.activity-stream.enabled"       , false);
user_pref("browser.newtabpage.activity-stream.showSponsored" , false);
user_pref("browser.newtabpage.activity-stream.showTopSites"  , false);

// stupid popups
user_pref('signon.showAutoCompleteFooter', false);
user_pref('signon.firefoxRelay.feature', 'unavailable');


// others
user_pref('browser.startup.homepage', 'about:blank');
user_pref("browser.aboutConfig.showWarning", false);
user_pref('beacon.enabled', false);

user_pref('browser.urlbar.update2.engineAliasRefresh', true);

user_pref('browser.search.suggest.enabled', false);






