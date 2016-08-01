import bb.cascades 1.3
import Utility.NetImageTracker 1.0

Page {
    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                layout: DockLayout { }
                leftPadding: 10
                rightPadding: 10
                
                Label {
                    text: qsTr("Picture control")
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
                    text: qsTr("Picture")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            
            }
            Divider { }
            
            ImageView {
                horizontalAlignment: HorizontalAlignment.Center
                preferredHeight: ui.du(30)
                
                scalingMethod: ScalingMethod.AspectFit
                image: trackerOwn.image
                
                attachedObjects: [
                    NetImageTracker {
                        id: trackerOwn
                        imageSource: "asset:///images/empty_screen.png"                              
                    } 
                ]
            }
            
            
            Container {
                preferredHeight: ui.du(1)
            }
            
            // --------------------------------------------------------------------------
            
            Container {
                layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                
                Label {
                    text: qsTr("Control")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            
            }
            Divider { }
            
            Button {
                text: qsTr("Take a picture")
                horizontalAlignment: HorizontalAlignment.Center
                appearance: ControlAppearance.Primary
                onClicked: {
                    karotz.takePicture();
                }
            }
            
            Container {
                preferredHeight: ui.du(1)
            }
            
            // --------------------------------------------------------------------------
            
            Container {
                layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                
                Label {
                    text: qsTr("Take a picture & upload it")
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Bottom
                }
            
            }
            Divider { }
            
            
            Label {
                text: qsTr("Server IP")
            }
            TextField {
                id: ip
                backgroundVisible: false
            }
            Label {
                text: qsTr("User")
            }
            TextField {
                id: user
                backgroundVisible: false
            }
            Label {
                text: qsTr("Password")
            }
            TextField {
                id: password
                backgroundVisible: false
            }
            Label {
                text: qsTr("Directory")
            }
            TextField {
                id: dir
                backgroundVisible: false
            }
            
            Button {
                text: qsTr("Take")
                horizontalAlignment: HorizontalAlignment.Center
                appearance: ControlAppearance.Primary
                onClicked: {
                    karotz.takeUploadPicture(ip.text, user.text, password.text, dir.text);
                }
            }
            
            
        }    
    }
    
    onCreationCompleted: {
        karotz.setNetImage(trackerOwn);
    }
}
