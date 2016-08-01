/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.3

Page {
    Container {
        layout: DockLayout {
        }
        
        Container {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Top
            
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            
            Container {
                preferredHeight: ui.du(2)
            }
            
            Label {
                topMargin: ui.du(10)
                horizontalAlignment: HorizontalAlignment.Center
                
                text: qsTr("Where is your Karotz?")
                textStyle.textAlign: TextAlign.Center
                textStyle.fontSize: FontSize.Large
            }
            Divider {
            
            }
        }
        
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Center
            preferredHeight: ui.du(60)
            
            ImageView {
                horizontalAlignment: HorizontalAlignment.Center
                imageSource: "asset:///images/wallpaper/karotz.png"
                preferredHeight: ui.du(50)
                scalingMethod: ScalingMethod.AspectFit
            }
            
            TextField {
                id: ipKarotz
                backgroundVisible: false
                hintText: qsTr("IP address")
                textStyle.textAlign: TextAlign.Center
                preferredWidth: ui.du(32)
                horizontalAlignment: HorizontalAlignment.Center
            }
            
            
            Button {
                horizontalAlignment: HorizontalAlignment.Center
                appearance: ControlAppearance.Primary
                text: qsTr("Start")
                
                onClicked: {
                    karotzController.setIP(ipKarotz.text);
                }
            
            }
        }
    }
}
