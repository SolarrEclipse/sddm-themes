import QtQuick 2.15

FocusScope {
    id: root
    width: 80
    height: 30

    property color bgColor: "#242424"
    property color textColor: "white"
    property color hoverColor: "#5692c4"
    property int radius: 12
    property int gap: 4
    property font font
    property alias model: listView.model
    property int index: 0
    property string displayText: ""

    signal valueChanged(int id)

    onFocusChanged: if (!root.activeFocus)
        close()

    Rectangle {
        id: buttonShadow
        x: button.x + 3
        y: button.y + 3
        width: button.width
        height: button.height
        radius: root.radius
        color: Qt.rgba(0, 0, 0, 0.5)
    }

    Rectangle {
        id: button
        anchors.fill: parent
        radius: root.radius
        color: root.bgColor
        border {
            color: mouseArea.containsMouse ? root.hoverColor : root.bgColor
        }

        Behavior on border.color {
            ColorAnimation {
                duration: 100
            }
        }

        Text {
            id: label
            anchors.left: parent.left
            anchors.right: arrow.left
            anchors.leftMargin: 12
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            color: root.textColor
            font: root.font
            elide: Text.ElideRight
            text: root.displayText
        }

        Image {
            id: arrow
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 14
            height: 14
            source: dropDown.height > 0 ? "../assets/ArrowUp.svg" : "../assets/ArrowDown.svg"
            sourceSize: Qt.size(28, 28)
            fillMode: Image.PreserveAspectFit
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: button
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.focus = true;
            toggle();
        }
        onWheel: {
            if (wheel.angleDelta.y > 0)
                listView.decrementCurrentIndex();
            else
                listView.incrementCurrentIndex();
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Down || event.key === Qt.Key_Up) {
            event.key === Qt.Key_Down ? listView.incrementCurrentIndex() : listView.decrementCurrentIndex();
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            close(true);
        } else if (event.key === Qt.Key_Escape) {
            close(false);
        }
    }

    Rectangle {
        id: dropShadow
        width: dropDown.width
        height: dropDown.height
        anchors.top: dropDown.top
        anchors.left: dropDown.left
        anchors.topMargin: root.gap
        anchors.leftMargin: 6
        radius: root.radius
        color: Qt.rgba(0, 0, 0, 0.5)
        visible: dropDown.visible
    }

    Rectangle {
        id: dropDown
        anchors.horizontalCenter: button.horizontalCenter
        width: 260
        height: 0
        anchors.top: button.bottom
        anchors.topMargin: root.gap
        radius: 12
        color: root.bgColor
        visible: height > 0

        border.color: dropDownMouseArea.containsMouse ? root.hoverColor : root.bgColor

        Behavior on border.color { ColorAnimation { duration: 100 } }

        Behavior on height {
            NumberAnimation {
                duration: 0
            }
        }

        MouseArea {
            id: dropDownMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                var idx = Math.floor(mouse.y / root.height);
                if (idx >= 0 && idx < listView.count) {
                    listView.currentIndex = idx;
                    close(true);
                }
            }
        }

        ListView {
            id: listView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Math.min(contentHeight, root.height * 8)
            interactive: false

            onCurrentItemChanged: {
                if (listView.currentItem && listView.currentItem.itemData && listView.currentItem.itemData.name)
                    root.displayText = listView.currentItem.itemData.name;
            }

            delegate: Item {
                width: parent.width
                height: root.height
                property var itemData: model

                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.textColor
                    font: root.font
                    elide: Text.ElideRight
                    text: model.name
                }
            }
        }
    }

    function toggle() {
        if (dropDown.height > 0)
            close(false);
        else
            open();
    }

    function open() {
        dropDown.height = Math.min(listView.contentHeight, root.height * 8);
        listView.currentIndex = root.index;
    }

    function close(update) {
        if (update) {
            root.index = listView.currentIndex;
            valueChanged(listView.currentIndex);
            if (listView.currentItem && listView.currentItem.itemData && listView.currentItem.itemData.name)
                root.displayText = listView.currentItem.itemData.name;
        }
        dropDown.height = 0;
    }

    Component.onCompleted: {
        listView.currentIndex = root.index;
        if (listView.currentItem && listView.currentItem.itemData && listView.currentItem.itemData.name)
            root.displayText = listView.currentItem.itemData.name;
    }

    onIndexChanged: {
        listView.currentIndex = root.index;
    }
}
