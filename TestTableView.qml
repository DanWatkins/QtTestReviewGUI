import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtTestReviewGUI 1.0

TableView {
    id: tableView

    TableViewColumn {
        role: "status"
        title: "Status"
        width: 120
        movable: false
    }

    TableViewColumn {
        role: "className"
        title: "Class"
        width: 120
        movable: false
    }

    TableViewColumn {
        role: "testName"
        title: "Name"
        width: 120
        movable: false
    }

    TableViewColumn {
        role: "message"
        title: "Message"
        width: 120
        movable: false
    }

    TableViewColumn {
        role: "filePath"
        title: "File"
        width: 120
        movable: false
    }

    TableViewColumn {
        role: "fileLineNumber"
        title: "Line Number"
        width: 120
        movable: false
    }

    sortIndicatorVisible: true

    onSortIndicatorColumnChanged: {
        model.sort(sortIndicatorColumn, sortIndicatorOrder)
    }

    onSortIndicatorOrderChanged: {
        model.sort(sortIndicatorColumn, sortIndicatorOrder)
    }

    function gotoSourceFile() {
        model.gotoSourceFileForRow(currentRow)
    }

    Menu {
        id: contextMenu
        property int row: 0

        MenuItem {
            text: qsTr("Go to source...")

            onTriggered: {
                gotoSourceFile()
            }
        }
    }

    rowDelegate: Item {
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            height: parent.height
            color: styleData.selected ? 'lightblue' : 'white'

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                propagateComposedEvents: true

                signal rightClick()

                function adaptToSelection(mouse) {
                    mouse.accepted = false
                    tableView.selection.deselect(0, tableView.rowCount-1)
                    tableView.selection.select(styleData.row)
                    tableView.currentRow = styleData.row
                }

                onReleased: {
                    adaptToSelection(mouse)

                    if (mouse.button == Qt.RightButton) {
                        contextMenu.row =  styleData.row
                        contextMenu.popup()
                    }
                }

                onDoubleClicked: {
                    adaptToSelection(mouse)

                    if (mouse.button == Qt.LeftButton) {
                        gotoSourceFile()
                    }
                }
            }
        }
    }
}
