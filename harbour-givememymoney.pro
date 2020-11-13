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
TARGET = harbour-givememymoney

CONFIG += sailfishapp

SOURCES += src/harbour-givememymoney.cpp \
    src/models/qobjectlistmodel.cpp

DISTFILES += qml/harbour-givememymoney.qml \
    qml/components/Object.qml \
    qml/cover/CoverPage.qml \
    qml/pages/BalancesPage.qml \
    qml/pages/ItemsPage.qml \
    qml/store/Balance.qml \
    qml/store/BalanceItem.qml \
    qml/pages/NewBalance.qml \
    qml/store/Store.qml \
    rpm/harbour-givememymoney.changes.in \
    rpm/harbour-givememymoney.changes.run.in \
    rpm/harbour-givememymoney.spec \
    rpm/harbour-givememymoney.yaml \
    translations/*.ts \
    harbour-givememymoney.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-givememymoney-de.ts

HEADERS += \
    src/models/qobjectlistmodel.h
