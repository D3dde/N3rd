import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Wayland

Variants {

    model: Quickshell.screens

    PanelWindow {

        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }



		// same as hyprland gaps_out
        margins {
            left: 10
            right: 10
        }

		// workaround to rounded PanelWindow
        color: "transparent"

		// i like to treat the shell like every other windows so if i move a window i want it to be on top of everything
        aboveWindows: false

		// where you should change height
        height: 25

        // hyprland gaps_in = 3px so the distance between windows is actuall 6px (3px*2), and gaps_out is 10,
        // so to mantain 6px of gaps even for the shell you actually need to subtract 4 to gaps_out (10 - 4 = 6)
		// this is not possible but with this trick you can achieve a nice workaround, the problem with this
		// is that changing hyprland's gaps will certantly require to make some changes even here
        exclusiveZone: height-4

        WrapperRectangle {

        	// PanelWindow anchors
            anchors.fill: parent

            // border color
			color: "#81a1c1"

			// border width (same as hyrland but it is handled differently there)
			margin: 2

			// place it on top
			topMargin: 0

			// no roundings in the top angles
            topLeftRadius: 0
            topRightRadius: 0

            // bottom angles radius
			radius : 5

            Rectangle {

            	// same anchors and radius as the WeapperRectangle
                anchors.fill: parent.parent
                radius: parent.radius
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius

                // inner color
                color: "#2e3440"

                // SystemClock
                Text {
                	font.family: "JetBrainsMono Nerd Font Propo"
                    anchors.centerIn: parent
                    text: Qt.formatDateTime(clock.date, "| hh:mm | ddd MMM dd |")
                    color: "#d8dee9"

                }
                Text{
                    font.family: "JetBrainsMono Nerd Font Propo"
                	anchors.verticalCenter: parent.verticalCenter
                	anchors.right: parent.right
                	anchors.rightMargin: 25
                	text: "| "+(Math.round(Pipewire.defaultAudioSink?.audio.volume*100))+"% "+(Pipewire.defaultAudioSink?.audio.muted? "" : "")+" |"
                	color: "#d8dee9"
                }
                RowLayout{
                	Text{
                        font.family: "JetBrainsMono Nerd Font Propo"
                        text: "|"
                        color: "#d8dee9"
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 25
                    spacing: 10
                    Repeater{
                        model: Hyprland.workspaces
                        
                        Rectangle{
                            width: 15
                            height: 15
                            radius: 5
                            color: modelData.active ? "#81a1c1" : "#2e3440"
                            Text{
                            	font.family: "JetBrainsMono Nerd Font Propo"
                            	anchors.centerIn : parent
                                text: modelData.id
                                color: modelData.active ? "#2e3440" : "#d8dee9"
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch("workspace " + modelData.id)
                            }
                        }
                    }
                    Text{
                        font.family: "JetBrainsMono Nerd Font Propo"
                        text: "|"
                        color: "#d8dee9"
                    }
                }
            }
        }
        // SystemClock process
        SystemClock {
            id: clock
            precision: SystemClock.Seconds
        }
    	PwObjectTracker {
	        objects: [ Pipewire.defaultAudioSink ]
	    }
    }
}

