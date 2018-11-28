// Emacs mode hint: -*- mode: JavaScript -*-

function Controller() {
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    })
}

Controller.prototype.WelcomePageCallback = function () {
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
    
    // This is for Qt5 installation
    widget.deselectAll();
    widget.selectComponent("qt.@qt5_installer_version@.clang_64");
    widget.selectComponent("qt.@qt5_installer_version@.qtwebengine");

    widget.selectComponent("qt.@qt5_installer_version@.doc");
    widget.selectComponent("qt.@qt5_installer_version@.doc.qtcharts");
    widget.selectComponent("qt.@qt5_installer_version@.doc.qtdatavis3d");
    widget.selectComponent("qt.@qt5_installer_version@.doc.qtwebengine");
    widget.selectComponent("qt.@qt5_installer_version@.examples");
    widget.selectComponent("qt.@qt5_installer_version@.examples.qtcharts");
    widget.selectComponent("qt.@qt5_installer_version@.examples.qtdatavis3d");
    widget.selectComponent("qt.@qt5_installer_version@.examples.qtwebengine");
    widget.selectComponent("qt.@qt5_installer_version@.qtcharts");
    widget.selectComponent("qt.@qt5_installer_version@.qtcharts.clang_64");
    widget.selectComponent("qt.@qt5_installer_version@.qtdatavis3d");
    widget.selectComponent("qt.@qt5_installer_version@.qtdatavis3d.clang_64");
    widget.selectComponent("qt.@qt5_installer_version@.qtwebengine");
    widget.selectComponent("qt.@qt5_installer_version@.qtwebengine.clang_64");
    // widget.selectComponent("qt.@qt5_installer_version@.src");
    widget.selectComponent("qt.@qt5_installer_version@.clang_64");
    widget.selectComponent("qt.tools.qtcreator");

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
