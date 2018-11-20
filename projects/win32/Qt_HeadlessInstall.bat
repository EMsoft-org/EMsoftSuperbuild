
@echo off

REM Setup some environment variables in order to collect those into a single location
set EMsoft_SDK=@EMsoft_SDK@


@QT5_ONLINE_INSTALLER@ --script @JSFILE@

