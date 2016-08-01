import bb.cascades 1.3
import bb.data 1.0

Page {
    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                layout: DockLayout { }
                leftPadding: 10
                rightPadding: 10
                
                Label {
                    text: qsTr("Actions")
                    textStyle {
                        color: Application.themeSupport.theme.colorTheme.style == VisualStyle.Dark ? Color.White : Color.Black
                    }
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        }
    }
    
    property variant pageWake
    property variant pageMain
    property variant pageLed
    property variant pageEars
    property variant pageRFID
    property variant pageTTS
    property variant pagePicture
    property variant pageSound
    
    
    Container {
        ListView {
            id: actionList
            dataModel: dataModel
            
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    
                    
                    Container {
                        preferredHeight: ui.du(12)
                        id: listItemContainer
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Center
                        layout: DockLayout {
                        }
                        
                        Container {
                            verticalAlignment: VerticalAlignment.Center
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            Container {
                                preferredWidth: ui.du(0.1)
                            }
                            
                            ImageView {
                                imageSource: ListItemData.image
                                preferredHeight: ui.du(8)
                                preferredWidth: ui.du(8)
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            Label {
                                text: ListItemData.action
                                verticalAlignment: VerticalAlignment.Center
                            }
                        }
                        
                        Container {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Right
                            
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            ImageView {
                                imageSource: Application.themeSupport.theme.colorTheme.style == VisualStyle.Dark ? "asset:///images/icon_right.png" : "asset:///images/icon_right_black.png"
                                preferredHeight: ui.du(5)
                                preferredWidth: ui.du(5)
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            Container {
                                preferredWidth: ui.du(1)
                            }
                            
                            
                        }
                        
                    
                        Divider { }
                                            
                    }
                }
            ]
            
            onTriggered: {
                var chosenItem = dataModel.data(indexPath);
                
                switch(chosenItem.id) {
                    
                    case 0: {
                            if(!pageWake)
                                pageWake = wakeControl.createObject();
                            nav.push(pageWake);
                            
                            break;
                    }
                    
                    case 1: {
                        if(!pageLed)
                            pageLed = ledControl.createObject();
                        nav.push(pageLed);
                        
                        break;
                    }
                    
                case 2: {
                     if(!pageEars)
                         pageEars = earsControl.createObject();
                     nav.push(pageEars);
                     
                     break;
                }
                
                case 3: {
                    if(!pageRFID)
                        pageRFID = rfidControl.createObject();
                    nav.push(pageRFID);
                    
                    break;
                }
                
                 case 4: {
                    if(!pageTTS)
                        pageTTS = ttsControl.createObject();
                    nav.push(pageTTS);
                      
                    break;
                }
                 
                 case 5: {
                     if(!pagePicture)
                         pagePicture = pictureControl.createObject();
                     nav.push(pagePicture);
                     
                     break;
                 }
                 
                 case 6: {
                         if(!pageSound)
                             pageSound = soundControl.createObject();
                         nav.push(pageSound);
                         
                         break;
                 }
                    
                }
                
            }
            
            attachedObjects: [
                GroupDataModel {
                    id: dataModel
                    sortingKeys: ["id"]
                    grouping: ItemGrouping.None
                },
                DataSource {
                    id: dataSource
                    source: "data/ActionList.json"
                    onDataLoaded: {
                        dataModel.insertList(data)
                    }
                }
            ]
        }
        
    }
    
    onCreationCompleted: {
        dataSource.load();
    }
    
    
    attachedObjects: [
        ComponentDefinition {
            id: ledControl
            source: "LedControl.qml"
        },
        ComponentDefinition {
            id: wakeControl
            source: "WakeControl.qml"
        },
        ComponentDefinition {
            id: earsControl
            source: "EarsControl.qml"
        },
        ComponentDefinition {
            id: rfidControl
            source: "RFIDControl.qml"
        },
        ComponentDefinition {
            id: ttsControl
            source: "TTSControl.qml"
        },
        ComponentDefinition {
            id: pictureControl
            source: "PictureControl.qml"
        },
        ComponentDefinition {
            id: soundControl
            source: "SoundControl.qml"
        }
    ]
}
