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
        if (addBtn.sb_buttonPress||searchBtn.sb_buttonPress)
            window.width/2  //200
        else
            window.width/4  //200
    }

    /*Delegates_fc
    {
        id: delegateWG
        dfc_containerType: Delegates_fc.ContainerType.WordGroup
    }

    Delegates_fc
    {
        id: delegateSearch
        dfc_containerType: Delegates_fc.ContainerType.Search
    }*/

    //наборы слов*****************************************************************************
    ListView
    {
        id:listViewWG
        anchors{right:parent.right; rightMargin: anchorsList}
        Behavior on  anchors.rightMargin {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        width:sizeWindow/1.8
        height: parent.height
        model: modelWG
        delegate: Delegates_fc{dfc_containerType: Delegates_fc.ContainerType.WordGroup}
    }

    ListView
    {
        id:listViewSearch
        visible: false
        anchors{right:parent.right; rightMargin: anchorsList}
        Behavior on  anchors.rightMargin {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        width:sizeWindow/1.8
        height: parent.height
        model: modelSearch
        delegate: Delegates_fc{dfc_containerType: Delegates_fc.ContainerType.Search}
    }

    //**************************ADD**************************\\
    SpecialButton
    {
        id: addBtn
        sb_typeButton: SpecialButton.ButtonType.Add
        sb_typePage: SpecialButton.PageType.WordGroup
        anchors{right:parent.right; bottom: parent.bottom
            rightMargin: 15; bottomMargin: 5}
        onSb_clickedOk:
        {
            if (sb_verbs)
            {
                console.log("Wordgroup (verbs) is added")
                db.query_exec("insert into WordGroup (name, userid, verbs) values
                ('"+sb_textWG+"',"+AppCore.ac_GetID()+",true);");
            }
            else
            {
                console.log("Wordgroup is added")
                db.query_exec("insert into WordGroup (name,
                userid) values ('"+sb_textWG+"',"+AppCore.ac_GetID()+");");
            }
            AppCore.ac_createModelWG();
        }
    }

    //**************************SEARCH**************************\\
    SpecialButton
    {
        id: searchBtn
        anchors{right:parent.right; bottom: addBtn.top; rightMargin: 15; bottomMargin: 10}
        sb_typeButton: SpecialButton.ButtonType.Search
        sb_typePage: SpecialButton.PageType.WordGroup
        onSb_clickedOk:
        {
            AppCore.ac_createModelSearch(sb_textSearch)
            listViewWG.visible=false
            listViewSearch.visible=true
            /*listViewWG.model=modelSearch
            listViewWG.delegate=delegateSearch*/
        }
        onSb_clickedBack:
        {
            /*listViewWG.model=modelWG
            listViewWG.delegate=delegateWG*/
            listViewWG.visible=true
            listViewSearch.visible=false
        }
    }
}
