/*
 * This file is part of the Toxer application, a Tox messenger client.
 *
 * Copyright (c) 2017 Nils Fenner <nils@macgitver.org>
 *
 * This software is licensed under the terms of the MIT license:
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

import QtQuick 2.0

import controls 1.0 as Controls
import style 1.0


TextEdit {
    id: input

    property string placeholderText: ""
    property alias background: background.color

    horizontalAlignment: TextInput.AlignLeft
    verticalAlignment: TextInput.AlignVCenter

    color: Style.color.text

    Rectangle {
        id: background

        anchors.fill: parent

        color: "transparent"
        border.color: Style.color.alternateBase
        border.width: input.activeFocus ? 3 : 1

        z: -1
    }

    Controls.Text {
        anchors.fill: input
        anchors.margins: 5

        horizontalAlignment: input.horizontalAlignment
        verticalAlignment: input.verticalAlignment
        text: input.placeholderText
        color: input.color
        opacity: 0.3
        visible: !input.text
    }
}
