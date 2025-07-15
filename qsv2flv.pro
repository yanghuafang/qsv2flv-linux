QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    converter.cpp \
    datamodel.cpp \
    inputfilemodel.cpp \
    main.cpp \
    mainwindow.cpp \
    qsvreader.cpp

HEADERS += \
    converter.h \
    datamodel.h \
    inputfilemodel.h \
    mainwindow.h \
    qsvreader.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# Remove the unconditional include and libs, and replace with conditional ffmpeg linkage
# existing INCLUDEPATH and LIBS lines are removed/replaced below
win32 {
    INCLUDEPATH += $$PWD/ffmpeg/include
    LIBS += -L$$PWD/ffmpeg/lib \
            -lavcodec \
            -lavdevice \
            -lavfilter \
            -lavformat \
            -lavutil \
            -lpostproc \
            -lswresample \
            -lswscale
}

unix:!macx {
    # Link against system FFmpeg shared libraries (install libavcodec-dev, libavformat-dev, etc.)
    LIBS += -lavcodec -lavdevice -lavfilter -lavformat -lavutil -lpostproc -lswresample -lswscale
}
