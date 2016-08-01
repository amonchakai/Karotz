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
                    text: qsTr("Wake up control")
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
                    text: qsTr("Wake up / Sleep")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            
            }
            Divider { }
            
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                
                layout: DockLayout {}
                
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    
                    Button {
                        text: qsTr("Wake up")
                        appearance: ControlAppearance.Primary
                        onClicked: {
                            karotz.wakeUp(1);
                        }
                    }
                    
                    Button {
                        text: qsTr("Sleep")
                        color: Color.Red
                        onClicked: {
                            karotz.sleep();
                        }
                    }
                }
            }
        
            
            
            // --------------------------------------------------------------------------
            
            Container {
                preferredHeight: ui.du(6)
            }
            
            Container {
                layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                
                Label {
                    text: qsTr("Schedule")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            }
            
            Divider { }
            
            
            DateTimePicker {
                title: qsTr("From")
                id: dataTime
                mode: DateTimePickerMode.DateTime
                horizontalAlignment: HorizontalAlignment.Fill
            }
            
            Container {
                preferredHeight: ui.du(1)
            }
            
            
            DateTimePicker {
                title: qsTr("Duration")
                id: duration
                mode: DateTimePickerMode.Timer
                horizontalAlignment: HorizontalAlignment.Fill
            }
            
            Label {
                text: qsTr("Repeat every:")
                textStyle.fontSize: FontSize.Large
            }
            
            Divider { }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
                
                CheckBox {
                    text: qsTr("Monday")
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
            }
            
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
                
                CheckBox {
                    text: qsTr("Tuesday")
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
                
                CheckBox {
                    text: qsTr("Wednesday")
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
                
                CheckBox {
                    text: qsTr("Thursday")
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
                
                CheckBox {
                    text: qsTr("Friday")
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
                
                CheckBox {
                    text: qsTr("Saturday")
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
                
                CheckBox {
                    text: qsTr("Sunday")
                }
                
                Container {
                    preferredWidth: ui.du(1)
                }
            }
            
            
            Container {
                preferredHeight: ui.du(3)
            }
            
            
            Label {
                text: qsTr("Schedule what")
                textStyle.fontSize: FontSize.Large
            }
            
            
            Divider { }
            
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                
                layout: DockLayout {}
                
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    
                    Button {
                        text: qsTr("Wake up")
                        appearance: ControlAppearance.Primary
                        onClicked: {
                            karotz.wakeUp(1);
                        }
                    }
                    
                    Button {
                        text: qsTr("Sleep")
                        color: Color.Red
                        onClicked: {
                            karotz.sleep();
                        }
                    }
                }
            }
        
        
        
        
        }    
    }
}
