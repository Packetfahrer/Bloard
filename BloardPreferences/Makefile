include theos/makefiles/common.mk

BUNDLE_NAME = BloardPreferences
BloardPreferences_FILES = BloardPreferences.mm
BloardPreferences_INSTALL_PATH = /Library/PreferenceBundles
BloardPreferences_FRAMEWORKS = UIKit
BloardPreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BloardPreferences.plist$(ECHO_END)
