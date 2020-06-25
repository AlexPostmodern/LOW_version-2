import QtQuick 2.12
import QtQuick.Controls 2.5
import "../stylesApp"

Item
{
    enum ContainerType{Words,WordGroup,Search,IrregularVerbs}
    property int dfc_containerType:-1

    id: root
    width:del.con_width
    height:del.con_height+5
    anchors.horizontalCenter: parent.horizontalCenter
    Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}

    ContainerDelegate
    {
        id:del
        con_typeContainer: dfc_containerType
        con_modelProgress: dfc_containerType===Delegates_fc.ContainerType.IrregularVerbs ? -1 : progress
        con_lastRepeat: dfc_containerType===Delegates_fc.ContainerType.WordGroup ? lastRepeat : ""
        con_visibleVerbs: dfc_containerType===Delegates_fc.ContainerType.IrregularVerbs ? false : verbs
        con_textName: dfc_containerType!==Delegates_fc.ContainerType.WordGroup ? english : "Набор: "+name
        con_textCountOfWords: dfc_containerType===Delegates_fc.ContainerType.WordGroup ?
                                  "Всего слов: "+db.query_returnValue("select count(*) from Words where wordid="+id) : ""
        con_textNameWG: dfc_containerType===Delegates_fc.ContainerType.Search ? nameWG : ""
        con_textRussian: dfc_containerType!==Delegates_fc.ContainerType.WordGroup ? russian : ""
        con_text2form: dfc_containerType!==Delegates_fc.ContainerType.WordGroup ? twoform :""
        con_text2form_add: dfc_containerType!==Delegates_fc.ContainerType.WordGroup ? twoform_add :""
        con_text3form: dfc_containerType!==Delegates_fc.ContainerType.WordGroup ? threeform :""
        con_text3form_add: dfc_containerType!==Delegates_fc.ContainerType.WordGroup ? threeform_add :""

        onCon_clickDelete:
        {
            switch(dfc_containerType)
            {

            case Delegates_fc.ContainerType.Words:
                console.log("ID of deleted word "+id)
                root.height=0
                db.query_exec("delete from Words where id="+id)
                break

            case ContainerDelegate.ContainerType.WordGroup:
                console.log("ID of deleted wordgroup "+id)
                root.height=0
                AppCore.ac_deleteWG(id)
                break

            case ContainerDelegate.ContainerType.Search:
                console.log("ID of deleted word "+id)
                root.height=0
                db.query_exec("delete from Words where id="+id)
                break

            case ContainerDelegate.ContainerType.IrregularVerbs:
                console.log("delete was clicked")
                break

            default:
                console.log("onCon_clickDelete: You did not choose type of container!")
                break
            }
        }
        onCon_clickEnter:
        {
            switch(dfc_containerType)
            {

            case Delegates_fc.ContainerType.Words:
                if(con_changesEdit)
                {
                    db.query_exec("UPDATE Words SET english='"+con_textName+"' where id="+id)
                    db.query_exec("UPDATE Words SET russian='"+con_textRussian+"' where id="+id)
                }
                break

            case ContainerDelegate.ContainerType.WordGroup:
                AppCore.ac_createModelWords(id)
                idWG=id
                irVerbsWG=verbs
                if(verbs)AppCore.ac_createModelIrregularVerbs()
                stackView.initialItem=editor
                stackView.push(editorWords)
                seqEnter.running=true
                headerText.text=name
                inEditorWords=true
                toolButton.visible=true
                toolButton.opacity=1
                break

            case ContainerDelegate.ContainerType.Search:
                if(con_changesEdit)
                {
                    db.query_exec("UPDATE Words SET english='"+con_textName+"' where id="+id)
                    db.query_exec("UPDATE Words SET russian='"+con_textRussian+"' where id="+id)
                }
                break

            case ContainerDelegate.ContainerType.IrregularVerbs:
                root.height=0
                db.query_exec("insert into Words (russian,english,
                wordid,progress,twoform,threeform,twoform_add,threeform_add,verbs) values
                 ('"+con_textRussian+"','"+con_textName+"',"+idWG+",0,'"+con_text2form+"',
                '"+con_text3form+"','"+con_text2form_add+"','"+con_text3form_add+"',1);")
                AppCore.ac_createModelWords(idWG)
                console.log("add was clicked")
                break

            default:
                console.log("onCon_clickEnter: You did not choose type of container!")
                break
            }
        }
    }
}
