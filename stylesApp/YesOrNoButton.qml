import QtQuick 2.12

Item {

    property int yn_size:sizeWindow/14.4                        //50 (размер)
    property string yn_text: "Да"                               //текст кнопки
    property  int yn_fontSize: sizeWindow/48                    //15 (размер шрифта)
    property string yn_fontFamily: "MS Shell Dlg 2"             //шрифт
    enum ButtonType{Yes,No}                                     //типы кнопок
    enum ContainerType{Words,WordGroup,Search,IrregularVerbs}   //типы контейнеров

    property int yn_typeButton: YesOrNoButton.ButtonType.Yes    //тип кнопки
    property int yn_typeContainer:-1                            //тип контейнера

    signal yn_click                                             //сигнала нажатия на кнопку

    id:root
    width: yn_size
    height: yn_size

    Rectangle
    {
        id:btn
        anchors.fill: parent
        radius: yn_size/2
        color: "transparent"
        Behavior on  opacity {NumberAnimation{duration:1000; easing.type: Easing.OutQuad}}

        Text
        {
            function setAnchors()                                   //задает стандартное положение текста
            {                                                       //в зависимости от типa контейнера
                if (yn_typeButton===YesOrNoButton.ButtonType.Yes)
                {
                    switch(yn_typeContainer)
                    {
                    case YesOrNoButton.ContainerType.Words:
                        text.anchors.centerIn=btn
                        break
                    case YesOrNoButton.ContainerType.WordGroup:
                        text.anchors.top=btn.top;
                        text.anchors.topMargin= -(sizeWindow/240)    //-3
                        text.anchors.left= btn.left;
                        text.anchors.leftMargin= sizeWindow/43.35    //17
                        break
                    case YesOrNoButton.ContainerType.Search:
                        text.anchors.centerIn=btn
                        break
                    case YesOrNoButton.ContainerType.IrregularVerbs:
                        text.anchors.centerIn=btn
                        break
                    default:
                        text.anchors.centerIn=btn
                        break
                    }
                }
                else
                    text.anchors.centerIn=btn
                return yn_typeContainer
            }

            id: text
            property int settingAnchors: setAnchors()
            font.family:yn_fontFamily
            text:
            {
                switch(yn_typeContainer)
                {
                case YesOrNoButton.ContainerType.Words:
                    "\uf148"
                    break
                case YesOrNoButton.ContainerType.WordGroup:
                    "\u25B9"
                    break
                case YesOrNoButton.ContainerType.Search:
                    "\uf148"
                    break
                case YesOrNoButton.ContainerType.IrregularVerbs:
                    "\uf1cb"
                    break
                default:
                    yn_text
                    break
                }
            }
            color: "white"
            font.pixelSize:
            {
                if (yn_typeButton===YesOrNoButton.ButtonType.Yes)
                {
                    switch(yn_typeContainer)
                    {
                    case YesOrNoButton.ContainerType.Words:
                        sizeWindow/48                   //15
                        break
                    case YesOrNoButton.ContainerType.WordGroup:
                        sizeWindow/16                   //45
                        break
                    case YesOrNoButton.ContainerType.Search:
                        sizeWindow/48                   //15
                        break
                    case YesOrNoButton.ContainerType.IrregularVerbs:
                        sizeWindow/48                   //15
                        break
                    default:
                        yn_fontSize
                        break
                    }
                }

                else
                    yn_fontSize
            }
        }
        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered:
            {
                text.color= yn_typeButton===YesOrNoButton.ButtonType.Yes ? "#60b66e" : "#cd4678"
                parent.color= "#3b4caa"
            }
            onExited:
            {
                text.color= "white"
                parent.color= "transparent"
            }
            onClicked:
            {
                root.yn_click()
            }
        }
    }
}
