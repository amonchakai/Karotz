import bb.cascades 1.3

Page {
    id: settingsPage
    
    
    titleBar: TitleBar {
        title: qsTr("New Radio")
        dismissAction: ActionItem {
            title: qsTr("Close")
            onTriggered: {
                // Emit the custom signal here to indicate that this page needs to be closed
                // The signal would be handled by the page which invoked it
                nav.pop();
            }
        }
        acceptAction: ActionItem {
            title: qsTr("Save")
            onTriggered: {
                if(id_radio == -1)
                    karotz.saveNewRadio(nameField.text, urlField.text);
                else 
                    karotz.updateRadio(id_radio, nameField.text, urlField.text);
                karotz.getRadioList();
                nameField.text = "";
                urlField.text = "";
                nav.pop();
            }
        }
    }
    
    property int id_radio
    property string name
    property string url_name
    
    ScrollView {
        id: settingPage
        property string userName;
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            id: headerContainer
            horizontalAlignment: HorizontalAlignment.Fill
            
            function themeStyleToHeaderColor(style){
                switch (style) {
                    case VisualStyle.Bright:
                        return Color.create(0.96,0.96,0.96);
                    case VisualStyle.Dark: 
                        return Color.create(0.15,0.15,0.15);
                    default :
                        return Color.create(0.96,0.96,0.96);    
                }
                return Color.create(0.96,0.96,0.96); 
            }
            
            // --------------------------------------------------------------------------
            // Login settings
            Container {
                layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                
                Label {
                    text: qsTr("New")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            
            }
            Divider { }
            
            Label {
                text: qsTr("Name")
            }
            
            TextField {
                id: nameField
                backgroundVisible: false
            }
            
            Label {
                text: qsTr("URL")
            }
            
            TextField {
                id: urlField
                backgroundVisible: false
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
                text: qsTr("Schedule playback")
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
                        text: qsTr("Play")
                        appearance: ControlAppearance.Primary
                        onClicked: {
                        }
                    }
                }
            }
            
        }
    }
    
    onNameChanged: {
        nameField.text = name;
    }
    
    onUrl_nameChanged: {
        urlField.text = url_name;
    }
} 
