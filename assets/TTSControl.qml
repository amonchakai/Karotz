import bb.cascades 1.3

Page {
    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                layout: DockLayout { }
                leftPadding: 10
                rightPadding: 10
                
                Label {
                    text: qsTr("TTS control")
                    textStyle {
                        color: Application.themeSupport.theme.colorTheme.style == VisualStyle.Dark ? Color.White : Color.Black
                    }
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        }
    }
    
    property variant pageEditRFID
    property bool recordState
    
    
    ScrollView {
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            
            Container {
                preferredHeight: ui.du(1)
            }
            
            
            // --------------------------------------------------------------------------
            
            Container {
                layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                
                Label {
                    text: qsTr("TTS cache")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            
            }
            Divider { visible: dataModel.empty }
            
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                layout: DockLayout { }
                
                Container {  
                    id: dataEmptyLabel
                    visible: dataModel.empty //model.isEmpty() will not work  
                    horizontalAlignment: HorizontalAlignment.Center  
                    verticalAlignment: VerticalAlignment.Center
                    
                    layout: DockLayout {}
                    
                    Label {
                        text: qsTr("Cache is empty.")
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Center
                    }
                }
                
                ListView {
                    id: ttsList
                    preferredHeight: ui.du(40)
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
                                    
                                    Label {
                                        text: ListItemData.voice + ": " + ListItemData.text
                                        verticalAlignment: VerticalAlignment.Center
                                    }
                                }
                                
                                Divider {}
                                
                            }
                        }
                    ]
                    
                    dataModel: GroupDataModel {
                        id: dataModel    
                        grouping: ItemGrouping.None
                        sortingKeys: ["id"]     
                        
                        property bool empty: true
                        
                        
                        onItemAdded: {
                            empty = isEmpty();
                        }
                        onItemRemoved: {
                            empty = isEmpty();
                        }  
                        onItemUpdated: empty = isEmpty()  
                        
                        // You might see an 'unknown signal' error  
                        // in the QML-editor, guess it's a SDK bug.  
                        onItemsChanged: empty = isEmpty()      
                    }
                
                }
            }
            
            Container {
                preferredHeight: ui.du(3)
            }
            
            
            // --------------------------------------------------------------------------
            
            Container {
                layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                
                Label {
                    text: qsTr("Speak")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            }
            
            Divider { }
            
            DropDown {
                id: voice
                title: qsTr("Voice")
                options: [
                    Option {
                        text: "Alice (FR)"
                        value: "alice"
                    },
                    Option {
                        text: "Claire (FR)"
                        value: "claire"
                    },
                    Option {
                        text: "Julie (FR)"
                        value: "julie"
                    },
                    Option {
                        text: "Margaux (FR)"
                        value: "margaux"
                    },
                    Option {
                        text: "Antoine (FR)"
                        value: "antoine"
                    },
                    Option {
                        text: "Bruno (FR)"
                        value: "bruno"
                    },
                    Option {
                        text: "Louise (CA)"
                        value: "louise"
                    },
                    Option {
                        text: "Justine (BE)"
                        value: "justine"
                    },
                    Option {
                        text: "Heather (US)"
                        value: "heather"
                    },
                    Option {
                        text: "Ryan (US)"
                        value: "ryan"
                    },
                    Option {
                        text: "Lucy (UK)"
                        value: "lucy"
                    },
                    Option {
                        text: "Graham (UK)"
                        value: "graham"
                    },
                    Option {
                        text: "Andreas (DE)"
                        value: "andreas"
                    },
                    Option {
                        text: "Julia (DE)"
                        value: "julia"
                    },
                    Option {
                        text: "Chiara (IT)"
                        value: "chiara"
                    },
                    Option {
                        text: "Vittorio (IT)"
                        value: "vittorio"
                    }
                ]
                
                selectedIndex: 0
            }
            
            Label {
                text: qsTr("Text")
            }
            TextField {
                id: textTTS
                backgroundVisible: false
            }
            Container {
                layout: DockLayout {}
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Center
                
                Container {
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Center
                    
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Container {
                        preferredWidth: ui.du(1)
                    }
                    
                    Label {
                        verticalAlignment: VerticalAlignment.Center
                        text: qsTr("Enable Cache")
                    }
                }
                
                Container {
                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Center
                    
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    ToggleButton {
                        id: enableCache
                        checked: true
                        verticalAlignment: VerticalAlignment.Center
                    }
                    
                    Container {
                        preferredWidth: ui.du(1)
                    }
                }
            }
            
            Button {
                horizontalAlignment: HorizontalAlignment.Center
                appearance: ControlAppearance.Primary
                text: qsTr("Speak")
                
                onClicked: {
                    karotz.speak(textTTS.text, voice.selectedValue, enableCache.checked);
                }
            }
        }  
    }
    
    
    
    
    actions: [
        ActionItem {
            id: refresh
            imageSource: "asset:///images/icon_refresh.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            title: qsTr("Refresh")
            onTriggered: {
                karotz.getTTSList();
            }
        },
        ActionItem {
            id: clearCache
            imageSource: "asset:///images/can.png"
            title: qsTr("Clear cache")
            onTriggered: {
                karotz.clearTTSCache();
            }
        }
    ]
    
    onCreationCompleted: {
        recordState = false;
        karotz.setTTSListView(ttsList);
        karotz.getTTSList();
    }
}
