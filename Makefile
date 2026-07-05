TARGET = iphone:clang:latest:12.2
INSTALL_TARGET_PROCESSES = FFMMExt

include $(THEOS_MAKE_PATH)/application.mk

APPLICATION_NAME = FFMMExt

FFMMExt_FILES = AppDelegate.swift RootViewController.swift
FFMMExt_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/application.mk
