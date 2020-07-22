import QtQuick 2.12
import QtQuick.Controls 2.5
import "./stylesApp"
import "./delegates"

Item
{
    id:test
    width: window.width
    height: window.height

    Row
    {
        spacing: 50

        Column
        {
            spacing: 10
            SpecialButton
            {
                sb_typeButton: SpecialButton.ButtonType.Add
                sb_typePage: SpecialButton.PageType.Words
                onSb_clickedOk: console.log("Word is added")
            }
            SpecialButton
            {
                sb_typeButton: SpecialButton.ButtonType.Add
                sb_typePage: SpecialButton.PageType.WordGroup
                onSb_clickedOk:
                {
                    if (sb_verbs)
                        console.log("Wordgroup (verbs) is added")
                    else
                        console.log("Wordgroup is added")
                }
            }
            SpecialButton
            {
                sb_typeButton: SpecialButton.ButtonType.Search
                onSb_clickedOk: console.log("Search is pressed")
            }
            SpecialButton
            {
                id:printBtn
                sb_typeButton: SpecialButton.ButtonType.Print
                onSb_clickedOk:
                {
                    if(sb_typePrint===SpecialButton.PrintType.Word)
                        console.log("Word is printed")
                    else
                        console.log("Excel is printed")
                }
                Label
                {
                    id:excel
                    anchors.centerIn: parent
                    visible:false
                    opacity: 0
                    color:"white"
                    font.pixelSize: printBtn.sb_fontSize
                    Behavior on  opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
                }
            }

        }
        Column
        {
            SpecialButton
            {
                id:btn
                sb_sizeHeight: 100
                sb_sizeWidth: 200
                sb_isOpen: false
                sb_radius: 0
                onSb_clicked: console.log("Button isNotOpen was clicked")
                Text {
                    anchors.centerIn: parent
                    text: qsTr("isNotOpen")
                    font.pixelSize: btn.sb_fontSize
                }
            }
            SpecialButton
            {
                id:btn1
                sb_sizeHeight: 100
                sb_sizeWidth: 100
                sb_sizeHeight_max: 200
                sb_sizeWidth_max: 300

                onSb_clicked: console.log("Button isOpen was clicked")
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: btn1.sb_fontSize
                    text: btn1.sb_buttonPress ? "Open!!!" : "isOpen..."
                    color: btn1.sb_buttonPress ? "White" : "Black"
                }
            }
        }
    }

        /*SpecialButton
        {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 10
            sb_typeButton: SpecialButton.ButtonType.Add
            sb_typePage: SpecialButton.PageType.Words
        }

        SpecialButton
        {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 250
            sb_typeButton: SpecialButton.ButtonType.Search
        }

        SpecialButton
        {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 400
            sb_typeButton: SpecialButton.ButtonType.Print
        }

        SpecialButton
        {
            id:btn
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 300
            sb_size: 100
            sb_sizeHeight_max: 200
            sb_sizeWidth_max: 300
            sb_isOpen: false
        }

        SpecialButton
        {
            id:btn1
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 300
            anchors.topMargin: 300
            sb_size: 100
            sb_sizeHeight_max: 200
            sb_sizeWidth_max: 300
            sb_isOpen: true

            Text {
                anchors.centerIn: parent
                visible: btn.sb_buttonPress
                text: qsTr("No typeButton")
            }
        }*/




    /*ListView
    {
        id:listIrregular
        //anchors{right:parent.right; rightMargin: anchorsList}
        anchors.left: parent.left
        Behavior on  anchors.rightMargin {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        width:sizeWindow/1.8
        height: parent.height
        model: modelIrregularVerbs
        //delegate: DelegateWG{}
        delegate: Delegates_fc{dfc_containerType: Delegates_fc.ContainerType.IrregularVerbs}
    }*/

    /*ListView
    {
        id:wordddd
        //anchors{right:parent.right; rightMargin: anchorsList}
        anchors.left: parent.left
        Behavior on  anchors.rightMargin {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        width:sizeWindow/1.8
        height: parent.height
        model: modelWords
        //delegate: DelegateWG{}
        delegate: Delegates_fc{dfc_containerType: Delegates_fc.ContainerType.Words}
    }*/

    /*Column
    {
        ContainerDelegate
        {
            con_typeContainer: ContainerDelegate.ContainerType.Words
            con_textName: "word"
            con_textRussian: "слово"
            //con_visibleVerbs: true
            con_modelProgress: 2
            //con_textDeletePressed: con_textName
        }
        ContainerDelegate
        {
            con_typeContainer: ContainerDelegate.ContainerType.WordGroup
            con_visibleVerbs: true
            con_textName: "Набор Глаголы"
            con_textCountOfWords: "Всего слов - 5"
            con_modelProgress: 4
            //con_textDeletePressed: con_textName
            //con_lastRepeat: "2020.05.20 08:52:25"
        }
        ContainerDelegate
        {
            con_typeContainer: ContainerDelegate.ContainerType.Search
            con_textName: "think"
            con_textRussian: "думать"
            con_text2form: "thought"
            con_text3form: "thought"
            con_modelProgress: 3
            con_textNameWG: "Какой то набор"
            con_visibleVerbs: true
        }

        ContainerDelegate
        {
            con_typeContainer: ContainerDelegate.ContainerType.Words
            con_textName: "drink"
            con_textRussian: "пить"
            con_text2form: "drank"
            con_text2form_add: "drank-2"
            con_text3form: "drunk"
            con_text3form_add: "drunk-3"
            con_visibleVerbs: true
            con_modelProgress: 3
        }

        ContainerDelegate
        {
            con_typeContainer: ContainerDelegate.ContainerType.Words
            con_textName: "drink"
            con_textRussian: "пить"
            con_text2form: "drank"
            con_text2form_add: "drank-2"
            con_text3form: "drunk"
            //con_text3form_add: "drunk-3"
            con_visibleVerbs: true
            con_modelProgress: 3
        }

        ContainerDelegate
        {
            con_typeContainer: ContainerDelegate.ContainerType.Words
            con_textName: "drink"
            con_textRussian: "пить"
            con_text2form: "drank"
            con_text2form_add: "drank-2"
            con_text3form: "drunk"
            con_text3form_add: "drunk-3"
            con_visibleVerbs: true
            //con_modelProgress: 3
        }

        ContainerDelegate
        {
            con_typeContainer: ContainerDelegate.ContainerType.Words
            con_textName: "drink"
            con_textRussian: "пить"
            con_text2form: "drank"
            //con_text2form_add: "drank-2"
            con_text3form: "drunk"
            //con_text3form_add: "drunk-3"
            con_visibleVerbs: true
            //con_modelProgress: 3
        }

        YesOrNoButton
        {
            id:btn
            yn_typeButton: YesOrNoButton.ButtonType.Yes
            yn_typeContainer: YesOrNoButton.ContainerType.WordGroup
        }

        YesOrNoButton
        {
            id:btn1
            yn_typeButton: YesOrNoButton.ButtonType.Yes
            yn_text:  "bla"
            yn_fontSize: 40
        }
    }*/
}
