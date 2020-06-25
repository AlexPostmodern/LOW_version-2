import QtQuick 2.12
import QtQuick.Controls 2.5

//делегат для главного меню
Item
{
    id: root
    width: parent.width
    height: window.height/9
    Behavior on height {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}

    //текст кнопок
    property alias text: button.text
    signal clicked

    Button
    {
        id: button
        text: modelData
        anchors.horizontalCenter: parent.horizontalCenter
        width: window.width*2/8
        height: (window.height-10)/10

        Behavior on height {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
        Behavior on opacity {NumberAnimation{duration:1500; easing.type: Easing.OutCubic}}
        Behavior on width {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}

        onClicked:
            if (text=="Сменить пользователя")
            {
                stackView.pop()
                AppCore.ac_changeUser()
                headerText.text=qsTr("Авторизация")
                enterORmenu=true
                seqEnter.running=true
                loginHead.opacity=0
                recPhoto.opacity=0
            }
            else if(text=="Выход")
            {
                Qt.quit()
            }
            else if(text=="Редактор слов")
            {
                AppCore.ac_createModelWG()
                AppCore.ac_createModelSearch("g")
                console.log("button "+text+" was clicked")
                visibleButton=true
                toolButton.visible=true
                toolButton.opacity=1
                headerText.text=text
                root.clicked()
            }
            else
            {
                console.log("button "+text+" was clicked")
                //AppCore.ac_modelQuery(modelIrregularVerbs,"select * from IrregularVerbs")
                AppCore.ac_createModelIrregularVerbs()
                visibleButton=true
                toolButton.visible=true
                toolButton.opacity=1
                headerText.text=text
                root.clicked()
            }
    }
}

