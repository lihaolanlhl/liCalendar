import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import org.licomm.calendar 1.0
import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick 2.6
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import org.licomm.calendar 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Material 2.1
import QtQml 2.2

ApplicationWindow {
    id:mainwindow
    visible: true
    width: 640
    height: 480
    title: qsTr("liCalendar")

    Item {
        anchors.fill:parent
        SystemPalette {
            id: systemPalette
        }

        SqlEventModel {
            id: eventModel
        }

        Flow {
            id: row
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            layoutDirection: Qt.RightToLeft

            Calendar {
                id: calendar
                width: (parent.width > parent.height ? parent.width * 0.6 - parent.spacing : parent.width)
                height: (parent.height > parent.width ? parent.height * 0.6 - parent.spacing : parent.height)
                navigationBarVisible: true
                frameVisible: true
                weekNumbersVisible: true
                focus: true
                onDoubleClicked: aapopup.open()

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "transparent"
                    anchors.bottom: parent.bottom
                    border.color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                    border.width: 2
                }



                style: CalendarStyle {
                    gridVisible: false
                    dayDelegate: Item {
                        readonly property color sameMonthDateTextColor: "#444"
                        readonly property color selectedDateColor: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        readonly property color selectedDateTextColor: "white"
                        readonly property color differentMonthDateTextColor: "#bbb"
                        readonly property color invalidDatecolor: "#dddddd"

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: Math.min(parent.width,parent.height) * 0.9
                            height: width
                            border.color: "transparent"
                            color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                            radius: width*0.5
                        }

                        Rectangle {
                            visible: styleData.today
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: Math.min(parent.width,parent.height) * 0.9
                            height: width
                            color: "transparent"
                            border.color: selectedDateColor
                            border.width: Math.min(parent.width,parent.height) * 0.05
                            radius: width*0.5
                        }

                        Rectangle {
                            id: eventCircle
                            visible: eventModel.eventsForDate(styleData.date).length > 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: Math.min(parent.width,parent.height) * 0.9
                            height: width
                            color: "transparent"
                            border.color: Qt.lighter(Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight)
                            border.width: Math.min(parent.width,parent.height) * 0.05
                            radius: width*0.5
                        }

                        Label {
                            id: dayDelegateText
                            text: styleData.date.getDate()
                            anchors.centerIn: parent
                            font.pixelSize: Math.min(parent.width,parent.height) * 0.5
                            color: {
                                var color = invalidDatecolor;
                                if (styleData.valid) {
                                    // Date is within the valid range.
                                    color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                    if (styleData.selected) {
                                        color = selectedDateTextColor;
                                    }
                                }
                                color;
                            }
                        }
                    }
                }
            }

            Component {
                id: eventListHeader

                Row {
                    id: eventDateRow
                    width: parent.width
                    height: eventDayLabel.height + 20
                    spacing: 10

                    Label {
                        id: eventDayLabel
                        text: calendar.selectedDate.getDate()
                        font.pointSize: 35
                        anchors.topMargin: 20
                    }

                    Column {
                        height: eventDayLabel.height

                        Label {
                            readonly property var options: { weekday: "long" }
                            text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                            font.pointSize: 18
                        }
                        Label {
                            text: Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
                                  + calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy")
                            font.pointSize: 12
                        }
                    }
                }
            }

            Rectangle {
                width: (parent.width > parent.height ? parent.width * 0.4 - parent.spacing : parent.width)
                height: (parent.height > parent.width ? parent.height * 0.4 - parent.spacing : parent.height)
    //            border.color: Qt.darker(color, 1.2)
                border.color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                border.width: 2

                ListView {
                    id: eventsListView
                    spacing: 4
                    clip: true
                    header: eventListHeader
                    anchors.fill: parent
                    anchors.margins: 10
                    model: eventModel.eventsForDate(calendar.selectedDate)

                    delegate: Rectangle {
                        width: eventsListView.width
                        height: eventItemColumn.height
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            anchors.top: parent.top
                            anchors.topMargin: 4
                            width: 12
                            height: width
                            source: "qrc:/images/eventindicator.png"
                        }

                        Rectangle {
                            width: parent.width
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }

                        Column {
                            id: eventItemColumn
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.topMargin: 6
                            height: timeLabel.height + nameLabel.height + 8

                            Label {
                                id: nameLabel
                                width: parent.width
                                wrapMode: Text.Wrap
                                text: modelData.name
                            }
                            Label {
                                id: timeLabel
                                width: parent.width
                                wrapMode: Text.Wrap
                                text: modelData.startDate.toLocaleTimeString(calendar.locale, Locale.ShortFormat)
                                color: "#aaa"
                            }
                        }
                    }
                }
            }
        }

        RoundButton{
            id:addactivity
            x: 30
            y: parent.height - 80
            width: 60
            height: 60
            highlighted: true
            onClicked: menu.visible ? menu.close() : menu.open()

            Image {
                id: addimage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width /2
                height: parent.height /2
                source: "qrc:/images/ic_add_white_24px.svg"
            }

            Menu {
                id: menu
                y: - menu.height
                MenuItem {
                    text: qsTr("添加活动事项...")
                    onClicked: aapopup.open()
                }
                MenuItem {
                    text: qsTr("设置")
                }
                MenuItem {
                    text: qsTr("关于")
                    onClicked:aboutpopup.open()
                }

                MenuSeparator {
                    padding: 0
                    topPadding: 12
                    bottomPadding: 12
                    contentItem: Rectangle {
                        implicitWidth: 200
                        implicitHeight: 1
                        color: "#1E000000"
                    }
                }

                MenuItem {
                    id:doexit
                    text: qsTr("退出")
                    onClicked: mainwindow.close()
                }
            }

        }

        Popup{
            id:aapopup
            modal: true
            focus: true
            width: 375
            x: (parent.width - width)/2
            y: (parent.height - height)/2
            contentItem: Column {
                Label {
                    text: "添加活动事项"
                    font.pointSize: 18
                    width: parent.width
                }

                TextField {
                    id: activityfield
                    width: parent.width
                    placeholderText: qsTr("输入活动事项...")
                }

                Text{
                    text:"开始时间："
                }

                Row{
                    TextField{
                        id: startyearstf
                        width:60
                        placeholderText: qsTr("yyyy")
                        horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                        text:calendar.selectedDate.toLocaleDateString(Qt.locale(),"yyyy")
                        maximumLength: 4
                    }

                    Text{
                        text: "-"
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField{
                        id: startmonthstf
                        width:45
                        placeholderText: qsTr("MM")
                        horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                        text:calendar.selectedDate.toLocaleDateString(Qt.locale(),"MM")
                        maximumLength: 2
                    }

                    Text{
                        text: "-"
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField{
                        id: startdaystf
                        width:45
                        placeholderText: qsTr("dd")
                        horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                        text:calendar.selectedDate.toLocaleDateString(Qt.locale(),"dd")
                        maximumLength: 2
                    }

                    Tumbler {
                        id: starthoursTumbler
                        model: 12
                        visibleItemCount: 3
                        height: 100
                        currentIndex: new Date().toLocaleString(Qt.locale(),"HH") <= 12 ? new Date().toLocaleString(Qt.locale(),"HH") : new Date().toLocaleString(Qt.locale(),"HH") - 12

                        delegate: Text{
                            text:modelData + 1
                            font:starthoursTumbler.font
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            opacity: 1.0 - Math.abs(Tumbler.displacement) / 1.5
                        }

                        Rectangle {
                            anchors.horizontalCenter: starthoursTumbler.horizontalCenter
                            y: starthoursTumbler.height * 0.35
                            width: 30
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }

                        Rectangle {
                            anchors.horizontalCenter: starthoursTumbler.horizontalCenter
                            y: starthoursTumbler.height * 0.65
                            width: 30
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }
                    }

                    Text{
                        text: ":"
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    Tumbler {
                        id: startminutesTumbler
                        model: 60
                        visibleItemCount: 3
                        height: 100
                        currentIndex: new Date().toLocaleString(Qt.locale(),"mm")

                        Rectangle {
                            anchors.horizontalCenter: startminutesTumbler.horizontalCenter
                            y: startminutesTumbler.height * 0.35
                            width: 35
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }

                        Rectangle {
                            anchors.horizontalCenter: startminutesTumbler.horizontalCenter
                            y: startminutesTumbler.height * 0.65
                            width: 35
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }
                    }

                    Tumbler {
                        id: startamPmTumbler
                        model: ["AM", "PM"]
                        visibleItemCount: 3
                        height: 100
                        currentIndex: new Date().toLocaleString(Qt.locale(),"HH") <= 12 ? 0 : 1

                        Rectangle {
                            anchors.horizontalCenter: startamPmTumbler.horizontalCenter
                            y: startamPmTumbler.height * 0.35
                            width: 35
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }

                        Rectangle {
                            anchors.horizontalCenter: startamPmTumbler.horizontalCenter
                            y: startamPmTumbler.height * 0.65
                            width: 35
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }
                    }
                }



                Text{
                    text:"结束时间："
                }

                Row{
                    TextField{
                        id: stopyearstf
                        width: 60
                        placeholderText: qsTr("yyyy")
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text:calendar.selectedDate.toLocaleDateString(Qt.locale(),"yyyy")
                        maximumLength: 4
                    }

                    Text{
                        text: "-"
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField{
                        id: stopmonthstf
                        width:45
                        placeholderText: qsTr("MM")
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text:calendar.selectedDate.toLocaleDateString(Qt.locale(),"MM")
                        maximumLength: 2
                    }

                    Text{
                        text: "-"
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField{
                        id: stopdaystf
                        width:45
                        placeholderText: qsTr("dd")
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text:calendar.selectedDate.toLocaleDateString(Qt.locale(),"dd")
                        maximumLength: 2
                    }

                    Tumbler {
                        id: stophoursTumbler
                        model: 12
                        visibleItemCount: 3
                        height: 100
                        currentIndex: new Date().toLocaleString(Qt.locale(),"HH") <= 12 ? new Date().toLocaleString(Qt.locale(),"HH") : new Date().toLocaleString(Qt.locale(),"HH") - 12

                        delegate: Text{
                            text:modelData + 1
                            font:stophoursTumbler.font
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            opacity: 1.0 - Math.abs(Tumbler.displacement) / 1.5
                        }

                        Rectangle {
                            anchors.horizontalCenter: stophoursTumbler.horizontalCenter
                            y: stophoursTumbler.height * 0.35
                            width: 30
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }

                        Rectangle {
                            anchors.horizontalCenter: stophoursTumbler.horizontalCenter
                            y: stophoursTumbler.height * 0.65
                            width: 30
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }
                    }

                    Text{
                        text: ":"
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    Tumbler {
                        id: stopminutesTumbler
                        model: 60
                        visibleItemCount: 3
                        height: 100
                        currentIndex: new Date().toLocaleString(Qt.locale(),"mm")

                        Rectangle {
                            anchors.horizontalCenter: stopminutesTumbler.horizontalCenter
                            y: stopminutesTumbler.height * 0.35
                            width: 35
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }

                        Rectangle {
                            anchors.horizontalCenter: stopminutesTumbler.horizontalCenter
                            y: stopminutesTumbler.height * 0.65
                            width: 35
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }
                    }

                    Tumbler {
                        id: stopamPmTumbler
                        model: ["AM", "PM"]
                        visibleItemCount: 3
                        height: 100
                        currentIndex: new Date().toLocaleString(Qt.locale(),"HH") <= 12 ? 0 : 1

                        Rectangle {
                            anchors.horizontalCenter: stopamPmTumbler.horizontalCenter
                            y: stopamPmTumbler.height * 0.35
                            width: 35
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }

                        Rectangle {
                            anchors.horizontalCenter: stopamPmTumbler.horizontalCenter
                            y: stopamPmTumbler.height * 0.65
                            width: 35
                            height: 2
                            color: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        }
                    }
                }
                Row {
                    Button{
                        id: confirmaddactivity
                        text: "添加"
                        flat: true
                    }

                    Button{
                        id: canceladdactivity
                        text: "取消"
                        flat: true
                        onClicked: aapopup.close()
                    }
                }
            }
        }

        Popup {
            id:aboutpopup
            width:320
            modal: true
            focus: true
            x: (parent.width - width)/2
            y: (parent.height - height)/2

            contentItem: Column {
                Text {
                    text: qsTr("liCalendar")
                    width: parent.width
                    font.pixelSize: 36
                    x: 15
                }

                Text {
                    width: parent.width
                    text: qsTr("liCalendar,一款基于Qt5的日历软件。")
                    wrapMode: Text.WordWrap
                    font.pixelSize: 24
                    x:15
                }

                Button{
                    text:"确定"
                    flat:true
                    onClicked: aboutpopup.close()
                }
            }
        }

        Connections{
            target: confirmaddactivity
            property var locale: Qt.locale()
            property string startdatestr: startyearstf.text+"-"+startmonthstf.text+"-"+startdaystf.text
            property string starttimestr: (starthoursTumbler.currentIndex + 12 * (startamPmTumbler.currentIndex == 0 ? 0:1) + 1) * 3600 + startminutesTumbler.currentIndex*60
            property string stopdatestr: stopyearstf.text+"-"+stopmonthstf.text+"-"+stopdaystf.text
            property string stoptimestr: (stophoursTumbler.currentIndex + 12 * (stopamPmTumbler.currentIndex == 0 ? 0:1) + 1) * 3600 + stopminutesTumbler.currentIndex*60
            onClicked:activityfield.text != "" ? eventModel.addEvents(activityfield.text
                                              ,startdatestr
                                              ,starttimestr
                                              ,stopdatestr
                                              ,stoptimestr) & aapopup.close() : activityfield.forceActiveFocus()
//            onClicked:print(startdatestr) & print(starttimestr) & print(stopdatestr) & print(stoptimestr)
        }
    }
}


