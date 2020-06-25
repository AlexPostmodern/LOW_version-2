import QtQuick 2.12
import QtQuick.Controls 2.5
import "./delegates"
import "./stylesApp"

Item
{
    id:editorPage
    width: window.width
    height: window.height-toolButton.height-10
    property int anchorsList:
    {
        if (addBtn.sb_buttonPress||searchBtn.sb_buttonPress||printBtn.sb_buttonPress)
            window.width/2  //200
        else
            window.width/4  //200
    }
    //наборы слов*****************************************************************************
    ListView
    {
        id:listViewWG
        anchors{right:parent.right; rightMargin: anchorsList}
        Behavior on  anchors.rightMargin {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        width:sizeWindow/1.8
        height: parent.height
        model: modelWords
        delegate:Delegates_fc{dfc_containerType: Delegates_fc.ContainerType.Words}
    }

    ListView
    {
        id:listIverbs
        Behavior on  anchors.rightMargin {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        anchors{right:parent.right}
        visible: addBtn.sb_buttonPress && irVerbsWG
        opacity: addBtn.sb_buttonPress && irVerbsWG ? 1 : 0
        Behavior on  opacity {NumberAnimation{duration:animDur*2; easing.type: Easing.OutQuad}}
        width:sizeWindow/1.8
        height: 320
        model: modelIrregularVerbs
        delegate:Delegates_fc{dfc_containerType: Delegates_fc.ContainerType.IrregularVerbs}
    }

    //**************************ADD**************************\\
    SpecialButton
    {
        id: addBtn
        sb_typeButton: SpecialButton.ButtonType.Add
        sb_typePage: SpecialButton.PageType.Words
        anchors{right:parent.right; bottom: parent.bottom
            rightMargin: 15; bottomMargin: 5}
        onSb_clickedOk:
        {
            db.query_exec("insert into Words (russian, english, wordid)
                            values ('"+sb_textRus+"','"+sb_textEng+"',"+idWG+");");
            AppCore.ac_createModelWords(idWG);
        }
    }

    //**************************SEARCH**************************\\
    SpecialButton
    {
        id: searchBtn
        sb_typeButton: SpecialButton.ButtonType.Search
        sb_typePage: SpecialButton.PageType.Words
        anchors{right:parent.right; bottom: addBtn.top
            rightMargin: 15; bottomMargin: 10}
        onSb_clickedOk:
        {
            AppCore.ac_modelQuery("modelWords","select * from Words where (wordid="+idWG+" and
            (russian like '"+sb_textSearch+"%' or english like '"+sb_textSearch+"%'));")
        }
        onSb_clickedBack: AppCore.ac_createModelWords(idWG)
    }

    //**************************PRINT**************************\\
    SpecialButton
    {
        id:printBtn
        sb_typeButton: SpecialButton.ButtonType.Print
        anchors{right:parent.right; bottom: searchBtn.top
            rightMargin: 15; bottomMargin: 10}
        property bool error: false

        /*onSb_clickedOk:
        {
            labelTest.opacity=0
            if(sb_typePrint===SpecialButton.PrintType.Word)
            {
                if(!AppCore.ac_print_word_WG(idWG))
                {
                    error=true
                    labelError.text="Кажется, у вас не установлен MS Office Word"
                    labelError.visible=true
                    labelError.opacity=1
                }
            }
            else
                if(!AppCore.ac_print_excel_WG(idWG))
                {
                    error=true
                    labelError.text="Кажется, у вас не установлен MS Office Word"
                    labelError.visible=true
                    labelError.opacity=1
                }
        }*/

        onSb_clickedOk:{
            if(sb_typePrint===SpecialButton.PrintType.Word)
                AppCore.ac_print_word_WG(idWG)
            else
                AppCore.ac_print_excel_WG(idWG)
        }
    }
}

