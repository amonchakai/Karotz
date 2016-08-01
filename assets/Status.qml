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
import Utility.KarotzController 1.0

NavigationPane {
    id: nav
    
    property variant pageAction
    

    Page {
        Container {
            layout: DockLayout {
            }
            
            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Top
                
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                
                Container {
                    preferredHeight: ui.du(1)
                }
                
                Label {
                    topMargin: ui.du(8)
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    text: qsTr("Manage your Karotz")
                    textStyle.textAlign: TextAlign.Center
                    textStyle.fontSize: FontSize.Large
                }
                Divider {}
            }
            
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 3
                }
                
                ImageView {
                    horizontalAlignment: HorizontalAlignment.Center
                    imageSource: "asset:///images/wallpaper/karotz.png"
                    preferredHeight: ui.du(50)
                    scalingMethod: ScalingMethod.AspectFit
                }
                
                Container {
                    preferredHeight: ui.du(4)
                }
                
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    ImageView {
                        id: statusColor
                        imageSource: "asset:///images/cyan.png"
                        preferredHeight: ui.du(5)
                        preferredWidth: ui.du(5)
                        verticalAlignment: VerticalAlignment.Center
                    }
                    
                    Label {
                        id: karotzTextStatus
                        text: qsTr("waiting for karotz...")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    
                }
            }
        }
        
        onCreationCompleted: {
            karotz.getStatus();
        }
        
        actions: [
            ActionItem {
                id: wakeUp
                ActionBar.placement: ActionBarPlacement.InOverflow
                title: qsTr("Wake up")
                imageSource: "asset:///images/icon_clock.png"
                onTriggered: {
                    karotz.wakeUp(0);
                }
            },
            ActionItem {
                id: sleep
                ActionBar.placement: ActionBarPlacement.InOverflow
                title: qsTr("Sleep")
                imageSource: "asset:///images/icon_sleep.png"
                onTriggered: {
                    karotz.sleep();
                }
            },
            ActionItem {
                id: checkStatus
                ActionBar.placement: ActionBarPlacement.InOverflow
                title: qsTr("Status")
                imageSource: "asset:///images/icon_about.png"
                onTriggered: {
                    karotz.getStatus();
                }
            },
            ActionItem {
                id: scheduleTask
                ActionBar.placement: ActionBarPlacement.Signature
                title: qsTr("Do")
                imageSource: "asset:///images/icon_play.png"
                
                onTriggered: {
                    if(!pageAction)
                        pageAction = actionPage.createObject();
                        
                    nav.push(pageAction);
                }
            }
        ]
        
        attachedObjects: [
            KarotzController {
                id: karotz
                
                onSleepStatus: {
                    switch (status) {
                        case 0: {
                            karotzTextStatus.text = qsTr("Karotz is ready");
                            statusColor.imageSource = "asset:///images/green.png";
                            
                            break;
                        }
                        
                        case 1: {
                            karotzTextStatus.text = qsTr("Karotz is sleeping");
                            statusColor.imageSource = "asset:///images/yellow.png";
                            
                            break;
                        }
                    }
                }
                
                onNoKarotz: {
                    karotzTextStatus.text = qsTr("No Karotz around :(");
                    statusColor.imageSource = "asset:///images/red.png";
                    
                }
            },
            
            ComponentDefinition {
                id: actionPage
                source: "Action.qml"
            }
            
            
        ]
    }
}
