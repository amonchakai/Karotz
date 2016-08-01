import bb.cascades 1.3

Page {
    property string id
    property string name
    property string color
    
    
    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                layout: DockLayout { }
                leftPadding: 10
                rightPadding: 10
                
                Label {
                    text: qsTr("Edit RFID Object")
                    textStyle {
                        color: Application.themeSupport.theme.colorTheme.style == VisualStyle.Dark ? Color.White : Color.Black
                    }
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        }
        
        
    }
    
    ScrollView {
        
        Container {
            Container {
                preferredHeight: ui.du(1)
            }
            
            // --------------------------------------------------------------------------
            
            Container {
                layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                
                Label {
                    text: qsTr("General information")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            
            }
            Divider { }
            
            TextField {
                id: textFieldName
                hintText: qsTr("Name")
                text: name
            }
            
            
            
            DropDown {
                title: qsTr("Color")
                id: colorDropdown
                options: [
                    Option {
                        text: qsTr("Red")
                        value: "red"
                    },
                    Option {
                        text: qsTr("Blue")
                        value: "blue"
                    },
                    Option {
                        text: qsTr("Green")
                        value: "green"
                    },
                    Option {
                        text: qsTr("Yellow")
                        value: "yellow"
                    },
                    Option {
                        text: qsTr("Pink")
                        value: "pink"
                    },
                    Option {
                        text: qsTr("Black")
                        value: "black"
                    },
                    Option {
                        text: qsTr("Gray")
                        value: "gray"
                    },
                    Option {
                        text: qsTr("Orange")
                        value: "orange"
                    },
                    Option {
                        text: qsTr("Purple")
                        value: "purple"
                    },
                    Option {
                        text: qsTr("White")
                        value: "white"
                    },
                    Option {
                        text: qsTr("Brown")
                        value: "brown"
                    }
                ]
                
                function colotToIdx(col) {
                    console.log(col)
                    if(col == "red") return 0;
                    if(col == "blue") return 1;
                    if(col == "green") return 2;
                    if(col == "yellow") return 3;
                    if(col == "pink") return 4;
                    if(col == "black") return 5;
                    if(col == "gray") return 6;
                    if(col == "orange") return 7;
                    if(col == "purple") return 8;
                    if(col == "white") return 9;
                    if(col == "brown") return 10;
                }
                selectedIndex: colotToIdx(color.toLowerCase())
            }
            
            Button {
                horizontalAlignment: HorizontalAlignment.Fill
                appearance: ControlAppearance.Primary
                text: qsTr("Apply")
                onClicked: {
                    karotz.editTag(id, textFieldName.text, colorDropdown.selectedIndex+1);
                }
            }
            
            
            
            
            Container {
                preferredHeight: ui.du(3)
            }
            
            // --------------------------------------------------------------------------
            
            Container {
                layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                
                Label {
                    text: qsTr("Actions")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            
            }
            Divider { }
            
            DropDown {
                id: actionType
                title: qsTr("Type of action")
                options: [
                    Option {
                        text: qsTr("External action")
                        value: 1
                    },
                    Option {
                        text: qsTr("Karotz action")
                        value: 2
                    }
                ]
                selectedIndex: 1
                
                onSelectedIndexChanged: {
                    externalActionContainer.visible = selectedIndex == 0;
                    karotzActionContainer.visible =  selectedIndex == 1;
                }
            }
            
            Container {
                id: externalActionContainer
                visible: false
                
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                Label {
                    text: qsTr("URL")
                }
                TextField {
                    id: urlExt
                    backgroundVisible: false
                }
                Label {
                    text: qsTr("Parameters")
                }
                TextField {
                    id: paramsExt
                    backgroundVisible: false
                }
            }
            
            Container {
                id: karotzActionContainer
                
                DropDown {
                    title: qsTr("Which action")
                    id: karotzActions
                    options: [
                        Option {
                            text: qsTr("Ears")
                            value: 1
                        },
                        Option {
                            text: qsTr("Network sound")
                            value: 2
                        },
                        Option {
                            text: qsTr("Seep")
                            value: 3
                        },
                        Option {
                            text: qsTr("Wake up")
                            value: 4
                        }
                    ]
                    
                    selectedIndex: 0
                    
                    onSelectedIndexChanged: {
                        leftEar.visible = selectedIndex == 0;
                        rightEar.visible = selectedIndex == 0;
                        leftEarLabel.visible = selectedIndex == 0;
                        rightEarLabel.visible = selectedIndex == 0;
                        
                        radioUrlLabel.visible = selectedIndex == 1
                        radioUrl.visible = selectedIndex == 1
                        
                    }
                }
                
                Label {
                    id: leftEarLabel
                    text: qsTr("Left ear")
                }
                Slider {
                    id: leftEar
                    value: 0
                    fromValue: 0
                    toValue: 16
                }
                Label {
                    id: rightEarLabel
                    text: qsTr("Right ear")
                }
                Slider {
                    id: rightEar
                    value: 0
                    fromValue: 0
                    toValue: 16
                }
                
                
                Label {
                    id: radioUrlLabel
                    text: qsTr("URL")
                    visible: false
                }
                TextField {
                    id: radioUrl
                    visible: false
                }
            
                
            }
            
            
            Button {
                horizontalAlignment: HorizontalAlignment.Fill
                appearance: ControlAppearance.Primary
                text: qsTr("Assign")
                onClicked: {
                    if(actionType.selectedIndex == 0) {
                        karotz.programRFID(id, textFieldName.text, urlExt.text, paramsExt.text);
                    } else {
                        switch (karotzActions.selectedIndex) {
                            case 0: {
                                    karotz.programRFID(id, textFieldName.text, "/cgi-bin/ears", "left=" + parseInt(leftEar.value) + "&right=" + parseInt(rightEar.value) + "&noreset=1");
                                break;
                            }
                            case 1: {
                                karotz.programRFID(id, textFieldName.text, "/cgi-bin/sound", "url=" + radioUrl.text);
                                break;
                            }
                            case 2: {
                                karotz.programRFID(id, textFieldName.text, "/cgi-bin/sleep", "");
                                break;
                            }
                            case 3: {
                                karotz.programRFID(id, textFieldName.text, "/cgi-bin/wakeup", "");
                                break;
                            }
                        }
                    }
                }
            }
            
        }
    }
}
