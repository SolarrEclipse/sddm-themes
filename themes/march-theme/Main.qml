import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import SddmComponents 2.0 as SDDM
import "components" as March

Item {
    id: root
    property int sessionIndex: sessionModel.lastIndex
    SDDM.Background {
        id: backgroundImage
        anchors.fill: parent
        source: "images/background.png"
    }

    Rectangle {
        id: glassPane
        anchors.centerIn: parent
        width: 400
        height: 550
        radius: 12

        ShaderEffectSource {
            id: shaderSource
            anchors.fill: parent
            sourceItem: backgroundImage
            sourceRect: Qt.rect(glassPane.x, glassPane.y, glassPane.width, glassPane.height)
        }

        GaussianBlur {
            anchors.fill: parent
            source: shaderSource
            radius: 12
        }

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: Qt.rgba(0.12, 0.12, 0.12, 0.15)

            border {
                width: 1
                color: "#ffffff"
            }
        }

        ColumnLayout {
            anchors {
                fill: parent
                margins: 24
            }

            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 80
                Layout.preferredWidth: 200

                SDDM.Clock {
                    anchors.centerIn: parent
                    timeFont: Qt.font({
                        pixelSize: 48,
                        weight: Font.Bold
                    })
                    dateFont: Qt.font({
                        pixelSize: 14
                    })
                }
            }

            Item {
                Layout.preferredHeight: 2
            }

            Rectangle {
                height: 2
                width: parent.width
                color: "white"
            }

            Item {
                Layout.preferredHeight: 10
            }

            Item {
                id: avatar
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 160
                Layout.preferredWidth: 160

                Image {
                    id: avatarImage
                    anchors.fill: parent
                    source: "images/avatar.jpg"
                    fillMode: Image.PreserveAspectCrop
                    sourceSize: Qt.size(320, 320)
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: avatarImage.width
                            height: avatarImage.height
                            Rectangle {
                                anchors.fill: parent
                                radius: width / 2
                                color: "black"
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: "transparent"
                    border {
                        color: "#ffffff"
                        width: 2
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: userModel.lastUser || "User"
                color: "white"
                font.pixelSize: 18
                font.weight: Font.Bold
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 32

                TextField {
                    id: passField
                    anchors.fill: parent
                    placeholderText: "Enter Password.."
                    echoMode: TextInput.Password

                    rightPadding: 32
                    leftPadding: 8
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 12
                        color: Qt.rgba(0.18, 0.18, 0.5, 0.35)
                    }

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(userModel.lastUser, passField.text, sessionIndex);
                            event.accepted = true;
                        }
                    }

                    Image {
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 8
                        }

                        width: 24
                        height: 24
                        source: "assets/Password.svg"
                        sourceSize: Qt.size(48, 48)
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            Item {
                Layout.preferredHeight: 35
            }

            RowLayout {
                id: buttons
                Layout.preferredHeight: 60
                Layout.alignment: Qt.AlignHCenter
                anchors {
                    leftMargin: 200
                }

                MouseArea {
                    id: rebootArea
                    hoverEnabled: true
                    Layout.preferredHeight: 60
                    Layout.preferredWidth: 60
                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: sddm.reboot()

                    Rectangle {
                        anchors.fill: parent
                        color: "#2a2a2a"
                        radius: 12

                        Behavior on border.color {
                            ColorAnimation {
                                duration: 150
                            }
                        }

                        border {
                            color: parent.containsMouse ? "white" : "grey"
                            width: 2
                        }

                        Image {
                            source: "assets/Reboot.svg"
                            anchors {
                                fill: parent
                                leftMargin: 10
                                rightMargin: 10
                                topMargin: 10
                                bottomMargin: 10
                            }
                            sourceSize: Qt.size(80, 80)
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                MouseArea {
                    id: shutdownArea
                    hoverEnabled: true
                    Layout.preferredHeight: 60
                    Layout.preferredWidth: 60
                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: sddm.powerOff()

                    Rectangle {
                        anchors.fill: parent
                        color: "#2a2a2a"
                        radius: 12

                        Behavior on border.color {
                            ColorAnimation {
                                duration: 150
                            }
                        }

                        border {
                            color: parent.containsMouse ? "white" : "grey"
                            width: 2
                        }

                        Image {
                            source: "assets/Shutdown.svg"
                            anchors {
                                fill: parent
                                leftMargin: 10
                                rightMargin: 10
                                topMargin: 10
                                bottomMargin: 10
                            }
                            sourceSize: Qt.size(80, 80)
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            Item {
                Layout.preferredHeight: 40
            }
        }
    }

    March.ComboBox {
        id: sessionCombo
        width: 200
        height: 28
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 40
        anchors.topMargin: 12

        model: sessionModel
        index: sessionModel.lastIndex

        radius: 12
        font.pixelSize: 14
        bgColor: "#242424"
        hoverColor: Qt.lighter("#2a2a2a", 1.5)
        textColor: "white"
    }

    Component.onCompleted: {
        passField.forceActiveFocus();
    }
}
