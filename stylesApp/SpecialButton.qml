import QtQuick 2.12
import QtQuick.Controls 2.5

Item
{
    enum ButtonType{Add,Search,Print}
    enum PageType{WordGroup,Words}
    enum PrintType{Word,Excel}
    property int sb_typeButton: -1
    property int sb_typePage: -1
    property int sb_typePrint: -1
    property int sb_sizeWidth: sizeWindow/14.4
    property int sb_sizeHeight: sizeWindow/14.4
    property int sb_radius: rec.buttonPress ? sb_sizeHeight_max/2 : sb_sizeHeight/2
    property int sb_sizeWidth_max: sizeWindow/2.4
    property int sb_sizeHeight_max:
    {
        switch(sb_typeButton)
        {
        case SpecialButton.ButtonType.Add:
            sb_typePage===SpecialButton.PageType.Words ? sizeWindow/4.3 : sizeWindow/4
            break
        case SpecialButton.ButtonType.Search:
            sizeWindow/6; break
        case SpecialButton.ButtonType.Print:
            sizeWindow/6; break
        default: sizeWindow/6; break
        }
    }
    property int sb_fontSize: sizeWindow/55.38  //13
    readonly property bool sb_buttonPress: rec.buttonPress
    property bool sb_isOpen: true
    property string sb_textWG
    property string sb_textEng
    property string sb_textRus
    property string sb_textSearch
    property bool sb_verbs: false
    //property bool sb_excelError: false
    signal sb_clicked
    signal sb_clickedBack
    signal sb_clickedOk

    id:root
    width:rec.width
    height: rec.height

    Rectangle
    {
        function clickButton()
        {
            if(sb_isOpen)
            {
                rec.buttonPress=rec.buttonPress ? false : true
                rec.color=rec.buttonPress ? /*синий*/ "#3f51b5" : /*серый*/ "#d6d7d7"
            }
            root.sb_clicked()
        }

        function clickEsc()
        {
            buttonPress=buttonPress ? false : true
            rec.color=buttonPress ? /*синий*/ "#3f51b5" : /*серый*/ "#d6d7d7"
            switch(sb_typeButton)
            {
            case SpecialButton.ButtonType.Add:
                editEng.clear()
                editRus.clear()
                editWG.clear()
                editEng.focus=false
                editRus.focus=false
                editWG.focus=false
                break
            case SpecialButton.ButtonType.Search:
                searchEdit.focus=false
                searchEdit.clear()
                break
            case SpecialButton.ButtonType.Print:

                break
            default: console.log("sb_clickedBack(): ButtonType was not selected")
                break
            }
            root.sb_clickedBack()
        }

        function clickOk()
        {
            switch(sb_typeButton)
            {
            case SpecialButton.ButtonType.Add:
                if(sb_typePage===SpecialButton.PageType.Words)
                {
                    if(editEng.text!=="" && editRus.text!=="")
                    {
                        sb_textEng=editEng.text
                        sb_textRus=editRus.text
                        rec.clickButton()
                        editEng.clear()
                        editRus.clear()
                    }
                    else
                    {
                        if(editEng.text===""){editEng.focus=true; return}
                        else{editRus.focus=true; return}
                    }
                }
                else if(sb_typePage===SpecialButton.PageType.WordGroup)
                {
                    if(editWG.text!=="")
                    {
                        sb_verbs=switchVerbs.position
                        sb_textWG=editWG.text
                        rec.clickButton()
                        editWG.clear()
                    }
                    else {editWG.focus=true; return}
                }
                break
            case SpecialButton.ButtonType.Search:
                sb_textSearch=searchEdit.text
                break
            case SpecialButton.ButtonType.Print:
                if (switchPrint.position==0)
                    sb_typePrint=SpecialButton.PrintType.Word
                else
                    sb_typePrint=SpecialButton.PrintType.Excel
                break
            default: console.log("sb_clickedOk(): ButtonType was not selected")
                break
            }
            root.sb_clickedOk()
        }

        property bool buttonPress: false

        id:rec
        width: buttonPress ? sb_sizeWidth_max : sb_sizeWidth
        height: buttonPress ? sb_sizeHeight_max : sb_sizeHeight
        radius: sb_radius
        color:buttonPress ? /*синий*/ "#3f51b5" : /*серый*/ "#d6d7d7"

        Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        Behavior on  radius {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        Behavior on color {ColorAnimation {duration: 300; easing.type: Easing.OutQuad}}

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered:rec.color=rec.buttonPress ?"#3f51b5":"#c9caca"
            onExited:rec.color=rec.buttonPress ?"#3f51b5":"#d6d7d7"
            onClicked: rec.clickButton()
        }

        Text
        {
            id: textIcon
            color: "#4d4d4d"
            font.family: searchFont.name
            anchors {horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter}
            font.pointSize: sb_typeButton!==SpecialButton.ButtonType.Add ? sb_fontSize+2 : sb_fontSize
            text:
            {
                switch(sb_typeButton)
                {
                case SpecialButton.ButtonType.Add:
                    "\uf1cb"; break
                case SpecialButton.ButtonType.Search:
                    "\uf1ee"; break
                case SpecialButton.ButtonType.Print:
                    "\uf1cd"; break
                default: ""; break
                }
            }
            opacity: rec.buttonPress ? 0 : 1
            Behavior on  opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        }

        //**************************ADD**************************\\
        Column
        {
            id: columnAdd
            visible: rec.buttonPress && sb_typeButton===SpecialButton.ButtonType.Add
            opacity: rec.buttonPress ? 1 : 0
            anchors{top: parent.top; topMargin: sizeWindow/36; horizontalCenter: parent.horizontalCenter}
            Behavior on  opacity {NumberAnimation{duration:animDur*5; easing.type: Easing.OutQuad}}

            //*************WORDGROUP*************\\
            Column
            {
                spacing: sizeWindow/77
                visible: rec.buttonPress && sb_typePage===SpecialButton.PageType.WordGroup
                opacity: rec.buttonPress && sb_typePage===SpecialButton.PageType.WordGroup ? 1 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                Behavior on  opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}

                TextField
                {
                    id: editWG
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:sizeWindow/3.6
                    font.pointSize: sb_fontSize
                    placeholderText: qsTr("Название набора...")
                    cursorVisible: true
                    color:"white"
                    horizontalAlignment: Text.AlignHCenter
                    Keys.onReturnPressed: rec.clickOk()
                    Keys.onEnterPressed: rec.clickOk()
                    Keys.onEscapePressed: rec.clickEsc()
                }

                Row
                {
                    Switch{id:switchVerbs}
                    Label
                    {
                        text: "Неправильные глаголы"
                        anchors.verticalCenter : parent.verticalCenter
                        font.pointSize: sizeWindow/65
                        color:"white"
                    }
                }
            }

            //*************WORDS*************\\
            Column
            {
                visible: rec.buttonPress && sb_typePage===SpecialButton.PageType.Words
                opacity: rec.buttonPress && sb_typePage===SpecialButton.PageType.Words ? 1 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                Behavior on  opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}

                TextField
                {
                    id: editEng
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:sizeWindow/3.6
                    font.pointSize: sb_fontSize
                    placeholderText: qsTr("На английском...")
                    cursorVisible: true
                    color:"white"
                    horizontalAlignment: Text.AlignHCenter
                    Keys.onReturnPressed: rec.clickOk()
                    Keys.onEnterPressed: rec.clickOk()
                    Keys.onEscapePressed: rec.clickEsc()

                }

                TextField
                {
                    id: editRus
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:sizeWindow/3.6
                    font.pointSize: sb_fontSize
                    placeholderText: qsTr("На русском...")
                    cursorVisible: true
                    color:"white"
                    horizontalAlignment: Text.AlignHCenter
                    Keys.onReturnPressed: rec.clickOk()
                    Keys.onEnterPressed: rec.clickOk()
                    Keys.onEscapePressed: rec.clickEsc()
                }
            }

            //*************OK AND BACK BUTTONS*************\\
            Row
            {
                id: rowAddBackButtons
                spacing: 50
                anchors.horizontalCenter: parent.horizontalCenter
                YesOrNoButton
                {
                    yn_text:"\uf1b3";
                    yn_fontSize:sb_fontSize*1.6
                    onYn_click: rec.clickOk()
                }
                YesOrNoButton
                {
                    yn_typeButton: YesOrNoButton.ButtonType.No
                    yn_text:"\uf1dd"
                    yn_fontSize: sb_fontSize*1.4
                    onYn_click: rec.clickEsc()
                }
            }
        }

        //**************************SEARCH**************************\\
        Row
        {
            anchors.centerIn: parent
            spacing: 10
            visible: rec.buttonPress && sb_typeButton===SpecialButton.ButtonType.Search
            opacity: rec.buttonPress ? 1 : 0
            Behavior on  opacity {NumberAnimation{duration:animDur*2; easing.type: Easing.OutQuad}}

            //*************BACK*************\\
            YesOrNoButton
            {
                yn_typeButton: YesOrNoButton.ButtonType.No
                yn_text: "\uf1dd"
                yn_fontSize: sb_fontSize*1.3
                onYn_click: rec.clickEsc()
            }

            //*************SEARCH*************\\
            Rectangle
            {
                width: sizeWindow/4.5
                height: sizeWindow/14.4
                color:"#d6d7d7"     //серый
                radius: width/2

                TextField
                {
                    id: searchEdit
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:parent.width-15
                    font.pointSize: sb_fontSize
                    placeholderText: qsTr("Введите слово...")
                    cursorVisible: true
                    horizontalAlignment: Text.AlignHCenter
                    Keys.onReturnPressed: rec.clickOk()
                    Keys.onEscapePressed: rec.clickEsc()
                }
            }

            //*************OK*************\\
            YesOrNoButton
            {
                yn_text: "\uf1ee"
                yn_fontSize: sb_fontSize*1.5
                onYn_click: rec.clickOk()
            }
        }

        //**************************PRINT**************************\\
        Row
        {
            anchors.centerIn: parent
            spacing: sizeWindow/72
            visible: rec.buttonPress /*&& !sb_excelError*/ &&
                     sb_typeButton===SpecialButton.ButtonType.Print
            opacity: rec.buttonPress ? 1 : 0
            Behavior on  opacity {NumberAnimation{duration:animDur*2; easing.type: Easing.OutQuad}}

            YesOrNoButton
            {
                yn_typeButton: YesOrNoButton.ButtonType.No
                yn_text: "\uf1dd"
                yn_fontSize: sb_fontSize*1.2
                onYn_click: rec.clickEsc()
            }
            Label
            {
                text: "Список"
                color: "white"
                font.pixelSize: sb_fontSize
            }

            Switch
            {
                id:switchPrint
            }

            Label
            {
                text: "Таблица"
                color: "white"
                font.pixelSize: sb_fontSize
            }

            YesOrNoButton
            {
                yn_text: "\uf1cd"
                yn_fontSize: sb_fontSize*1.4
                onYn_click: rec.clickOk()
            }
        }

        /*Label
        {
            id:labelSuccess
            anchors.centerIn: parent
            visible:false
            opacity: 0
            color:"white"
            text: "Успешно!"
            font.pixelSize: sb_fontSize
            Behavior on  opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        }*/
    }
}
