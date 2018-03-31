import QtQuick 2.7

import style 1.0

Text {
    renderType: Text.NativeRendering
    maximumLineCount: 1
    wrapMode: Text.NoWrap
    textFormat: Text.PlainText
    elide: Text.ElideRight
    color: Style.color.text
    font.pointSize: Style.fontPointSize
}
