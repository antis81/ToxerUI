/*
 * This file is part of the Toxer application, a Tox messenger client.
 *
 * Copyright (c) 2017-2018 Nils Fenner <nils@macgitver.org>
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
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

import animations 1.0 as Animations
import base 1.0 as Base
import controls 1.0 as Controls
import style 1.0

Base.Page {
    id: root

    width: Math.min(400, Screen.width)
    height: Math.min(600, Screen.height)

    Animations.Ringing {
        target: logo
        duration: 100
        loops: 12
        running: true
    }

    footer: Column {
        Controls.Text {
            id: txtToxerVersion

            text: Qt.application.name + " " + Qt.application.version
        }

        Controls.Text {
            id: txtToxcoreVersion
            text: "Based on Tox " + Toxer.toxVersionString()
        }
    }

    header: ColumnLayout {
        id: headLayout

        implicitHeight: 400
        spacing: 52

        Image {
            id: logo

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: parent.width / 1.8
            Layout.preferredHeight: Layout.preferredWidth
            Layout.maximumWidth: 300
            Layout.maximumHeight: Layout.maximumWidth
            Layout.topMargin: headLayout.spacing

            sourceSize: Qt.size(width, height)
            source: "qrc:/res/images/dark/login_logo.svg"
            cache: false
        }

        ListView {
            id: pageSelector

            property real spikeWidth: 26
            property color highlightColor: {
                var c = Style.color.base;
                return Qt.hsla(c.hslHue + 0.5, 0.8,
                               c.hslLightness + (c.hslLightness <= 0.5 ? 0.15 : -0.15));
            }

            implicitHeight: contentItem.childrenRect.height
            implicitWidth: contentItem.childrenRect.width
            Layout.alignment: Qt.AlignCenter

            interactive: false
            orientation: ListView.Horizontal
            spacing: 6

            model: ListModel {
                ListElement {
                    name: qsTr("Start Profile")
                    page: "SelectProfile.qml"
                }
                ListElement {
                    name: qsTr("New Profile")
                    page: "CreateProfile.qml"
                }
                ListElement {
                    name: qsTr("Import Profile")
                    page: ""
                }
            }

            delegate: Controls.Text {
                font.pointSize: 10
                height: paintedHeight + 36
                width: implicitWidth + 36

                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                text: name

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        pageSelector.currentIndex = index
                    }
                }
            }

            highlightFollowsCurrentItem: false
            highlight: Item {
                Canvas {
                    id: highlighter
                    width: pageSelector.currentItem.width
                    height: pageSelector.currentItem.height
                    onPaint: {
                        var spikeWidth = pageSelector.spikeWidth;
                        var cy = height / 2;

                        var ctx = getContext("2d");
                        ctx.save();

                        ctx.beginPath();
                        ctx.moveTo(ctx.lineWidth, cy);
                        ctx.lineTo(spikeWidth, ctx.lineWidth);
                        ctx.lineTo(width - spikeWidth, ctx.lineWidth);
                        ctx.lineTo(width, cy);
                        ctx.lineTo(width - spikeWidth, height - ctx.lineWidth);
                        ctx.lineTo(spikeWidth, height - ctx.lineWidth);
                        ctx.lineTo(ctx.lineWidth, cy);
                        ctx.strokeStyle = pageSelector.highlightColor;
                        ctx.stroke();
                        ctx.fillStyle = pageSelector.highlightColor;
                        ctx.fill();

                        ctx.restore();
                    }

                    x: pageSelector.currentItem.x

                    Behavior on x {
                        SmoothedAnimation { duration: 180 }
                    }
                }

                Glow {
                    id: highlighter_effect
                    anchors.fill: highlighter
                    radius: 13
                    samples: 17
                    color: pageSelector.highlightColor;
                    source: highlighter
                }

                Animations.Pulsing {
                    target: highlighter_effect
                    properties: "spread"
                    from: 0.1
                    to: 0.3
                    durationIn: 180
                    durationOut: 300
                    loops: Animation.Infinite
                    running: true
                }
            }

            onCurrentIndexChanged: {
                var item = model.get(currentIndex);
                pageLoader.source = item.page;
            }

            Component.onCompleted: {
                currentIndex = 0
            }
        }
    }

    Loader {
        id: pageLoader

        anchors.fill: parent
        anchors.margins: 9
    }
}
