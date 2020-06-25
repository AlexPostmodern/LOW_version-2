import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    id: enterPage
    width: window.width
    height: window.height

    //размеры шрифтов
    property int littleSize:sizeWindow/48       //15
    property int tinySize: sizeWindow/55.38     //13

    //размеры лейблов и текст филдов
    property int widthTextField: sizeWindow/4.8 //150
    property int heightTextField: sizeWindow/16 //45
    property int widthLabel: sizeWindow/7.2     //100
    property int heightLabel: sizeWindow/18     //40

    //лейауты, изменяются при изменении размера окна
    Column
    {
        anchors{horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 50}
        spacing: sizeWindow/7.2     //100

        Behavior on  spacing {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}

        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: sizeWindow/72     //10

            Behavior on  anchors.bottomMargin {AnchorAnimation{duration:animDur; easing.type: Easing.OutQuad}}
            Behavior on  spacing {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}


            //ЛОГИН***************************************************************************
            Row
            {
                id:rowLog
                anchors.horizontalCenter: parent.horizontalCenter
                Label
                {
                    id: loginText
                    height:heightLabel  //40
                    width: widthLabel   //100
                    text: qsTr("Логин")
                    font.pointSize: littleSize  //15
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                }
                TextField
                {
                    height: heightTextField   //45
                    width:widthTextField      //150
                    font.pointSize: tinySize  //13
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on  font.pointSize {NumberAnimation{duration:500;easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                    Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
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
                    height: heightLabel //40
                    width:widthLabel    //100
                    text: qsTr("Пароль")
                    font.pointSize: littleSize  //15
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                }

                TextField
                {
                    height: heightTextField
                    width: widthTextField
                    font.pointSize: tinySize
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                    Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                }
            }

            // ПОДТВЕРДИТЕ ПАРОЛЬ*************************************************************
            Row
            {
                id:rowPass2
                anchors.horizontalCenter: parent.horizontalCenter
                Label
                {
                    id: passText2
                    height: heightLabel
                    width:widthLabel
                    text: qsTr("Пароль")
                    font.pointSize: littleSize
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                }
                TextField
                {
                    height:heightTextField
                    width:widthTextField
                    font.pointSize: tinySize
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
                    Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                }
            }

            // ИМЯ****************************************************************************
            Row
            {
                id:rowName
                anchors.horizontalCenter: parent.horizontalCenter
                Label
                {
                    id: nameText
                    height: heightLabel
                    width: widthLabel
                    text: qsTr("Имя")
                    font.pointSize: littleSize
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                }
                TextField
                {
                    height: heightTextField
                    width: widthTextField
                    font.pointSize: tinySize
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on  font.pointSize {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
                    Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                    Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                }
            }
        }

        //КНОПКА******************************************************************************
        Button
        {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Зарегистрировать"
            width: window.width*2/10
            height: (window.height/10)-10

            Behavior on height {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
            Behavior on width {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
        }
    }
}
