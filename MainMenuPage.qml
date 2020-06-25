import QtQuick 2.12
import QtQuick.Controls 2.5
import "./delegates"

Item
{
    width: window.width
    height: window.height

    //модель-представление лист, состоящий из делегатов
    //делегат MenuDelegate
    ListModel
    {
        id:pageModel
        ListElement
        {
            title:"Тестирование"
            page: "TestPage.qml"
        }
        ListElement
        {
            title:"Редактор слов"
            page: "EditorPage.qml"
        }
        ListElement
        {
            title:"Сменить пользователя"
        }
        ListElement
        {
            title:"Выход"
        }
    }
    ListView
    {
        model: pageModel  
        width: parent.width
        height: parent.height
        anchors{top: parent.top; topMargin: 100; horizontalCenter: parent.horizontalCenter}

        Behavior on height {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
        Behavior on width {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
        Behavior on anchors.topMargin {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}

        delegate: Delegate_fm
        {
            text:title
            onClicked: stackView.push(Qt.resolvedUrl(page))
        }
    }
}
