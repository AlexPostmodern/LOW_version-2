import QtQuick 2.12
import QtQuick.Controls 2.5
//import "./stylesApp"


ApplicationWindow
{
    id:window
    visible: true
    width: windowWidth
    height: windowHeight

    //плавное поведение(анимация)
    Behavior on width {NumberAnimation{easing.type: Easing.OutCubic}}
    Behavior on height {NumberAnimation{easing.type: Easing.OutCubic}}

    //начальная ширина и высота главного окна
    property int windowWidth:  800
    property int windowHeight:  640

    //среднее арифмитическое из размеров окна
    property int sizeWindow: (window.height+window.width)/2 //720 при 800 на 640

    //размер кнопки в хедере
    property int sizeToolButton: sizeWindow/10.29   //70

    //исчезновение кнопки и появление, если кнопки не видно то false
    property bool visibleButton : false

    //отступ текста в хедере, когда появляется стрелочка
    property int anchorsLeftMargin: toolButton.x+sizeToolButton+sizeWindow/72

    //если в меню входа то true, если нет то false
    property bool enterORmenu: true

    //если нажата кнопка изменить набор
    property bool editWGpress: false

    //если открыт какой то набор слов в editorPage, т.е. осуществился переход к словам
    property bool inEditorWords: false

    //время анимации в stakView
    property int dur: 600

    //айди набора слов, который выбран
    property int idWG

    //индикатор неправильных глаголов
    property bool irVerbsWG

    //стандартное время анимации в этом приложении
    property int animDur: 700

    //функция для выставления задержки
    Timer{id: timer}
    function delayAnim(delayTime, cb)
    {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    //шрифт для символов
    FontLoader
    {
        id:searchFont
        source:"qrc:/fonts/elusiveicons-webfont.ttf"
    }
    FontLoader
    {
        id:verbsFont
        source:"qrc:/fonts/19180.otf"
    }

    //функция изменения названия набора слов
    function editWGclicked()
    {
        if (editWGpress&&headerField.text!==headerText.text)
        {
            db.query_exec("update WordGroup set name='"+headerField.text+"' where id="+idWG.toString())
            headerText.text=headerField.text
        }
        editWGpress=editWGpress?false:true
        headerField.focus=editWGpress?true:false
        headerField.visible=headerField.visible? false:true
        headerText.visible=headerText.visible? false:true
    }

    //cигналы*********************************************************************************
    Connections
    {
        target: AppCore
        //если какой то lastEnter = 1, то откроется главное меню
        onSignal_lastEnter:
        {
            stackView.initialItem=mainMenu
            stackView.push(mainMenu)
            toolButton.opacity=0
            toolButton.visible=false
            enterORmenu=false
            headerText.text="Главное меню"
        }
    }

    //фон*************************************************************************************
    Image
    {
        Behavior on  anchors.fill {NumberAnimation{duration:2500;easing.type: Easing.OutQuad}}
        anchors.fill: parent
        source: "qrc:/images/background2.jpg"
    }

    //HEADER**********************************************************************************
    header:ToolBar
    {
        id: head
        contentHeight:sizeToolButton

        //кнопка назад в хедере
        ToolButton
        {
            id:toolButton
            width:sizeToolButton
            height: sizeToolButton
            text:"\u25C0"            
            visible: true            
            opacity: stackView.depth>1?1:0
            antialiasing: true 
            font.pixelSize: sizeWindow/36   //20

            //анимации при изменении этих свойств
            Behavior on text {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
            Behavior on opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
            Behavior on font.pixelSize {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
            Behavior on width {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
            Behavior on height {NumberAnimation{ duration:animDur; easing.type: Easing.OutCubic}}

            //действия по нажатию на кнопку
            onClicked:
            {
                stackView.pop()
                if(inEditorWords)
                {
                    seqEnter.running=true
                    headerText.text=qsTr("Редактор слов")
                    inEditorWords=false
                    AppCore.ac_createModelWG()
                    headerField.visible=false
                    headerText.visible=true
                }
                else
                {
                    headerText.text=enterORmenu ? qsTr("Авторизация"):qsTr("Главное меню")
                    visibleButton=false
                    toolButton.opacity=0
                    delayAnim(dur,function(){toolButton.visible=false})
                }
            }
        }

        //лейблы в хедере
        Text
        {
            id: headerText
            text: qsTr("Авторизация")
            anchors.verticalCenter: parent.verticalCenter
            x:visibleButton ? anchorsLeftMargin : sizeWindow/72    //10
            Behavior on  x {NumberAnimation{duration:animDur+300; easing.type: Easing.OutCubic}}
            font.pixelSize: sizeWindow/28.8 //25
            color:"white"
        }

        TextField
        {
            id:headerField
            text: headerText.text
            width:headerText.width
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            x:visibleButton ? anchorsLeftMargin : sizeWindow/72    //10
            font.pixelSize: sizeWindow/28.8 //25
            Keys.onReturnPressed: editWGclicked()
            Keys.onEscapePressed:
            {
                editWGpress=editWGpress?false:true
                headerField.visible=headerField.visible? false:true
                headerText.visible=headerText.visible? false:true
                headerField.text=headerText.text
            }
        }

        ToolButton
        {
            id:toolButtonEdit
            width:sizeToolButton
            height: sizeToolButton
            anchors.left: headerText.right
            anchors.leftMargin: sizeWindow/144    //5
            text:"\uf148"
            visible: inEditorWords
            opacity: inEditorWords?1:0
            antialiasing: true
            font.pixelSize: sizeWindow/48   //15
            Behavior on opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutQuad}}
            onClicked:editWGclicked()
        }

        //картинка пользователя справа вверху
        Rectangle
        {
            id:recPhoto
            anchors.right: parent.right
            anchors.rightMargin: 10
            Behavior on opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
            opacity: loginHead.text==="" ? 0:1
            width: sizeWindow/14.4
            height: sizeWindow/14.4
            radius: sizeWindow/28.8
            color: "transparent"
            border.color: "white"
            border.width: 2
            anchors.verticalCenter: parent.verticalCenter
            Text
            {
                id: textPhoto
                anchors.centerIn: parent
                text: qsTr("\uf211")
                color: "white"
                font.pixelSize: sizeWindow/30
            }
        }

        //логин пользователя
        Text
        {
            id: loginHead
            text:db.query_returnValue("select login from RegUsers where lastEnter=1;",0,0)
            Behavior on opacity {NumberAnimation{duration:animDur; easing.type: Easing.OutCubic}}
            opacity: loginHead.text==="" ? 0:1
            anchors.right: recPhoto.left
            anchors.rightMargin: 10
            color:"white"
            Behavior on  font.pixelSize {NumberAnimation{duration:200; easing.type: Easing.OutCubic}}
            font.pixelSize: sizeWindow/48   //15
            anchors.verticalCenter: parent.verticalCenter
        }

    }

    //анимация для хедера*********************************************************************
    SequentialAnimation
    {
        id:seqEnter
        NumberAnimation {
                    target: headerText
                    properties: "opacity"
                    from:1
                    to: 0
                    duration: 0
        }
        NumberAnimation {
                    target: headerText
                    properties: "opacity"
                    from:0
                    to: 1
                    duration: 1400
        }
    }

    //основной элемент, соединящий все********************************************************
    StackView
    {
        id:stackView
        anchors.fill: parent

        //анимация
        pushEnter: Transition {
            PropertyAnimation
                        {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 1000
                        }
            }
        pushExit: Transition
        {
                XAnimator
                {
                    from: 0
                    to: (stackView.mirrored ? 1 : -1) * stackView.width
                    duration: dur
                    easing.type: Easing.OutCubic
                }

        }
        popEnter: Transition
        {
                XAnimator {
                    from: (stackView.mirrored ? 1 : -1) * stackView.width
                    to: 0
                    duration: dur
                    easing.type: Easing.OutCubic
                }
        }
        popExit: Transition {
            PropertyAnimation
                        {
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 300
                        }
            }

        focus:true
        Keys.onReleased: if(event.key === Qt.Key_Back && stackView.depth > 1)
                         {
                             stackView.pop();
                             event.accepted = true;
                         }

        //главный элемент
        initialItem: Component{id:enter; EnterPage {}}

        //остальные элементы
        Component{id:test; TestPage{}}
        Component{id:editor; EditorPage{}}
        Component{id:mainMenu; MainMenuPage{}}
        Component{id:reg; RegPage{}}
        Component{id:editorWords; EditorWordsPage{}}
    }
}

