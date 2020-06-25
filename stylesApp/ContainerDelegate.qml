import QtQuick 2.12
import QtQuick.Controls 2.5

Item
{
    property int con_width: sizeWindow/1.8                  //400 (ширина)
    property int con_heightMax:
    {
        switch(con_typeContainer)
        {
        case ContainerDelegate.ContainerType.Words:

            if(con_visibleVerbs)
                con_text2form_add!=""||con_text3form_add!="" ?
                            sizeWindow/5.3 : sizeWindow/6.73
            else sizeWindow/6.73
            break
        case ContainerDelegate.ContainerType.WordGroup:
            sizeWindow/6.73
            break
        case ContainerDelegate.ContainerType.Search:
            con_visibleVerbs ? sizeWindow/4.5 : sizeWindow/6.73
            break
        case ContainerDelegate.ContainerType.IrregularVerbs:
            con_text2form_add!="" || con_text3form_add!="" ? sizeWindow/5.8 : sizeWindow/6.73
            break
        default:
            sizeWindow/6.73
            break
        }
    }
    property int con_heightMin: sizeWindow/11.25            //64  (минимальная высота)
    property int con_sizeButtons: sizeWindow/14.4           //50  (размер кнопок)
    property string con_textDelete: "\u2A09"                //текст кнопки удаления
    property string con_textName                            //текст названия набора/слова
    property string con_textCountOfWords                    //количество слов в наборе
    property bool con_visibleVerbs: false                   //видимость индикатора неправильных глаголов
    property int con_modelProgress:-1                       //модель для индикатора прогресса
    property string con_lastRepeat:""                       //последнее повторение формат QDate в QString
    property string con_textDeletePressed:con_textName      //при нажатии на кнопку удалить (название набора/слова)
    property string con_textRussian                         //текст слово на русском
    property string con_textNameWG                          //текст название набора из которого слово
    property string con_text2form                           //текст вторая форма глагола
    property string con_text2form_add                       //текст вторая форма глагола (дополнительная)
    property string con_text3form                           //текст третья форма глагола
    property string con_text3form_add                       //текст третья форма глагола (дополнительная)
    property bool con_changesEdit: false                    //сделаны ли измениня при редактирвоании

    signal con_clickDelete                                  //сигнал нажатия на кнопку удалить
    signal con_clickEnter                                   //сигнал нажатия на кнопку войти/редактировать

    enum ContainerType{Words,WordGroup,Search,IrregularVerbs}                       //типы контейнеров
    property int con_typeContainer:ContainerDelegate.ContainerType.Words            //тип контейнера
    property int con_height: rec.pressContainer ? con_heightMax : con_heightMin     //высота контейнера

    id:root
    width: con_width
    height: con_height

    Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}

    Rectangle
    {
        property bool pressContainer: false         //индикатор нажатия на контейнер
        property int fontSizeBig: sizeWindow/36     //20
        property int fontSizeLittle: sizeWindow/48  //15
        property int sizeProgress: sizeWindow/48    //15
        property bool pressEdit: false              //индикатор нажатия на редактировать

        function mouseAreaPress()                   //функция нажатия на контейнер
        {
            if (deleteButton.pressDelete)
            {
                deleteButton.progress=0
                deleteButton.pressDelete=false
                columnEnter.visible=true
                columnDelete.visible=true
                anim_deleted1.running=true
                columnDeletePressed.visible=false
            }
            else
            {
                rec.color=rec.pressContainer ? "#d6d7d7" : "#3f51b5"
                rec.pressContainer=rec.pressContainer ? false : true
                anim_Repeater.running=true
            }
        }

        function clickEsc()                         //функция повторного нажатия или нажатия назад
        {
            rec.pressEdit=rec.pressEdit ? false : true
            editName.text=labelName.text
            editRus.text=labelRussian.text
        }

        function clickEnter()                       //функция подтверждения редактирования
        {
            con_changesEdit=false
            rec.pressEdit=rec.pressEdit ? false : true
            if(labelName.text!==editName.text || labelRussian.text!==editRus.text)
            {
                console.log("Изменения сделаны")
                con_changesEdit=true
                con_textName=labelName.text=editName.text
                con_textRussian=labelRussian.text=editRus.text
            }
            root.con_clickEnter()
        }

        id:rec
        width: con_width
        height: con_height
        radius: height/2
        anchors.centerIn: parent
        color:pressContainer ? /*синий*/ "#3f51b5" : /*серый*/ "#d6d7d7"

        Behavior on  width {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        Behavior on  height {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
        Behavior on  opacity {NumberAnimation{duration:500; easing.type: Easing.OutQuad}}
        Behavior on color {ColorAnimation {duration: 300; easing.type: Easing.OutQuad}}

        MouseArea
        {
            anchors.fill: parent
            onPressed: rec.mouseAreaPress()
            hoverEnabled: true
            onEntered:parent.color=rec.pressContainer ?"#3f51b5":"#c9caca"
            onExited:parent.color=rec.pressContainer ?"#3f51b5":"#d6d7d7"
        }

        //появляется когда нажата кнопка удалить**********************************************
        Column
        {
            id:columnDeletePressed
            spacing: 2
            anchors.centerIn: parent
            opacity:0
            Behavior on  visible {NumberAnimation{duration:2000; easing.type: Easing.OutQuad}}
            visible: false
            Text
            {
                id: textDeletePressed
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Вы действительно хотите удалить\n"+con_textDeletePressed+"?")
                color: "white"
                font.pixelSize: rec.fontSizeBig
            }

            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 30

                YesOrNoButton
                {
                    id:yes_Button
                    onYn_click:
                    {
                        rec.height=0
                        rec.width=0
                        rec.opacity=0
                        root.con_clickDelete()
                    }
                }

                YesOrNoButton
                {
                    id:no_Button
                    yn_text: "Нет"
                    yn_typeButton: YesOrNoButton.ButtonType.No
                    onYn_click: rec.mouseAreaPress()
                }
            }
        }

        //кнопки удалить и назад**************************************************************
        Column
        {
            id:columnDelete
            anchors{left: parent.left; leftMargin:  10; verticalCenter: parent.verticalCenter}
            Behavior on  opacity {NumberAnimation{duration:1000; easing.type: Easing.OutQuad}}
            Behavior on  visible {NumberAnimation{duration:2000; easing.type: Easing.OutQuad}}
            visible: con_typeContainer===ContainerDelegate.ContainerType.IrregularVerbs ? false : true

            //кнопка удалить**********************************************
            DelayButton
            {
                id:deleteButton
                checked:false
                visible: rec.pressContainer&&!rec.pressEdit
                //Behavior on  opacity {NumberAnimation{duration:1000; easing.type: Easing.OutQuad}}
                opacity: rec.pressContainer ? 1 : 0
                delay: 500

                property bool hover: false
                property bool pressDelete: false

                onHoveredChanged:
                {
                    hover=hover ? false : true
                    deleteText.color=hover ? "#cd4678" : "white"
                    background.color= hover ? "#3b4caa" : "transparent"
                }

                SequentialAnimation
                {
                    id:anim_deleted
                    NumberAnimation {
                        targets: [columnAll,columnDelete,columnEnter]
                        properties: "opacity"
                        from:1
                        to: 0
                        duration: animDur
                    }

                    NumberAnimation {
                        target: columnDeletePressed
                        properties: "opacity"
                        from:0
                        to: 1
                        duration: animDur
                    }
                }

                SequentialAnimation
                {
                    id:anim_deleted1
                    NumberAnimation {
                        target: columnDeletePressed
                        properties: "opacity"
                        from:1
                        to: 0
                        duration: animDur
                    }
                    NumberAnimation {
                        targets: [columnAll,columnDelete,columnEnter]
                        properties: "opacity"
                        from:0
                        to: 1
                        duration: animDur
                    }
                }

                onClicked:
                {
                    if (progress==1)
                    {
                        pressDelete=true
                        anim_deleted.running=true
                        columnDeletePressed.visible=true
                        columnEnter.visible=false
                        columnDelete.visible=false
                    }
                }

                contentItem: Text
                {
                    id: deleteText
                    text: con_textDelete
                    color: "white"
                    font.pixelSize: rec.fontSizeBig
                    opacity: enabled ? 1 : 0.3
                    anchors{top:parent.top; topMargin:sizeWindow/48 ; left:parent.left; leftMargin:sizeWindow/48 }
                    //anchors{horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter}
                }

                background: Rectangle
                {
                    id:background
                    implicitWidth:con_sizeButtons
                    implicitHeight:con_sizeButtons
                    opacity: enabled ? 1 : 0.3
                    color:"transparent"
                    radius:con_sizeButtons/2
                    width:con_sizeButtons
                    height:con_sizeButtons
                    anchors.centerIn:parent
                }

                Canvas
                {
                    id:canvas
                    anchors.fill: parent

                    Connections
                    {
                        target: deleteButton
                        onProgressChanged:canvas.requestPaint()
                    }

                    onPaint:
                    {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.strokeStyle = "#cd4678"
                        ctx.lineWidth = con_sizeButtons / 20
                        ctx.beginPath()
                        var startAngle =Math.PI / 5 * 3
                        var endAngle = startAngle + deleteButton.progress * Math.PI / 5 * 9
                        ctx.arc(width / 2, height / 2, width / 2 - ctx.lineWidth / 2 - 2, startAngle, endAngle)
                        ctx.stroke()
                    }
                }
            }

            //кнопка назад************************************************
            YesOrNoButton
            {
                yn_typeButton: YesOrNoButton.ButtonType.No
                visible: rec.pressEdit
                yn_text: "\uf1e4"
                onYn_click: rec.clickEsc()
            }
        }

        //кнопка войти в набор/редактировать/добавить*****************************************
        Column
        {
            id:columnEnter
            anchors{right:parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter}
            /*visible: con_visibleVerbs && con_typeContainer===
                                     ContainerDelegate.ContainerType.Words ? false : rec.pressContainer*/
            YesOrNoButton
            {
                id:enter_editButton
                visible: con_visibleVerbs &&
                         (con_typeContainer===ContainerDelegate.ContainerType.Words ||
                         con_typeContainer===ContainerDelegate.ContainerType.Search) ?
                         false : rec.pressContainer
                //visible: rec.pressContainer
                opacity: rec.pressContainer ? 1 : 0
                yn_typeContainer:con_typeContainer
                property bool first: false
                onYn_click:
                {

                    if (con_typeContainer!==ContainerDelegate.ContainerType.WordGroup &&
                            con_typeContainer!==ContainerDelegate.ContainerType.IrregularVerbs)
                    {
                        if (first)
                        {
                            rec.clickEnter()
                            first=false
                        }
                        else
                        {
                            first=true
                            rec.pressEdit=true
                        }
                    }
                    else if(con_typeContainer===ContainerDelegate.ContainerType.IrregularVerbs)
                    {
                        rec.height=0
                        rec.width=0
                        rec.opacity=0
                        root.con_clickEnter()
                    }
                    else root.con_clickEnter()

                }
            }
        }

        //все остальное***********************************************************************
        Column
        {
            id:columnAll
            anchors{top: parent.top; topMargin: 5; horizontalCenter: parent.horizontalCenter}
            spacing:
            {
                switch(con_typeContainer)
                {
                case ContainerDelegate.ContainerType.Words:
                    con_visibleVerbs ? 2 : 5
                    break
                case ContainerDelegate.ContainerType.WordGroup:
                    2
                    break
                case ContainerDelegate.ContainerType.Search:
                    2
                    break
                default:
                    2
                    break
                }
            }

            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 5

                //имя*****************************************************
                Label
                {
                    id: labelName
                    text: con_textName
                    font.pixelSize: rec.fontSizeBig
                    color: rec.pressContainer ? "white" : "black"
                    visible: !rec.pressEdit
                }

                //irregular verbs (indicator)*****************************
                Rectangle
                {
                    width: sizeWindow/36
                    height: sizeWindow/36
                    radius: width/2
                    color: "transparent"
                    border.width:1
                    border.color:rec.pressContainer ? "white" : "black"
                    visible: con_visibleVerbs && con_typeContainer!==ContainerDelegate.ContainerType.Words
                    ToolTip
                    {
                        id:iVerbs
                        text: qsTr("Неправильные глаголы")
                        delay: 700
                    }

                    Text
                    {
                        font.family: verbsFont.name
                        text: qsTr("V")
                        anchors.centerIn: parent
                        font.pixelSize: rec.fontSizeLittle
                        color: rec.pressContainer ? "white" : "black"
                    }
                    MouseArea
                    {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered:{
                            iVerbs.visible=true
                        }

                        onExited:{
                            iVerbs.visible=false
                        }
                    }


                }
            }

            //всего слов**************************************************
            Label
            {
                id:labelCountOfWords
                anchors.horizontalCenter: parent.horizontalCenter
                text:
                {
                    switch(con_typeContainer)
                    {
                    case ContainerDelegate.ContainerType.Words:
                        ""
                        break
                    case ContainerDelegate.ContainerType.WordGroup:
                        con_textCountOfWords
                        break
                    case ContainerDelegate.ContainerType.Search:
                        ""
                        break
                    default:
                        ""
                        break
                    }

                }
                font.pixelSize: rec.fontSizeLittle
                color: rec.pressContainer ? "white" : "black"
                visible: rec.pressContainer && con_typeContainer===ContainerDelegate.ContainerType.WordGroup
                Behavior on  opacity {NumberAnimation{duration:1000; easing.type: Easing.OutQuad}}
                opacity: rec.pressContainer ? 1 : 0
            }

            //неправильные глаголы****************************************
            Row
            {
                id: rowIrregularVerbs
                anchors.horizontalCenter: parent.horizontalCenter
                visible:
                {
                    /*if (con_modelProgress==-1)
                        true
                    else*/
                    rec.pressContainer &&con_typeContainer!==ContainerDelegate.ContainerType.WordGroup && !rec.pressEdit
                }
                opacity:
                {
                    if (con_modelProgress==-1)
                        1
                    else
                        rec.pressContainer &&con_typeContainer!==ContainerDelegate.ContainerType.WordGroup && !rec.pressEdit ? 1 : 0
                }

                Behavior on  opacity {NumberAnimation{duration:1000; easing.type: Easing.OutQuad}}
                spacing: 20

                Label
                {
                    id: labeltext2form
                    //visible: con_text2form_add=="" ? false : true
                    text: con_text2form
                    color: rec.pressContainer ? "white" : "black"
                    font.pixelSize: rec.fontSizeBig
                }

                Label
                {
                    visible: con_text2form_add=="" ? false : true
                    text: "или"
                    color: "white"
                    font.pixelSize: rec.fontSizeBig
                }

                Label
                {
                    id: labeltext2form_add
                    text: con_text2form_add
                    color: rec.pressContainer ? "white" : "black"
                    font.pixelSize: rec.fontSizeBig
                }

                Label
                {
                    id: labeltext3form
                    visible: con_text2form_add=="" ? true : false
                    text: con_text3form
                    color: rec.pressContainer ? "white" : "black"
                    font.pixelSize: rec.fontSizeBig
                }
            }

            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                visible:
                {
                    /*if (con_modelProgress==-1)
                        true
                    else*/
                    rec.pressContainer &&con_typeContainer!==ContainerDelegate.ContainerType.WordGroup && !rec.pressEdit
                }
                opacity:
                {
                    if (con_modelProgress==-1)
                        1
                    else
                        rec.pressContainer &&con_typeContainer!==ContainerDelegate.ContainerType.WordGroup && !rec.pressEdit ? 1 : 0
                }

                Behavior on  opacity {NumberAnimation{duration:1000; easing.type: Easing.OutQuad}}
                spacing: 20

                Label
                {
                    visible: con_text2form_add=="" ? false : true
                    id: labeltext3form1
                    text: con_text3form
                    color: rec.pressContainer ? "white" : "black"
                    font.pixelSize: rec.fontSizeBig
                }

                Label
                {
                    visible: con_text3form_add=="" ? false : true
                    //visible: false
                    text: "или"
                    color: "white"
                    font.pixelSize: rec.fontSizeBig
                }

                Label
                {
                    visible: con_text3form_add=="" ? false : true
                    //visible: false
                    id: labeltext3form_add
                    text: con_text3form_add
                    color: rec.pressContainer ? "white" : "black"
                    font.pixelSize: rec.fontSizeBig
                }
            }

            //cлово на русском********************************************
            Label
            {
                id: labelRussian
                anchors.horizontalCenter: parent.horizontalCenter
                text: con_textRussian
                font.pixelSize: rec.fontSizeBig
                color: rec.pressContainer ? "white" : "black"
                visible: rec.pressContainer && con_typeContainer!==ContainerDelegate.ContainerType.WordGroup &&!rec.pressEdit
                Behavior on  opacity {NumberAnimation{duration:1000; easing.type: Easing.OutQuad}}
                opacity: rec.pressContainer ? 1 : 0
            }

            //владение****************************************************
            Row
            {
                id:rowRepeater
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                visible: !rec.pressEdit && con_modelProgress!=-1

                Label
                {
                    id:labelProgress
                    font.pixelSize: rec.fontSizeLittle
                    color: rec.pressContainer ? "white" : "black"
                    text: "Владение"
                    visible: rec.pressContainer
                    opacity: rec.pressContainer ? 1 : 0
                }

                SequentialAnimation
                {
                    id:anim_Repeater
                    NumberAnimation {
                        targets: rowRepeater
                        properties: "opacity"
                        from:1
                        to: 0
                        duration: 0
                    }
                    NumberAnimation {
                        targets: rowRepeater
                        properties: "opacity"
                        from:0
                        to: 1
                        duration: 1000
                    }
                }

                Repeater
                {
                    id:progressRep
                    model:con_modelProgress==-1 ? 0 : con_modelProgress
                    delegate: Rectangle
                    {
                        height:rec.sizeProgress
                        width:rec.sizeProgress
                        radius:rec.sizeProgress/2
                        color: switch(progressRep.model)
                               {
                               case 4: "#60b66e"//"#3f51b5"
                                   break
                               case 3: "#60b66e"
                                   break
                               case 2: "#e7e66e"
                                   break
                               case 1: "#ea5462"
                                   break
                               }
                        border.width:1
                        border.color:rec.pressContainer ? "white" : "black"
                    }
                }

                Repeater
                {
                    id:antiProgressRep
                    model:4-progressRep.model
                    delegate: Rectangle
                    {
                        height:rec.sizeProgress
                        width:rec.sizeProgress
                        radius:rec.sizeProgress/2
                        color:"transparent"
                        border.width:1
                        border.color: rec.pressContainer ? "white" : "black"
                    }
                }
            }

            //последнее повторение****************************************
            Label
            {
                anchors.horizontalCenter: parent.horizontalCenter
                id: labelLastRepeat
                visible: rec.pressContainer && con_typeContainer===ContainerDelegate.ContainerType.WordGroup
                Behavior on  opacity {NumberAnimation{duration:1000; easing.type: Easing.OutQuad}}
                opacity: rec.pressContainer ? 1 : 0
                text:
                {
                    if (con_lastRepeat=="")
                        "Еще не повторялся"
                    else
                        "Последнее повтороние "+AppCore.ac_lastRepeat(con_lastRepeat)
                }
                color: "white"
                font.pixelSize: rec.fontSizeLittle
            }

            //название набора*********************************************
            Label
            {
                anchors.horizontalCenter: parent.horizontalCenter
                id: labelNameWG
                visible: rec.pressContainer && con_typeContainer===ContainerDelegate.ContainerType.Search&&!rec.pressEdit
                Behavior on  opacity {NumberAnimation{duration:1000; easing.type: Easing.OutQuad}}
                opacity: rec.pressContainer && con_typeContainer===ContainerDelegate.ContainerType.Search  ? 1 : 0
                text: con_textNameWG
                color: "white"
                font.pixelSize: rec.fontSizeLittle
            }

            //при редактировании******************************************
            TextField
            {
                id: editName
                anchors.horizontalCenter: parent.horizontalCenter
                width: con_width-enter_editButton.width-deleteButton.width-40
                height:sizeWindow/16
                text: con_textName
                font.pixelSize: rec.fontSizeBig
                visible: rec.pressEdit
                color:"white"
                horizontalAlignment: Text.AlignHCenter
                Keys.onReturnPressed: rec.clickEnter()
                Keys.onEscapePressed: rec.clickEsc()
            }

            TextField
            {
                id: editRus
                anchors.horizontalCenter: parent.horizontalCenter
                width: con_width-enter_editButton.width-deleteButton.width-40
                height:sizeWindow/16
                text: con_textRussian
                font.pixelSize: rec.fontSizeBig
                visible: rec.pressEdit
                color:"white"
                horizontalAlignment: Text.AlignHCenter
                Keys.onReturnPressed: rec.clickEnter()
                Keys.onEscapePressed: rec.clickEsc()
            }

        }
    }
}

