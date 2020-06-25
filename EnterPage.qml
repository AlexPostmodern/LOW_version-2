import QtQuick 2.12
import QtQuick.Controls 2.5

Item
{
    id: enterPage
    width: window.width
    height: window.height-toolButton.height

    //размеры кнопок
    property int buttonWidth: sizeWindow/4.5    //160
    property int buttonHeight: sizeWindow/13.1  //55

    //размер шрифта
    property int littleSize: sizeWindow/48      //15
    property int tinySize: sizeWindow/53.4      //13

    //нажатие на кнопку "Войти" или Enter
    function clickedEnter()
    {
        switch(AppCore.ac_enterInProgram(textFieldLogin.text,textFieldPass.text,checkboxRemember.checkState))
        {
            case 0:
                stackView.push(mainMenu)
                toolButton.opacity=0
                enterORmenu=false
                seqEnter.running=true
                headerText.text="Главное меню"
                textFieldLogin.clear()
                textFieldPass.clear()
                recPhoto.opacity=1
                loginHead.text= AppCore.ac_GetLogin()
                loginHead.opacity=1
                break;
            case 1:
                wrongLogOrPass.text="Неправильный пароль"
                wrongLogAnimation.running=true
                break;
            case 2:
                wrongLogOrPass.text="Такого логина не существует"
                wrongLogAnimation.running=true
                break;
        }
    }

    //лейауты, изменяются при изменении размера окна
    Column
    {
        anchors{horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter}
        spacing: 55
        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            //ЛОГИН***************************************************************************
            Row
            {
                id:rowLog
                anchors.horizontalCenter: parent.horizontalCenter
                Label
                {
                    id: loginText
                    height:40
                    width:sizeWindow/7.2    //100
                    text: qsTr("Логин")

                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}

                    font.pointSize: littleSize
                    horizontalAlignment: Text.AlignHCenter
                }
                TextField
                {
                    id:textFieldLogin
                    height: sizeWindow/16   //45
                    width: sizeWindow/4.8   //150

                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                    Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}

                    font.pointSize: tinySize   //13
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            //ПАРОЛЬ**************************************************************************
            Row
            {
                id:rowPass
                anchors.horizontalCenter: parent.horizontalCenter
                Label
                {
                    id: passText
                    height:40
                    width:sizeWindow/7.2    //100
                    text: qsTr("Пароль")

                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}

                    font.pointSize: littleSize   //15
                    horizontalAlignment: Text.AlignHCenter
                }
                TextField
                {
                    id:textFieldPass
                    height: sizeWindow/16   //45
                    width: sizeWindow/4.8   //150

                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                    Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}

                    font.pointSize: tinySize   //13
                    horizontalAlignment: Text.AlignHCenter
                    Keys.onReturnPressed:
                    {
                        clickedEnter()
                    }
                }
            }

            CheckBox
            {
                id:checkboxRemember
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Запомнить пользователя"
                checked: true
            }
        }

        //КНОПКИ******************************************************************************
        Column
        {
            id: colButtons
            anchors.horizontalCenter: parent.horizontalCenter

            Button
            {
                id:enterButton
                text: "Войти"
                height:buttonHeight
                width:buttonWidth

                Behavior on width {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
                Behavior on height {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}

                onClicked: clickedEnter()
            }

            SequentialAnimation
            {
                id: wrongLogAnimation
                NumberAnimation {
                    target: wrongLogOrPass
                    properties: "opacity"
                    from:0
                    to: 1
                    duration: 2500
                }
                NumberAnimation {
                    target: wrongLogOrPass
                    properties: "opacity"
                    from:1
                    to: 0
                    duration: 2500
                }
            }

            Button
            {
                text: "Регистрация"
                width:buttonWidth
                height:buttonHeight

                Behavior on width {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
                Behavior on height {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}

                onClicked:
                {
                    stackView.push(reg)
                    visibleButton=true
                    toolButton.visible=true
                    toolButton.opacity=1
                    headerText.text="Регистрация"
                }
            }
        }

        Label
        {
            id: wrongLogOrPass
            anchors.horizontalCenter: parent.horizontalCenter
            height:40
            width: sizeWindow/7.2    //100
            color:"white"
            opacity: 0
            font.pointSize: littleSize   //15
            horizontalAlignment: Text.AlignHCenter

            Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
            Behavior on  opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
            Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        }
    }
}
