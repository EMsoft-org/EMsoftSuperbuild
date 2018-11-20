// Emacs mode hint: -*- mode: JavaScript -*-

function Controller() {
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    })
}

Controller.prototype.WelcomePageCallback = function() {
    // click delay here because the next button is initially disabled for ~1 second
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function()
{
    gui.currentPageWidget().TargetDirectoryLineEdit.setText("@QT_INSTALL_LOCATION@");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();
    widget.deselectAll();
    widget.selectComponent("qt.@qt5_installer_version@.doc");
    widget.selectComponent("qt.@qt5_installer_version@.doc.qtcharts");
    widget.selectComponent("qt.@qt5_installer_version@.doc.qtdatavis3d");
    widget.selectComponent("qt.@qt5_installer_version@.doc.qtwebengine");
    widget.selectComponent("qt.@qt5_installer_version@.examples");
    widget.selectComponent("qt.@qt5_installer_version@.examples.qtcharts");
    widget.selectComponent("qt.@qt5_installer_version@.examples.qtdatavis3d");
    widget.selectComponent("qt.@qt5_installer_version@.examples.qtwebengine");
    widget.selectComponent("qt.@qt5_installer_version@.qtcharts");
    widget.selectComponent("qt.@qt5_installer_version@.qtcharts.win64_@QT_MSVC_VERSION_NAME@");
    widget.selectComponent("qt.@qt5_installer_version@.qtdatavis3d");
    widget.selectComponent("qt.@qt5_installer_version@.qtdatavis3d.win64_@QT_MSVC_VERSION_NAME@");
    widget.selectComponent("qt.@qt5_installer_version@.qtwebengine");
    widget.selectComponent("qt.@qt5_installer_version@.qtwebengine.win64_@QT_MSVC_VERSION_NAME@");
  //  widget.selectComponent("qt.@qt5_installer_version@.src");
    widget.selectComponent("qt.@qt5_installer_version@.win64_@QT_MSVC_VERSION_NAME@");
    widget.selectComponent("qt.tools.qtcreator");
    widget.selectComponent("qt.tools.vcredist_@QT_MSVC_VERSION_NAME@_x64");
    widget.selectComponent("qt.tools.vcredist_@QT_MSVC_VERSION_NAME@_x86");

    gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.FinishedPageCallback = function() {
    var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm
    if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
        checkBoxForm.launchQtCreatorCheckBox.checked = false;
    }
    gui.clickButton(buttons.FinishButton);
}
