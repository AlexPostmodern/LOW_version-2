import QtQuick 2.12
import QtQuick.Controls 2.5

Page
{
    width: 600//parent
    height: 400//parent

    title: qsTr("Редактор слов")

    ListView
    {
        id: wordsList
        anchors.fill: parent
        model: WordsModel {}
        delegate: WordsDelegate{}
    }
    RoundButton
    {
        id: addWord
        text: "+"
        anchors.bottom: wordsList.bottom
        anchors.bottomMargin: 8
        anchors.horizontalCenter: parent
        onClicked: addWordDialog.open()
    }
    AddWordDialog
    {
        id: addWordDialog
        x:Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        WordsModel: wordsList.model
    }

}
