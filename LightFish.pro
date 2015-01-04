# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = LightFish

CONFIG += sailfishapp

SOURCES += src/LightFish.cpp \
    src/lifxlightsmodel.cpp

OTHER_FILES += qml/LightFish.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/$${TARGET}.spec \
    rpm/$${TARGET}.yaml \
    translations/*.ts \
    $${TARGET}.desktop \
    qml/pages/BulbListPage.qml \
    lightfish_test_3.png \
    qml/pages/BulbDetails.qml \
    qml/pages/storage.js \
    qml/images/lifx-icon.png \
    qml/storage.js \
    qml/images/logo_lifx_white.png \
    qml/images/logo_lifx.png \
    qml/images/logo_lifx_grey.png \
    qml/perl/iwpriv_helper.pl \
    qml/pages/IntroPage.qml \
    qml/analytics.js \
    qml/images/LIFX_Bulb_bg.jpg \
    qml/images/LIFX_Bulb_bg.png \

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/$${TARGET}-de.ts

HEADERS += \
    src/lifxlightsmodel.h

#INCLUDEPATH += ../libQTIoT_sailfish/src/
INCLUDEPATH += ../libQTIoT/src/
#unix:LIBS += "-L../build-QTIoT-Desktop_Qt_Qt_Version_clang_64bit-Debug" "-lQTIoT"
unix:LIBS += "-L../libQTIoT/build-QTIoT_SF-MerSDK_SailfishOS_armv7hl-Debug" "-lQTIoT"
unix:LIBS += "-L../libQTIoT/build-QTIoT_SF-MerSDK_SailfishOS_i486-Debug" "-lQTIoT"
#unix:LIBS += "-L../libQTIoT/build-QTIoT_SF-MerSDK_SailfishOS_armv7hl-Release" "-lQTIoT"
