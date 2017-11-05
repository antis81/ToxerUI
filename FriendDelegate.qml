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

import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "." // QTBUG-34418
import "controls" as Controls

Item {
    id: root

    implicitWidth: 200
    implicitHeight: infoColumn.height
    clip: true

    property alias name: name
    property alias avatar: avatar
    property alias statusMessage: statusMessage
    property alias statusLight: statusLight

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            id: avatarItem
            Layout.fillHeight: true
            implicitWidth: height + statusLight.width

            Image {
                id: avatar

                visible: false
                height: parent.height
                width: height
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(width, height)
            }

            Rectangle {
                id: avatarMask

                anchors.fill: avatar
                color: Style.color.alternateBase
                radius: width / 2
                OpacityMask {
                    anchors.fill: parent
                    source: avatar
                    maskSource: avatarMask
                }
            }

            Image {
                id: statusLight

                visible: true
                height: Math.max(avatar.height * 0.33, 10)
                width: height
                anchors.bottom: avatar.bottom
                anchors.right: avatar.right
                anchors.rightMargin: -(height / 2)
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(width, height)
            }
        }

        Column {
            id: infoColumn

            Layout.minimumWidth: 20
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            Controls.Text {
                id: name

                width: parent.width
                font.bold: true
                text: "<alias>"
            }

            Controls.Text {
                id: statusMessage

                width: parent.width
                text: "<status_message>"
            }
        }
    }
}
