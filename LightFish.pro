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

SOURCES += src/LightFish.cpp

OTHER_FILES += qml/LightFish.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/$${TARGET}.spec \
    rpm/$${TARGET}.yaml \
    translations/*.ts \
    $${TARGET}.desktop \
    qml/pages/BulbListPage.qml \
    qml/pages/lightfish.py \
    qml/pages/lifx3/packetcodec.py \
    qml/pages/lifx3/network.py \
    qml/pages/lifx3/listen.py \
    qml/pages/lifx3/lifxconstants.py \
    qml/pages/lifx3/lifx3.py \
    lightfish_test_3.png \
    qml/lightfish.py \
    qml/pages/BulbDetails.qml \
    qml/pages/storage.js \
    qml/images/lifx-icon.png \
    qml/storage.js \
    qml/images/logo_lifx_white.png \
    qml/images/logo_lifx.png \
    qml/images/logo_lifx_grey.png \
    qml/perl/iwpriv_helper.pl \
    qml/lifx3/lifx.py \
    qml/lifx/packetcodec.py \
    qml/lifx/network.py \
    qml/lifx/listen.py \
    qml/lifx/lifxconstants.py \
    qml/lifx/lifx.py \
    qml/lifx/__init__.py

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/$${TARGET}-de.ts

