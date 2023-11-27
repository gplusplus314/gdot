#SingleInstance Force

; Load library
#Include komorebic.lib.ahk

; Focus windows
#Left::CycleFocus("previous")
#Right::CycleFocus("next")

; Move windows
;!+h::Move("left")
;!+j::Move("down")
;!+k::Move("up")
;!+l::Move("right")
;!+Enter::Promote()
#+Left::CycleMove("previous")
#+Right::CycleMove("next")

; Stack windows
#!Left::Stack("left")
#!Right::Stack("right")
#!Up::Stack("up")
#!Down::Stack("down")
#!Esc::Unstack()
#Home::CycleStack("previous")
#End::CycleStack("next")

; Resize
#Up::ResizeAxis("vertical", "increase")
#Down::ResizeAxis("vertical", "decrease")
;!+=::ResizeAxis("vertical", "increase")
;!+-::ResizeAxis("vertical", "decrease")

; Manipulate windows
#f::ToggleFloat()
#m::ToggleMonocle()
#q::Close()

; Window manager options
#;::Retile()
#+;::ReloadConfiguration()
;!p::TogglePause()

; Workspaces
;!x::FlipLayout("horizontal")
;!y::FlipLayout("vertical")

#1::FocusWorkspace(0)
#2::FocusWorkspace(1)
#3::FocusWorkspace(2)
#4::FocusWorkspace(3)
#5::FocusWorkspace(4)
#6::FocusWorkspace(5)
#7::FocusWorkspace(6)
#8::FocusWorkspace(7)
#9::FocusWorkspace(8)
#0::FocusWorkspace(9)
#'::FocusWorkspace(10)
#\::FocusWorkspace(11)

; Move windows across workspaces
#+1::MoveToWorkspace(0)
#+2::MoveToWorkspace(1)
#+3::MoveToWorkspace(2)
#+4::MoveToWorkspace(3)
#+5::MoveToWorkspace(4)
#+6::MoveToWorkspace(5)
#+7::MoveToWorkspace(6)
#+8::MoveToWorkspace(7)
#+9::MoveToWorkspace(8)
#+0::MoveToWorkspace(9)
#+'::MoveToWorkspace(10)
#+\::MoveToWorkspace(11)
